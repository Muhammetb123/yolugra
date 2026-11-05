import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/localization/l10n.dart';

/// Locale-aware formatting of dates, prices and durations. The server sends UTC
/// timestamps; everything here shows them in the device's local time.
class Formatters {
  Formatters(this.l, this.lang);

  factory Formatters.of(BuildContext context) => Formatters(context.l10n, context.languageCode);

  final AppLocalizations l;
  final String lang;

  String time(DateTime t) => DateFormat.Hm(lang).format(t.toLocal());

  String dayMonth(DateTime t) => DateFormat.MMMEd(lang).format(t.toLocal());

  String fullDate(DateTime t) => DateFormat.yMMMMd(lang).format(t.toLocal());

  String monthYear(DateTime t) => DateFormat.yMMMM(lang).format(t.toLocal());

  /// "Today", "Tomorrow" or a short date.
  String relativeDay(DateTime t, {DateTime? now}) {
    final local = t.toLocal();
    final today = DateUtils.dateOnly(now ?? DateTime.now());
    final day = DateUtils.dateOnly(local);
    final diff = day.difference(today).inDays;
    if (diff == 0) return l.dateToday;
    if (diff == 1) return l.dateTomorrow;
    return dayMonth(local);
  }

  String dayAndTime(DateTime t) => '${relativeDay(t)}, ${time(t)}';

  String price(double? amount) {
    if (amount == null) return l.tripPriceOnRequest;
    final text = amount == amount.roundToDouble() ? amount.toStringAsFixed(0) : amount.toStringAsFixed(2);
    return l.priceAmount(text);
  }

  String duration(Duration d) => l.durationValue(d.inHours, d.inMinutes.remainder(60));

  /// +99361234567 -> +993 61 23 45 67
  static String phone(String e164) {
    if (e164.length != 12 || !e164.startsWith('+993')) return e164;
    final n = e164.substring(4);
    return '+993 ${n.substring(0, 2)} ${n.substring(2, 4)} ${n.substring(4, 6)} ${n.substring(6)}';
  }

  static String rating(double v) => v.toStringAsFixed(1);
}
