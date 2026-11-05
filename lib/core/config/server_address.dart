import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_config.dart';

/// Lets a debug or profile build talk to a backend on another address without a rebuild,
/// for example the laptop on the same Wi-Fi, whose IP the router may change.
/// Release builds ignore any stored value and always use [AppConfig.buildApiBaseUrl].
class ServerAddress {
  ServerAddress(this._prefs) {
    final stored = editable ? _prefs.getString(_key) : null;
    AppConfig.useApiBaseUrl(stored ?? AppConfig.buildApiBaseUrl);
  }

  final SharedPreferences _prefs;
  static const _key = 'dev_api_base_url';

  static bool get editable => !kReleaseMode;

  String get current => AppConfig.apiBaseUrl;
  bool get isOverridden => current != AppConfig.buildApiBaseUrl;

  /// Accepts "192.168.1.10:8081", "http://host:8081/" and similar. Returns
  /// "scheme://host[:port]" or null when the text is not an address.
  static String? normalize(String raw) {
    var text = raw.trim();
    if (text.isEmpty) return null;
    if (!text.contains('://')) text = 'http://$text';
    final uri = Uri.tryParse(text);
    if (uri == null || uri.host.isEmpty || (uri.scheme != 'http' && uri.scheme != 'https')) return null;
    return uri.hasPort ? '${uri.scheme}://${uri.host}:${uri.port}' : '${uri.scheme}://${uri.host}';
  }

  /// Saves [url], or goes back to the build address when [url] is null.
  Future<void> set(String? url) async {
    if (!editable) return;
    if (url == null || url == AppConfig.buildApiBaseUrl) {
      await _prefs.remove(_key);
      AppConfig.useApiBaseUrl(AppConfig.buildApiBaseUrl);
    } else {
      await _prefs.setString(_key, url);
      AppConfig.useApiBaseUrl(url);
    }
  }

  /// True when GET [url]/healthz answers within a few seconds.
  static Future<bool> reachable(String url, {Dio? dio}) async {
    final client = dio ?? Dio(BaseOptions(connectTimeout: const Duration(seconds: 4), receiveTimeout: const Duration(seconds: 4)));
    try {
      final res = await client.get<dynamic>('$url/healthz');
      return res.statusCode == 200;
    } on DioException {
      return false;
    }
  }
}
