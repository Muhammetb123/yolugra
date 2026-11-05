// Turkmen support for the framework localizations.
//
// Flutter ships Material, Cupertino and widgets translations and intl date symbols for
// many languages, but not for Turkmen. This file registers Turkmen date symbols the same
// way flutter_localizations registers its own (initializeDateFormattingCustom), and
// provides delegates whose visible strings are Turkmen. Keyboard key names, which a
// phone never shows, stay as in the English base classes.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart' as intl;

const _tk = 'tk';

bool _dateDataRegistered = false;

/// Registers Turkmen date symbols so `DateFormat(..., 'tk')` works.
void registerTurkmenDateSymbols() {
  if (_dateDataRegistered) return;
  initializeDateFormattingCustom(locale: _tk, symbols: _tkSymbols, patterns: _tkPatterns);
  _dateDataRegistered = true;
}

final _tkSymbols = DateSymbols(
  NAME: _tk,
  ERAS: const ['B.e.öň', 'B.e.'],
  ERANAMES: const ['biziň eramyzdan öň', 'biziň eramyz'],
  NARROWMONTHS: const ['Ý', 'F', 'M', 'A', 'M', 'I', 'I', 'A', 'S', 'O', 'N', 'D'],
  STANDALONENARROWMONTHS: const ['Ý', 'F', 'M', 'A', 'M', 'I', 'I', 'A', 'S', 'O', 'N', 'D'],
  MONTHS: const ['ýanwar', 'fewral', 'mart', 'aprel', 'maý', 'iýun', 'iýul', 'awgust', 'sentýabr', 'oktýabr', 'noýabr', 'dekabr'],
  STANDALONEMONTHS: const ['Ýanwar', 'Fewral', 'Mart', 'Aprel', 'Maý', 'Iýun', 'Iýul', 'Awgust', 'Sentýabr', 'Oktýabr', 'Noýabr', 'Dekabr'],
  SHORTMONTHS: const ['ýan', 'few', 'mart', 'apr', 'maý', 'iýun', 'iýul', 'awg', 'sen', 'okt', 'noý', 'dek'],
  STANDALONESHORTMONTHS: const ['Ýan', 'Few', 'Mart', 'Apr', 'Maý', 'Iýun', 'Iýul', 'Awg', 'Sen', 'Okt', 'Noý', 'Dek'],
  WEEKDAYS: const ['ýekşenbe', 'duşenbe', 'sişenbe', 'çarşenbe', 'penşenbe', 'anna', 'şenbe'],
  STANDALONEWEEKDAYS: const ['Ýekşenbe', 'Duşenbe', 'Sişenbe', 'Çarşenbe', 'Penşenbe', 'Anna', 'Şenbe'],
  SHORTWEEKDAYS: const ['ýb', 'db', 'sb', 'çb', 'pb', 'an', 'şb'],
  STANDALONESHORTWEEKDAYS: const ['Ýb', 'Db', 'Sb', 'Çb', 'Pb', 'An', 'Şb'],
  NARROWWEEKDAYS: const ['Ý', 'D', 'S', 'Ç', 'P', 'A', 'Ş'],
  STANDALONENARROWWEEKDAYS: const ['Ý', 'D', 'S', 'Ç', 'P', 'A', 'Ş'],
  SHORTQUARTERS: const ['1Ç', '2Ç', '3Ç', '4Ç'],
  QUARTERS: const ['1-nji çärýek', '2-nji çärýek', '3-nji çärýek', '4-nji çärýek'],
  AMPMS: const ['go.öň', 'go.soň'],
  DATEFORMATS: const ['d MMMM y EEEE', 'd MMMM y', 'd MMM y', 'dd.MM.y'],
  TIMEFORMATS: const ['HH:mm:ss zzzz', 'HH:mm:ss z', 'HH:mm:ss', 'HH:mm'],
  FIRSTDAYOFWEEK: 0,
  WEEKENDRANGE: const [5, 6],
  FIRSTWEEKCUTOFFDAY: 6,
  DATETIMEFORMATS: const ['{1} {0}', '{1} {0}', '{1} {0}', '{1} {0}'],
);

