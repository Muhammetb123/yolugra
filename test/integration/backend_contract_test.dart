// Contract test: the app's real data layer (ApiClient, repositories, JSON mappers)
// against a running Go backend. It needs DEV_MODE=true (the OTP comes back as dev_code)
// and the test phones listed in OTP_TEST_PHONES. Use a separate database with no SMS
// gateway, so no message is ever sent:
//
//   flutter test test/integration --dart-define=API_BASE_URL=http://127.0.0.1:8090 --dart-define=RUN_CONTRACT=true
@TestOn('vm')
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yolugra/core/errors/app_exception.dart';
import 'package:yolugra/core/network/api_client.dart';
import 'package:yolugra/core/storage/session_storage.dart';
import 'package:yolugra/features/authentication/data/auth_repository_impl.dart';
import 'package:yolugra/features/bookings/data/bookings_repository_impl.dart';
import 'package:yolugra/features/bookings/domain/booking.dart';
import 'package:yolugra/features/locations/data/locations_repository_impl.dart';
import 'package:yolugra/features/locations/domain/location.dart';
import 'package:yolugra/features/notifications/data/notifications_repository_impl.dart';
import 'package:yolugra/features/notifications/domain/app_notification.dart';
import 'package:yolugra/features/profile/data/profile_repository_impl.dart';
import 'package:yolugra/features/reviews/data/reviews_repository_impl.dart';
import 'package:yolugra/features/trips/data/trips_repository_impl.dart';
import 'package:yolugra/features/trips/domain/trip.dart';
import 'package:yolugra/features/vehicle/data/vehicle_repository_impl.dart';
import 'package:yolugra/features/vehicle/domain/vehicle.dart';

const run = bool.fromEnvironment('RUN_CONTRACT');

class MemorySecureStorage extends Mock implements FlutterSecureStorage {
  final _data = <String, String>{};

  @override
  Future<String?> read({required String key, AppleOptions? iOptions, AndroidOptions? aOptions, LinuxOptions? lOptions,
          WebOptions? webOptions, AppleOptions? mOptions, WindowsOptions? wOptions}) async =>
      _data[key];

  @override
  Future<void> write({required String key, required String? value, AppleOptions? iOptions, AndroidOptions? aOptions,
      LinuxOptions? lOptions, WebOptions? webOptions, AppleOptions? mOptions, WindowsOptions? wOptions}) async {
    if (value == null) {
      _data.remove(key);
    } else {
      _data[key] = value;
    }
  }

  @override
  Future<void> delete({required String key, AppleOptions? iOptions, AndroidOptions? aOptions, LinuxOptions? lOptions,
          WebOptions? webOptions, AppleOptions? mOptions, WindowsOptions? wOptions}) async =>
      _data.remove(key);
}

/// One signed-in app instance.
class Client {
  Client() {
    session = SessionStorage(MemorySecureStorage());
    api = ApiClient(session: session, language: () => 'ru');
    profiles = ProfileRepositoryImpl(api, session);
    auth = AuthRepositoryImpl(api, session, profiles);
  }

  late final SessionStorage session;
  late final ApiClient api;
  late final ProfileRepositoryImpl profiles;
  late final AuthRepositoryImpl auth;
  late final vehicles = VehicleRepositoryImpl(api);
  late final trips = TripsRepositoryImpl(api);
  late final bookings = BookingsRepositoryImpl(api);
  late final reviews = ReviewsRepositoryImpl(api);
  late final notifications = NotificationsRepositoryImpl(api);
  late final locations = LocationsRepositoryImpl(api);

  Future<void> signIn(String phone, String first, String last) async {
    final code = await auth.requestCode(phone);
    expect(code, isNotNull, reason: 'the contract backend must run with DEV_MODE=true');
    var p = await auth.verifyCode(phone, code!);
    if (!p.profileComplete) p = await profiles.update(firstName: first, lastName: last);
    expect(p.profileComplete, isTrue);
  }
}

