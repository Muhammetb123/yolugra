import 'dart:async';

import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../errors/app_exception.dart';
import '../storage/session_storage.dart';

typedef LanguageProvider = String Function();

/// The single HTTP gateway to the Go backend. It adds the access token and the app
/// language, refreshes an expired access token once, and turns every failure into an
/// [AppException] with the backend's stable error code.
class ApiClient {
  ApiClient({required SessionStorage session, required LanguageProvider language, Dio? dio, Dio? refreshDio})
      : _session = session,
        _language = language,
        _dio = dio ?? Dio(_options()),
        _refreshDio = refreshDio ?? Dio(_options()) {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: _onRequest, onError: _onError));
  }

  final SessionStorage _session;
  final LanguageProvider _language;
  final Dio _dio;
  final Dio _refreshDio;
  final _expired = StreamController<void>.broadcast();
  Future<bool>? _refreshing;

  /// Fires when the session cannot be refreshed any more and the user must sign in.
  Stream<void> get sessionExpired => _expired.stream;

  static BaseOptions _options() => BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      );

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query}) =>
      _send(() => _dio.get<dynamic>(path, queryParameters: _clean(query)));

  Future<Map<String, dynamic>> post(String path, {Object? body}) =>
      _send(() => _dio.post<dynamic>(path, data: body ?? const <String, dynamic>{}));

  Future<Map<String, dynamic>> patch(String path, {Object? body}) => _send(() => _dio.patch<dynamic>(path, data: body));

  Future<Map<String, dynamic>> put(String path, {Object? body}) => _send(() => _dio.put<dynamic>(path, data: body));

  Future<Map<String, dynamic>> delete(String path) => _send(() => _dio.delete<dynamic>(path));

  Future<Map<String, dynamic>> upload(String path, String filePath, {String field = 'photo'}) async {
    final form = FormData.fromMap({field: await MultipartFile.fromFile(filePath)});
    return _send(() => _dio.post<dynamic>(path, data: form, options: Options(contentType: 'multipart/form-data')));
  }

  /// Unauthenticated calls (OTP login, refresh) skip the token and the refresh logic.
  Future<Map<String, dynamic>> publicPost(String path, Map<String, dynamic> body) => _send(
        () => _plain.post<dynamic>(path, data: body, options: Options(headers: {'Accept-Language': _language()})),
      );

  /// The client without interceptors, pointed at the current backend address.
  Dio get _plain => _refreshDio..options.baseUrl = AppConfig.apiBaseUrl;

  Map<String, dynamic>? _clean(Map<String, dynamic>? q) => q == null
      ? null
      : (Map.of(q)..removeWhere((_, v) => v == null || (v is String && v.isEmpty) || v == false));

  Future<Map<String, dynamic>> _send(Future<Response<dynamic>> Function() call) async {
    try {
      final res = await call();
      final data = res.data;
      if (data is Map<String, dynamic>) return data;
      return const {};
    } on DioException catch (e) {
      throw mapError(e);
    }
  }

  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Read per request: a debug build can switch the backend address at runtime.
    options.baseUrl = AppConfig.apiBaseUrl;
    options.headers['Accept-Language'] = _language();
    final token = _session.accessToken;
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  Future<void> _onError(DioException e, ErrorInterceptorHandler handler) async {
    final retried = e.requestOptions.extra['retried'] == true;
    if (e.response?.statusCode != 401 || retried || await _session.readRefreshToken() == null) {
      return handler.next(e);
    }
    if (!await refreshSession()) {
      _expired.add(null);
      return handler.next(e);
    }
    final opts = e.requestOptions
      ..extra['retried'] = true
      ..headers['Authorization'] = 'Bearer ${_session.accessToken}';
    try {
      handler.resolve(await _dio.fetch<dynamic>(opts));
    } on DioException catch (again) {
      handler.next(again);
    }
  }

  /// Rotates the refresh token. Concurrent callers share one request.
  Future<bool> refreshSession() => _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);

  Future<bool> _doRefresh() async {
    final refresh = await _session.readRefreshToken();
    if (refresh == null) return false;
    try {
      final res = await _plain.post<dynamic>('/v1/auth/refresh', data: {
        'refresh_token': refresh,
        'device_id': await _session.deviceId(),
      });
      final data = res.data as Map<String, dynamic>;
      await _session.save(accessToken: data['access_token'] as String, refreshToken: data['refresh_token'] as String);
      return true;
    } on DioException catch (e) {
      // A network failure keeps the stored token for the next attempt; a rejected
      // token means the session is over.
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) await _session.clear();
      return false;
    }
  }

  /// Converts a Dio failure into an [AppException].
  static AppException mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppException(AppException.timeout);
      case DioExceptionType.connectionError:
        return const AppException(AppException.network);
      default:
        break;
    }
    final res = e.response;
    if (res == null) return const AppException(AppException.network);
    final body = res.data;
    Duration? retryAfter;
    final ra = int.tryParse(res.headers.value('retry-after') ?? '');
    if (ra != null) retryAfter = Duration(seconds: ra);
    if (body is Map && body['error'] is Map) {
      final err = body['error'] as Map;
      final details = <String, String>{};
      if (err['details'] is Map) {
        (err['details'] as Map).forEach((k, v) => details['$k'] = '$v');
      }
      return AppException(
        '${err['code'] ?? AppException.unknown}',
        statusCode: res.statusCode,
        field: err['field'] as String?,
        details: details,
        retryAfter: retryAfter,
      );
    }
    return AppException(res.statusCode != null && res.statusCode! >= 500 ? AppException.server : AppException.unknown,
        statusCode: res.statusCode);
  }

  void dispose() => _expired.close();
}