const _tkPatterns = <String, String>{
  'd': 'd',
  'E': 'ccc',
  'EEEE': 'cccc',
  'LLL': 'LLL',
  'LLLL': 'LLLL',
  'M': 'L',
  'Md': 'dd.MM',
  'MEd': 'dd.MM EEE',
  'MMM': 'LLL',
  'MMMd': 'd MMM',
  'MMMEd': 'd MMM EEE',
  'MMMM': 'LLLL',
  'MMMMd': 'd MMMM',
  'MMMMEEEEd': 'd MMMM EEEE',
  'QQQ': 'QQQ',
  'QQQQ': 'QQQQ',
  'y': 'y',
  'yM': 'MM.y',
  'yMd': 'dd.MM.y',
  'yMEd': 'dd.MM.y EEE',
  'yMMM': 'MMM y',
  'yMMMd': 'd MMM y',
  'yMMMEd': 'd MMM y EEE',
  'yMMMM': 'MMMM y',
  'yMMMMd': 'd MMMM y',
  'yMMMMEEEEd': 'd MMMM y EEEE',
  'yQQQ': 'y QQQ',
  'yQQQQ': 'y QQQQ',
  'H': 'HH',
  'Hm': 'HH:mm',
  'Hms': 'HH:mm:ss',
  'j': 'HH',
  'jm': 'HH:mm',
  'jms': 'HH:mm:ss',
  'jmv': 'HH:mm v',
  'jmz': 'HH:mm z',
  'jz': 'HH z',
  'm': 'm',
  'ms': 'mm:ss',
  's': 's',
  'v': 'v',
  'z': 'z',
  'zzzz': 'zzzz',
  'ZZZZ': 'ZZZZ',
};

/// Material strings in Turkmen.
class TkMaterialLocalizations extends MaterialLocalizationEn {
  TkMaterialLocalizations()
      : super(
          localeName: _tk,
          fullYearFormat: intl.DateFormat.y(_tk),
          compactDateFormat: intl.DateFormat.yMd(_tk),
          shortDateFormat: intl.DateFormat.yMMMd(_tk),
          mediumDateFormat: intl.DateFormat.MMMEd(_tk),
          longDateFormat: intl.DateFormat.yMMMMEEEEd(_tk),
          yearMonthFormat: intl.DateFormat.yMMMM(_tk),
          shortMonthDayFormat: intl.DateFormat.MMMd(_tk),
          // intl has no Turkmen number data; Turkmen uses the same digits.
          decimalFormat: intl.NumberFormat.decimalPattern('en'),
          twoDigitZeroPaddedFormat: intl.NumberFormat('00', 'en'),
        );

