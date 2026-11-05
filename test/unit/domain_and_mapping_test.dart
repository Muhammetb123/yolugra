import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yolugra/app/localization/l10n.dart';
import 'package:yolugra/app/localization/generated/app_localizations_en.dart';
import 'package:yolugra/app/localization/generated/app_localizations_ru.dart';
import 'package:yolugra/app/localization/generated/app_localizations_tk.dart';
import 'package:yolugra/core/errors/app_exception.dart';
import 'package:yolugra/core/errors/error_text.dart';
import 'package:yolugra/core/network/api_client.dart';
import 'package:yolugra/core/utils/formatters.dart';
import 'package:yolugra/core/utils/wire.dart';
import 'package:yolugra/features/authentication/domain/auth_repository.dart';
import 'package:yolugra/features/bookings/data/bookings_repository_impl.dart';
import 'package:yolugra/features/bookings/domain/booking.dart';
import 'package:yolugra/features/trips/data/trips_repository_impl.dart';
import 'package:yolugra/features/trips/domain/trip.dart';

import '../helpers/fixtures.dart';

void main() {
  group('normalizePhone', () {
    test('accepts the usual ways of typing a Turkmenistan mobile', () {
      for (final raw in ['61234567', '+99361234567', '993 61 23 45 67', '0099361234567', '71-23-45-67']) {
        expect(normalizePhone(raw), isNotNull, reason: raw);
      }
      expect(normalizePhone('61 23 45 67'), '+99361234567');
    });

    test('rejects landlines, short numbers and other countries', () {
      for (final raw in ['12345678', '6123456', '+79161234567', '', '+9936123456a']) {
        expect(normalizePhone(raw), isNull, reason: raw);
      }
    });
  });

  test('enum wire names match the backend snake_case values', () {
    expect(wire(BookingStatus.cancelledByPassenger), 'cancelled_by_passenger');
    expect(wire(MusicPolicy.driverDecides), 'driver_decides');
    expect(fromWire(TripStatus.values, 'in_progress', TripStatus.active), TripStatus.inProgress);
    expect(fromWire(TripStatus.values, 'something_new', TripStatus.active), TripStatus.active);
  });

  group('segment availability', () {
    test('free seats are the minimum over the requested segments', () {
      final t = sampleTrip(free: [1, 3]);
      expect(t.freeSeats(0, 1), 1);
      expect(t.freeSeats(1, 2), 3);
      expect(t.freeSeats(0, 2), 1);
    });

    test('invalid segments have no seats', () {
      final t = sampleTrip();
      expect(t.freeSeats(2, 1), 0);
      expect(t.freeSeats(1, 1), 0);
      expect(t.freeSeats(0, 5), 0);
    });
  });

  group('trip JSON from the backend', () {
    test('maps route, segment seats, amenities and the search match', () {
      final t = tripFromJson(tripJson());
      expect(t.status, TripStatus.full);
      expect(t.stops.map((s) => s.location.nameEn), ['Ashgabat', 'Tejen', 'Mary']);
      expect(t.stops.first.type, StopType.pickup);
      expect(t.freeBySegment, [2, 0]);
      expect(t.freeSeats(0, 1), 2);
      expect(t.amenities.music, MusicPolicy.driverDecides);
      expect(t.amenities.pets, PetsPolicy.notAllowed);
      expect(t.match!.pickupOrder, 1);
      expect(t.vehicle!.plate, isEmpty, reason: 'the backend omits the plate before approval');
      expect(t.priceNegotiable, isTrue);
    });

    test('reads the viewer relation', () {
      final t = tripFromJson(tripJson(viewer: {'is_driver': false, 'booking_id': 'b-1', 'booking_status': 'approved'}));
      expect(t.viewer!.bookingStatus, BookingStatus.approved);
      expect(t.viewer!.bookingStatus!.contactVisible, isTrue);
    });

    test('a draft serializes to the POST /v1/trips contract', () {
      final draft = TripDraft(
        stops: const [StopDraft(location: ashgabat, meetingPoint: 'Teke', type: StopType.pickup), StopDraft(location: mary, type: StopType.dropoff)],
        departsAt: DateTime.utc(2026, 11, 15, 3),
        duration: const Duration(hours: 6),
        vehicleId: 'v-1',
        seats: 3,
        price: 150,
        amenities: const Amenities(airConditioning: YesNo.yes),
      );
      final j = draftToJson(draft);
      expect(j['arrives_at'], '2026-11-15T09:00:00.000Z');
      expect((j['stops'] as List).first, containsPair('location_id', ashgabat.id));
      expect((j['amenities'] as Map)['air_conditioning'], 'yes');
      expect((j['amenities'] as Map)['pets_policy'], 'unspecified');
    });

    test('search parameters use the backend names and drop empty filters', () {
      final p = queryToParams(SearchQuery(from: ashgabat, to: mary, date: DateTime(2026, 11, 15), seats: 2, timeWindow: TimeWindow.morning, airConditioning: true, sort: SearchSort.priceAsc), 1);
      expect(p['date'], '2026-11-15');
      expect(p['time_to'], '11:59');
      expect(p['air_conditioning'], 'yes');
      expect(p['sort'], 'price_asc');
      expect(p['pets'], isNull);
    });
  });

  test('booking JSON exposes the phone only as sent by the backend', () {
    final base = {
      'id': 'b-1', 'trip_id': 't-1', 'status': 'pending', 'seats': 2, 'pickup_order': 1, 'dropoff_order': 2,
      'luggage': 'small', 'created_at': '2026-11-01T10:00:00Z', 'reviewed': false,
      'passenger': {'id': 'u-p', 'first_name': 'Aýna', 'last_name': 'Orazowa', 'rating_avg': 0, 'rating_count': 0, 'completed_trips': 0},
    };
    expect(bookingFromJson(base).contactPhone, isNull);
    final approved = bookingFromJson({...base, 'status': 'approved', 'contact_phone': '+99361234567'});
    expect(approved.status, BookingStatus.approved);
    expect(approved.contactPhone, '+99361234567');
    expect(approved.luggage, LuggageSize.small);
  });

  group('errors', () {
    test('backend envelope becomes an AppException with code, field and retry', () {
      final e = ApiClient.mapError(DioException(
        requestOptions: RequestOptions(path: '/v1/trips'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/v1/trips'),
          statusCode: 409,
          data: {'error': {'code': 'TRIP_OVERLAP', 'message': '…', 'details': {'trip_id': 't-9'}}},
          headers: Headers.fromMap({'retry-after': ['30']}),
        ),
      ));
      expect(e.code, 'TRIP_OVERLAP');
      expect(e.details['trip_id'], 't-9');
      expect(e.retryAfter, const Duration(seconds: 30));
    });

    test('network failures are explained, not shown raw', () {
      final e = ApiClient.mapError(DioException(requestOptions: RequestOptions(), type: DioExceptionType.connectionError));
      expect(e.code, AppException.network);
    });

    test('every language has its own text for backend codes', () {
      final langs = <AppLocalizations>[AppLocalizationsTk(), AppLocalizationsRu(), AppLocalizationsEn()];
      for (final code in ['INSUFFICIENT_SEATS', 'TRIP_OVERLAP', 'CONTACT_UNAVAILABLE', 'INVALID_CODE', 'BOOKING_NOT_PENDING']) {
        final texts = langs.map((l) => errorText(l, AppException(code))).toSet();
        expect(texts, hasLength(3), reason: code);
        expect(texts.contains(langs.first.errorUnknown), isFalse, reason: code);
      }
    });
  });

  test('phone numbers are grouped for display', () {
    expect(Formatters.phone('+99361234567'), '+993 61 23 45 67');
  });
}
