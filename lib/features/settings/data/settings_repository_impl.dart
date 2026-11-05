import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;
  static const _localeKey = 'locale';

  @override
  Locale? get locale {
    final code = _prefs.getString(_localeKey);
    return code == null ? null : Locale(code);
  }

  @override
  Future<void> saveLocale(Locale locale) => _prefs.setString(_localeKey, locale.languageCode);
}
