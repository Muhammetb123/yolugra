/// Build-time configuration. The defaults are the production server and site; a local
/// backend needs `flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8081` (with
/// `adb reverse tcp:8081 tcp:8081`) or the server address dialog of a debug build.
abstract final class AppConfig {
  static const buildApiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.yolugra.tech');

  static String _apiBaseUrl = buildApiBaseUrl;

  /// The backend address in use. It equals [buildApiBaseUrl] unless a debug or profile
  /// build was pointed elsewhere on the device (see ServerAddress).
  static String get apiBaseUrl => _apiBaseUrl;

  /// Only ServerAddress calls this.
  static void useApiBaseUrl(String url) => _apiBaseUrl = url;

  /// The public site with the privacy policy and the terms of use, without a trailing
  /// slash. `--dart-define=WEBSITE_URL=` (empty) hides the links to it.
  static const websiteUrl = String.fromEnvironment('WEBSITE_URL', defaultValue: 'https://yolugra.tech');

  /// A page of the public site in [languageCode] (tk, ru, en), for example `privacy`
  /// → `/ru/privacy.html`. Null when the build has no site address.
  static Uri? sitePage(String page, String languageCode, {String base = websiteUrl}) {
    if (base.isEmpty) return null;
    final root = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    return Uri.tryParse('$root/$languageCode/$page.html');
  }

  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 20);

  /// How often the app asks for new notifications while it is in the foreground.
  static const notificationPollInterval = Duration(seconds: 45);

  static const currency = 'TMT';

  /// Resolves a media path returned by the API (for example /media/x.jpg).
  static String mediaUrl(String path) => path.startsWith('http') ? path : '$apiBaseUrl$path';
}