  @override String get aboutListTileTitleRaw => r'$applicationName barada';
  @override String get alertDialogLabel => 'Duýduryş';
  @override String get anteMeridiemAbbreviation => 'go.öň';
  @override String get postMeridiemAbbreviation => 'go.soň';
  @override String get backButtonTooltip => 'Yza';
  @override String get bottomSheetLabel => 'Aşaky panel';
  @override String get calendarModeButtonLabel => 'Senenama geç';
  @override String get cancelButtonLabel => 'Ýatyr';
  @override String get clearButtonTooltip => 'Teksti arassala';
  @override String get closeButtonLabel => 'Ýap';
  @override String get closeButtonTooltip => 'Ýap';
  @override String get collapsedHint => 'Açyk';
  @override String get collapsedIconTapHint => 'Aç';
  @override String get continueButtonLabel => 'Dowam et';
  @override String get copyButtonLabel => 'Göçür';
  @override String get currentDateLabel => 'Şu gün';
  @override String get cutButtonLabel => 'Kes';
  @override String get dateHelpText => 'gg.aa.ýýýý';
  @override String get dateInputLabel => 'Senäni giriziň';
  @override String get dateOutOfRangeLabel => 'Aralykdan daşarda.';
  @override String get datePickerHelpText => 'Senäni saýlaň';
  @override String get dateRangeEndDateSemanticLabelRaw => r'Gutarýan senesi $fullDate';
  @override String get dateRangeEndLabel => 'Gutarýan senesi';
  @override String get dateRangePickerHelpText => 'Aralygy saýlaň';
  @override String get dateRangeStartDateSemanticLabelRaw => r'Başlaýan senesi $fullDate';
  @override String get dateRangeStartLabel => 'Başlaýan senesi';
  @override String get dateSeparator => '.';
  @override String get deleteButtonTooltip => 'Poz';
  @override String get dialModeButtonLabel => 'Siferblata geç';
  @override String get dialogLabel => 'Dialog';
  @override String get drawerLabel => 'Nawigasiýa menýusy';
  @override String get expandedHint => 'Ýapyk';
  @override String get expandedIconTapHint => 'Ýygna';
  @override String get expansionTileCollapsedHint => 'açmak üçin iki gezek basyň';
  @override String get expansionTileCollapsedTapHint => 'Jikme-jiklikler üçin açyň';
  @override String get expansionTileExpandedHint => 'ýygnamak üçin iki gezek basyň';
  @override String get expansionTileExpandedTapHint => 'Ýygna';
  @override String get firstPageTooltip => 'Birinji sahypa';
  @override String get hideAccountsLabel => 'Hasaplary gizle';
  @override String get inputDateModeButtonLabel => 'Girizmä geç';
  @override String get inputTimeModeButtonLabel => 'Tekst girizmä geç';
  @override String get invalidDateFormatLabel => 'Nädogry format.';
  @override String get invalidDateRangeLabel => 'Nädogry aralyk.';
  @override String get invalidTimeLabel => 'Dogry wagty giriziň';
  @override String get lastPageTooltip => 'Soňky sahypa';
  @override String? get licensesPackageDetailTextOne => '1 ygtyýarnama';
  @override String get licensesPackageDetailTextOther => r'$licenseCount ygtyýarnama';
  @override String? get licensesPackageDetailTextZero => 'Ygtyýarnama ýok';
  @override String get licensesPageTitle => 'Ygtyýarnamalar';
  @override String get lookUpButtonLabel => 'Gözle';
  @override String get menuBarMenuLabel => 'Menýu';
  @override String get menuDismissLabel => 'Menýuny ýap';
  @override String get modalBarrierDismissLabel => 'Ýap';
  @override String get moreButtonTooltip => 'Ýene';
  @override String get nextMonthTooltip => 'Indiki aý';
  @override String get nextPageTooltip => 'Indiki sahypa';
  @override String get okButtonLabel => 'Bolýar';
  @override String get openAppDrawerTooltip => 'Nawigasiýa menýusyny aç';
  @override String get pageRowsInfoTitleRaw => r'$firstRow–$lastRow / $rowCount';
  @override String get pageRowsInfoTitleApproximateRaw => r'$firstRow–$lastRow / takmynan $rowCount';
  @override String get pasteButtonLabel => 'Goý';
  @override String get popupMenuLabel => 'Menýu';
  @override String get previousMonthTooltip => 'Öňki aý';
  @override String get previousPageTooltip => 'Öňki sahypa';
  @override String get refreshIndicatorSemanticLabel => 'Täzele';
  @override String? get remainingTextFieldCharacterCountOne => '1 harp galdy';
  @override String get remainingTextFieldCharacterCountOther => r'$remainingCount harp galdy';
  @override String? get remainingTextFieldCharacterCountZero => 'Harp galmady';
  @override String get reorderItemDown => 'Aşak süýşür';
  @override String get reorderItemLeft => 'Çepe süýşür';
  @override String get reorderItemRight => 'Saga süýşür';
  @override String get reorderItemToEnd => 'Ahyryna süýşür';
  @override String get reorderItemToStart => 'Başyna süýşür';
  @override String get reorderItemUp => 'Ýokary süýşür';
  @override String get rowsPerPageTitle => 'Sahypadaky setir:';
  @override String get saveButtonLabel => 'Ýatda sakla';
  @override String get scanTextButtonLabel => 'Teksti skanirle';
  @override String get scrimLabel => 'Fon';
  @override String get scrimOnTapHintRaw => r'$modalRouteContentName ýap';
  @override String get searchFieldLabel => 'Gözleg';
  @override String get searchWebButtonLabel => 'Internetde gözle';
  @override String get selectAllButtonLabel => 'Hemmesini saýla';
  @override String get selectYearSemanticsLabel => 'Ýyly saýlaň';
  @override String get selectedDateLabel => 'Saýlandy';
  @override String? get selectedRowCountTitleOne => '1 element saýlandy';
  @override String get selectedRowCountTitleOther => r'$selectedRowCount element saýlandy';
  @override String? get selectedRowCountTitleZero => 'Hiç zat saýlanmady';
  @override String get shareButtonLabel => 'Paýlaş';
  @override String get showAccountsLabel => 'Hasaplary görkez';
  @override String get showMenuTooltip => 'Menýuny görkez';
  @override String get signedInLabel => 'Girildi';
  @override String get tabLabelRaw => r'$tabCount bölümden $tabIndex';
  @override TimeOfDayFormat get timeOfDayFormatRaw => TimeOfDayFormat.HH_colon_mm;
  @override String get timePickerDialHelpText => 'Wagty saýlaň';
  @override String get timePickerHourLabel => 'Sagat';
  @override String get timePickerHourModeAnnouncement => 'Sagady saýlaň';
  @override String get timePickerInputHelpText => 'Wagty giriziň';
  @override String get timePickerMinuteLabel => 'Minut';
  @override String get timePickerMinuteModeAnnouncement => 'Minudy saýlaň';
  @override String get unspecifiedDate => 'Sene';
  @override String get unspecifiedDateRange => 'Sene aralygy';
  @override String get viewLicensesButtonLabel => 'Ygtyýarnamalary gör';

  static const LocalizationsDelegate<MaterialLocalizations> delegate = _TkMaterialDelegate();
}

class _TkMaterialDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const _TkMaterialDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == _tk;

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    registerTurkmenDateSymbols();
    return SynchronousFuture<MaterialLocalizations>(TkMaterialLocalizations());
  }

  @override
  bool shouldReload(_TkMaterialDelegate old) => false;
}