void main() {
  test('driver publishes a route with a stop, passenger books part of it, contact appears after approval', () async {
    final driver = Client();
    final passenger = Client();
    final other = Client();
    await driver.signIn('+99361000001', 'Merdan', 'Ataýew');
    await passenger.signIn('+99361000002', 'Aýna', 'Orazowa');
    await other.signIn('+99361000003', 'Batyr', 'Nazarow');

    // A wrong code is a localized, typed error.
    await expectLater(driver.auth.verifyCode('+99361000004', '000000'), throwsA(isA<AppException>().having((e) => e.code, 'code', 'INVALID_CODE')));

    final locs = await driver.locations.all();
    Location byEn(String en) => locs.firstWhere((l) => l.nameEn == en);
    final ashgabat = byEn('Ashgabat'), tejen = byEn('Tejen'), mary = byEn('Mary');
    final ahal = locs.firstWhere((l) => l.type == LocationType.welayat && l.nameEn == 'Ahal');

    final car = await driver.vehicles.create(const Vehicle(brand: 'Toyota', model: 'Camry', color: 'Ak', plate: 'ag 1234', passengerSeats: 4));
    expect(car.plate, 'AG 1234');

    // A unique day far enough ahead that reruns do not collide with earlier trips.
    final departs = DateTime.now().add(Duration(days: 30, minutes: DateTime.now().millisecond)).copyWith(second: 0, millisecond: 0, microsecond: 0);
    final trip = await driver.trips.publish(TripDraft(
      stops: [
        StopDraft(location: ashgabat, meetingPoint: 'Teke bazar', type: StopType.pickup),
        StopDraft(location: tejen, plannedAt: departs.add(const Duration(hours: 2))),
        StopDraft(location: mary, type: StopType.dropoff),
      ],
      departsAt: departs,
      duration: const Duration(hours: 6),
      vehicleId: car.id!,
      seats: 4,
      price: 150,
      amenities: const Amenities(airConditioning: YesNo.yes, pets: PetsPolicy.notAllowed),
    ));
    expect(trip.stops, hasLength(3));
    expect(trip.freeBySegment, [4, 4]);
    expect(trip.isMine, isTrue);

    // The same driver cannot publish an overlapping trip.
    await expectLater(
      driver.trips.publish(TripDraft(
        stops: [StopDraft(location: mary, type: StopType.pickup), StopDraft(location: ashgabat, type: StopType.dropoff)],
        departsAt: departs.add(const Duration(hours: 3)),
        duration: const Duration(hours: 5),
        vehicleId: car.id!,
        seats: 3,
      )),
      throwsA(isA<AppException>().having((e) => e.code, 'code', 'TRIP_OVERLAP')),
    );

    // Searching from the Ahal welayat finds the trip at its Tejen stop.
    final found = await passenger.trips.search(SearchQuery(from: ahal, to: mary, date: departs, seats: 3, airConditioning: true));
    final hit = found.items.firstWhere((t) => t.id == trip.id);
    expect(hit.match!.pickupOrder, 1);
    expect(hit.vehicle!.plate, isEmpty, reason: 'no plate before approval');

    // Two passengers ask for seats on overlapping parts: 3 (Tejen -> Mary) and 2 (Ashgabat -> Mary).
    final b1 = await passenger.bookings.request(BookingRequest(tripId: trip.id, pickupOrder: 1, dropoffOrder: 2, seats: 3, luggage: LuggageSize.small, message: 'Salam'));
    final b2 = await other.bookings.request(BookingRequest(tripId: trip.id, pickupOrder: 0, dropoffOrder: 2, seats: 2));
    expect(b1.status, BookingStatus.pending);
    expect(b1.contactPhone, isNull);
    await expectLater(passenger.bookings.contact(b1.id), throwsA(isA<AppException>().having((e) => e.code, 'code', 'CONTACT_UNAVAILABLE')));
    await expectLater(passenger.bookings.approve(b1.id), throwsA(isA<AppException>().having((e) => e.code, 'code', 'FORBIDDEN')));

    final requests = await driver.bookings.forTrip(trip.id);
    expect(requests.map((b) => b.id).toSet(), {b1.id, b2.id});

    final approved = await driver.bookings.approve(b1.id);
    expect(approved.status, BookingStatus.approved);
    expect(approved.contactPhone, '+99361000002');
    // 3 seats taken on Tejen -> Mary leave 1: the 2-seat request no longer fits.
    await expectLater(driver.bookings.approve(b2.id), throwsA(isA<AppException>().having((e) => e.code, 'code', 'INSUFFICIENT_SEATS')));

    expect(await passenger.bookings.contact(b1.id), '+99361000001');
    await expectLater(other.bookings.contact(b1.id), throwsA(isA<AppException>().having((e) => e.code, 'code', 'NOT_FOUND')));
    final seen = await passenger.trips.trip(trip.id);
    expect(seen.vehicle!.plate, 'AG 1234');
    expect(seen.freeBySegment, [4, 1]);

    final inbox = await passenger.notifications.list();
    expect(inbox.items.first.type, NotificationType.bookingApproved);
    expect(inbox.items.first.from?.nameEn, 'Ashgabat');
    expect(await driver.notifications.unreadCount(), greaterThanOrEqualTo(2));

    final upcoming = await passenger.bookings.mine(TripScope.upcoming);
    expect(upcoming.items.any((b) => b.id == b1.id && b.trip != null), isTrue);
    final mine = await driver.trips.mine(TripScope.upcoming);
    expect(mine.items.firstWhere((t) => t.id == trip.id).pendingRequests, 1);

    // Reviews only after completion.
    await expectLater(passenger.reviews.submit(bookingId: b1.id, rating: 5), throwsA(isA<AppException>().having((e) => e.code, 'code', 'REVIEW_NOT_ALLOWED')));

    // Cancelling restores the seats; repeating it changes nothing.
    final cancelled = await passenger.bookings.cancel(b1.id);
    expect(cancelled.status, BookingStatus.cancelledByPassenger);
    expect(cancelled.contactPhone, isNull);
    await passenger.bookings.cancel(b1.id);
    expect((await driver.trips.trip(trip.id)).freeBySegment, [4, 4]);
    expect((await driver.bookings.approve(b2.id)).status, BookingStatus.approved);

    // Editing keeps seats above the accepted load.
    await expectLater(driver.trips.update(trip.id, const TripPatch(seats: 1)), throwsA(isA<AppException>().having((e) => e.code, 'code', 'SEATS_BELOW_BOOKED')));
    final edited = await driver.trips.update(trip.id, const TripPatch(price: 120, meetingPoints: {0: 'Awtomenzil'}));
    expect(edited.price, 120);
    expect(edited.stops.first.meetingPoint, 'Awtomenzil');

    final gone = await driver.trips.cancel(trip.id);
    expect(gone.status, TripStatus.cancelled);
    expect((await other.bookings.booking(b2.id)).status, BookingStatus.cancelledByDriver);

    final me = await driver.profiles.me();
    expect(me.phone, '+99361000001');
    final public = await passenger.profiles.user(me.id);
    expect(public.phone, isNull, reason: 'public profiles never carry a phone');
  }, skip: run ? false : 'Set --dart-define=RUN_CONTRACT=true and API_BASE_URL to a DEV_MODE backend.', timeout: const Timeout(Duration(minutes: 2)));
}
