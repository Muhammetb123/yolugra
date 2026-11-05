/// A failure the UI can explain. [code] is the backend's stable error code
/// (for example INSUFFICIENT_SEATS) or one of the client codes below.
class AppException implements Exception {
  const AppException(this.code, {this.statusCode, this.field, this.details = const {}, this.retryAfter});

  final String code;
  final int? statusCode;
  final String? field;
  final Map<String, String> details;
  final Duration? retryAfter;

  static const network = 'NETWORK';
  static const timeout = 'TIMEOUT';
  static const unknown = 'UNKNOWN';
  static const server = 'INTERNAL';
  static const unauthorized = 'UNAUTHORIZED';

  bool get isUnauthorized => code == unauthorized;

  @override
  String toString() => 'AppException($code, $statusCode, $field)';
}
