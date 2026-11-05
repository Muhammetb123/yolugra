import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../bloc/settings_cubit.dart';

String languageName(AppLocalizations l, String code) => switch (code) {
      'ru' => l.languageRu,
      'en' => l.languageEn,
      _ => l.languageTk,
    };

/// A compact language menu for screens without the settings page (sign-in).
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final current = context.watch<SettingsCubit>().state;
    return PopupMenuButton<Locale>(
      initialValue: current,
      onSelected: context.read<SettingsCubit>().setLocale,
      itemBuilder: (_) => [
        for (final loc in supportedLocales) PopupMenuItem(value: loc, child: Text(languageName(l, loc.languageCode))),
      ],
      child: Chip(avatar: const Icon(Icons.translate_rounded, size: 18), label: Text(languageName(l, current.languageCode))),
    );
  }
}
