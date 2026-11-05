import 'dart:ui';

abstract interface class SettingsRepository {
  /// The chosen app language, or null when the user has not chosen one yet.
  Locale? get locale;
  Future<void> saveLocale(Locale locale);
}
