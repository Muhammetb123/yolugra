import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/app_localizations.dart';
import 'tk_localizations.dart';

export 'generated/app_localizations.dart';

/// Turkmen is the primary language; Russian and English follow.
const supportedLocales = [Locale('tk'), Locale('ru'), Locale('en')];

const fallbackLocale = Locale('tk');

/// Turkmen delegates come first: the global Flutter delegates do not support `tk`.
const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  TkMaterialLocalizations.delegate,
  TkCupertinoLocalizations.delegate,
  TkWidgetsLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
];

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  String get languageCode => Localizations.localeOf(this).languageCode;
}

/// Picks a supported locale for a device locale, falling back to Turkmen.
Locale resolveLocale(Locale? device) {
  for (final l in supportedLocales) {
    if (l.languageCode == device?.languageCode) return l;
  }
  return fallbackLocale;
}