/// Cupertino strings in Turkmen.
class TkCupertinoLocalizations extends CupertinoLocalizationEn {
  TkCupertinoLocalizations()
      : super(
          localeName: _tk,
          fullYearFormat: intl.DateFormat.y(_tk),
          dayFormat: intl.DateFormat.d(_tk),
          weekdayFormat: intl.DateFormat.E(_tk),
          mediumDateFormat: intl.DateFormat.MMMEd(_tk),
          singleDigitHourFormat: intl.DateFormat('H', _tk),
          singleDigitMinuteFormat: intl.DateFormat.m(_tk),
          doubleDigitMinuteFormat: intl.DateFormat('mm', _tk),
          singleDigitSecondFormat: intl.DateFormat.s(_tk),
          decimalFormat: intl.NumberFormat.decimalPattern('en'),
        );

  @override String get alertDialogLabel => 'Duýduryş';
  @override String get anteMeridiemAbbreviation => 'go.öň';
  @override String get postMeridiemAbbreviation => 'go.soň';
  @override String get backButtonLabel => 'Yza';
  @override String get cancelButtonLabel => 'Ýatyr';
  @override String get clearButtonLabel => 'Arassala';
  @override String get copyButtonLabel => 'Göçür';
  @override String get cutButtonLabel => 'Kes';
  @override String get datePickerDateOrderString => 'dmy';
  @override String get datePickerDateTimeOrderString => 'date_time_dayPeriod';
  @override String get datePickerHourSemanticsLabelOther => r'sagat $hour';
  @override String? get datePickerHourSemanticsLabelOne => r'sagat $hour';
  @override String get datePickerMinuteSemanticsLabelOther => r'$minute minut';
  @override String? get datePickerMinuteSemanticsLabelOne => '1 minut';
  @override String get lookUpButtonLabel => 'Gözle';
  @override String get menuDismissLabel => 'Menýuny ýap';
  @override String get modalBarrierDismissLabel => 'Ýap';
  @override String get noSpellCheckReplacementsLabel => 'Çalşyk tapylmady';
  @override String get pasteButtonLabel => 'Goý';
  @override String get searchTextFieldPlaceholderLabel => 'Gözleg';
  @override String get searchWebButtonLabel => 'Internetde gözle';
  @override String get selectAllButtonLabel => 'Hemmesini saýla';
  @override String get shareButtonLabel => 'Paýlaş...';
  @override String get tabSemanticsLabelRaw => r'$tabCount bölümden $tabIndex';
  @override String get timerPickerHourLabelOther => 'sagat';
  @override String? get timerPickerHourLabelOne => 'sagat';
  @override String get timerPickerMinuteLabelOther => 'min.';
  @override String? get timerPickerMinuteLabelOne => 'min.';
  @override String get timerPickerSecondLabelOther => 'sek.';
  @override String? get timerPickerSecondLabelOne => 'sek.';
  @override String get todayLabel => 'Şu gün';

  static const LocalizationsDelegate<CupertinoLocalizations> delegate = _TkCupertinoDelegate();
}

class _TkCupertinoDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const _TkCupertinoDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == _tk;

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    registerTurkmenDateSymbols();
    return SynchronousFuture<CupertinoLocalizations>(TkCupertinoLocalizations());
  }

  @override
  bool shouldReload(_TkCupertinoDelegate old) => false;
}

/// Basic widget strings (text selection, reordering) in Turkmen.
class TkWidgetsLocalizations extends DefaultWidgetsLocalizations {
  const TkWidgetsLocalizations();

  @override String get copyButtonLabel => 'Göçür';
  @override String get cutButtonLabel => 'Kes';
  @override String get lookUpButtonLabel => 'Gözle';
  @override String get pasteButtonLabel => 'Goý';
  @override String get searchWebButtonLabel => 'Internetde gözle';
  @override String get selectAllButtonLabel => 'Hemmesini saýla';
  @override String get shareButtonLabel => 'Paýlaş';
  @override String get reorderItemDown => 'Aşak süýşür';
  @override String get reorderItemLeft => 'Çepe süýşür';
  @override String get reorderItemRight => 'Saga süýşür';
  @override String get reorderItemToEnd => 'Ahyryna süýşür';
  @override String get reorderItemToStart => 'Başyna süýşür';
  @override String get reorderItemUp => 'Ýokary süýşür';

  static const LocalizationsDelegate<WidgetsLocalizations> delegate = _TkWidgetsDelegate();
}

class _TkWidgetsDelegate extends LocalizationsDelegate<WidgetsLocalizations> {
  const _TkWidgetsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == _tk;

  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      SynchronousFuture<WidgetsLocalizations>(const TkWidgetsLocalizations());

  @override
  bool shouldReload(_TkWidgetsDelegate old) => false;
}
