/// Build-time configuration. Override with
/// `flutter run --dart-define=API_BASE_URL=https://api.example.tm`.
///
/// The default targets local development: the backend runs on the computer at port
/// 8081 and `adb reverse tcp:8081 tcp:8081` maps 127.0.0.1 on the phone to it.
abstract final class AppConfig {
  static const buildApiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://127.0.0.1:8081');

  static String _apiBaseUrl = buildApiBaseUrl;

  /// The backend address in use. It equals [buildApiBaseUrl] unless a debug or profile
  /// build was pointed elsewhere on the device (see ServerAddress).
  static String get apiBaseUrl => _apiBaseUrl;

  /// Only ServerAddress calls this.
  static void useApiBaseUrl(String url) => _apiBaseUrl = url;

  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 20);

  /// How often the app asks for new notifications while it is in the foreground.
  static const notificationPollInterval = Duration(seconds: 45);

  static const currency = 'TMT';

  /// Resolves a media path returned by the API (for example /media/x.jpg).
  static String mediaUrl(String path) => path.startsWith('http') ? path : '$apiBaseUrl$path';
}
