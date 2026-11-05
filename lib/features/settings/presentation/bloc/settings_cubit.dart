import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../domain/settings_repository.dart';

/// The app language. It persists across restarts and is sent to the backend as
/// Accept-Language, so server texts (SMS, errors) follow the same language.
class SettingsCubit extends Cubit<Locale> {
  SettingsCubit(this._repo, {Locale? device}) : super(_repo.locale ?? resolveLocale(device));

  final SettingsRepository _repo;

  Future<void> setLocale(Locale locale) async {
    if (locale == state) return;
    emit(locale);
    await _repo.saveLocale(locale);
  }
}
