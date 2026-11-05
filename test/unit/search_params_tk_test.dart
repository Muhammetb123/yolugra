import 'package:flutter_test/flutter_test.dart';
import 'package:yolugra/app/localization/tk_localizations.dart';
import 'package:yolugra/features/trips/data/trips_repository_impl.dart';
import 'package:yolugra/features/trips/domain/trip.dart';

// Own file: registering Turkmen date data replaces intl's global locale data for the isolate.
void main() {
  test('search params build when only Turkmen date data is registered', () {
    registerTurkmenDateSymbols();
    final params = queryToParams(SearchQuery(date: DateTime(2026, 11, 3)), 1);
    expect(params['date'], '2026-11-03');
  });
}
