import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yolugra/core/bloc/paged_cubit.dart';
import 'package:yolugra/core/errors/app_exception.dart';
import 'package:yolugra/core/utils/wire.dart';
import 'package:yolugra/features/authentication/domain/auth_repository.dart';
import 'package:yolugra/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:yolugra/features/authentication/presentation/bloc/login_cubits.dart';
import 'package:yolugra/features/bookings/domain/booking.dart';
import 'package:yolugra/features/my_trips/presentation/bloc/trip_manage_cubit.dart';
import 'package:yolugra/features/profile/domain/profile.dart';
import 'package:yolugra/features/trip_details/presentation/bloc/trip_details_cubits.dart';
import 'package:yolugra/features/trip_publication/presentation/bloc/publish_trip_cubit.dart';
import 'package:yolugra/features/trip_search/presentation/bloc/trip_search_bloc.dart';
import 'package:yolugra/features/trips/domain/trip.dart';
import 'package:yolugra/features/vehicle/domain/vehicle.dart';

import '../helpers/fixtures.dart';

class MockAuth extends Mock implements AuthRepository {}

class MockTrips extends Mock implements TripsRepository {}

class MockBookings extends Mock implements BookingsRepository {}

class MockVehicles extends Mock implements VehicleRepository {}

final profile = Profile(id: 'u-1', firstName: 'Aýna', lastName: 'Orazowa', memberSince: DateTime(2026), profileComplete: true);
final incomplete = Profile(id: 'u-2', firstName: '', lastName: '', memberSince: DateTime(2026));

Booking booking(String id, BookingStatus status, {int seats = 1}) => Booking(
      id: id, tripId: 't-1', status: status, seats: seats, pickupOrder: 0, dropoffOrder: 2, createdAt: DateTime(2026),
      passenger: const UserSummary(id: 'u-p', firstName: 'P', lastName: 'Q'),
    );

void main() {
  setUpAll(() {
    registerFallbackValue(const SearchQuery());
    registerFallbackValue(const BookingRequest(tripId: '', pickupOrder: 0, dropoffOrder: 1, seats: 1));
    registerFallbackValue(TripDraft(stops: const [], departsAt: DateTime(2026), duration: Duration.zero, vehicleId: '', seats: 1));
  });

  group('AuthBloc', () {
    late MockAuth repo;
    late StreamController<void> expired;
    setUp(() {
      repo = MockAuth();
      expired = StreamController<void>.broadcast();
      when(() => repo.sessionExpired).thenAnswer((_) => expired.stream);
    });
    tearDown(() => expired.close());

    blocTest<AuthBloc, AuthState>('restores a stored session',
        build: () {
          when(() => repo.restore()).thenAnswer((_) async => profile);
          return AuthBloc(repo);
        },
        act: (b) => b.add(const AuthStarted()),
        expect: () => [const AuthUnknown(), AuthAuthenticated(profile)]);

    blocTest<AuthBloc, AuthState>('without a session the user must sign in',
        build: () {
          when(() => repo.restore()).thenAnswer((_) async => null);
          return AuthBloc(repo);
        },
        act: (b) => b.add(const AuthStarted()),
        expect: () => [const AuthUnknown(), const AuthUnauthenticated()]);

    blocTest<AuthBloc, AuthState>('a new user must complete the profile',
        build: () => AuthBloc(repo),
        act: (b) => b.add(AuthSignedIn(incomplete)),
        verify: (b) => expect((b.state as AuthAuthenticated).needsProfile, isTrue));

    blocTest<AuthBloc, AuthState>('an expired session signs the user out',
        build: () => AuthBloc(repo),
        seed: () => AuthAuthenticated(profile),
        act: (b) async {
          expired.add(null);
          await Future<void>.delayed(Duration.zero);
        },
        expect: () => [const AuthUnauthenticated(expired: true)]);
  });

  group('Phone and OTP', () {
    late MockAuth repo;
    setUp(() {
      repo = MockAuth();
      when(() => repo.sessionExpired).thenAnswer((_) => const Stream.empty());
    });

    blocTest<PhoneCubit, PhoneState>('an invalid number never reaches the backend',
        build: () => PhoneCubit(repo),
        act: (c) => c.submit('12345'),
        expect: () => [isA<PhoneState>().having((s) => s.status, 'status', LoadStatus.failure)],
        verify: (_) => verifyNever(() => repo.requestCode(any())));

    blocTest<PhoneCubit, PhoneState>('a valid number asks the backend for an SMS',
        build: () {
          when(() => repo.requestCode('+99361234567')).thenAnswer((_) async => null);
          return PhoneCubit(repo);
        },
        act: (c) => c.submit('61 23 45 67'),
        expect: () => [
              isA<PhoneState>().having((s) => s.status, 'status', LoadStatus.loading),
              isA<PhoneState>().having((s) => s.phone, 'phone', '+99361234567'),
            ]);

    blocTest<OtpCubit, OtpState>('a wrong code shows the backend error',
        build: () {
          when(() => repo.verifyCode(any(), any())).thenThrow(const AppException('INVALID_CODE'));
          return OtpCubit(repo, '+99361234567');
        },
        act: (c) => c.verify('123456'),
        expect: () => [
              isA<OtpState>().having((s) => s.status, 'status', LoadStatus.loading),
              isA<OtpState>().having((s) => (s.error as AppException).code, 'code', 'INVALID_CODE'),
            ]);

    blocTest<OtpCubit, OtpState>('a correct code yields the profile',
        build: () {
          when(() => repo.verifyCode('+99361234567', '654321')).thenAnswer((_) async => profile);
          return OtpCubit(repo, '+99361234567');
        },
        act: (c) => c.verify('654321'),
        expect: () => [
              isA<OtpState>().having((s) => s.status, 'status', LoadStatus.loading),
              isA<OtpState>().having((s) => s.profile, 'profile', profile),
            ]);

    test('resend waits for the countdown', () async {
      final c = OtpCubit(repo, '+99361234567');
      await c.resend();
      verifyNever(() => repo.requestCode(any()));
      await c.close();
    });
  });

  group('TripSearchBloc', () {
    late MockTrips trips;
    setUp(() => trips = MockTrips());

    blocTest<TripSearchBloc, TripSearchState>('loads results',
        build: () {
          when(() => trips.search(any(), page: any(named: 'page'))).thenAnswer((_) async => PageResult([sampleTrip()], false));
          return TripSearchBloc(trips, const SearchQuery());
        },
        act: (b) => b.add(const TripSearchRequested(SearchQuery(from: ashgabat, to: mary))),
        expect: () => [
              isA<TripSearchState>().having((s) => s.status, 'status', LoadStatus.loading),
              isA<TripSearchState>().having((s) => s.trips, 'trips', hasLength(1)),
            ]);

    blocTest<TripSearchBloc, TripSearchState>('an empty result is an explicit empty state',
        build: () {
          when(() => trips.search(any(), page: any(named: 'page'))).thenAnswer((_) async => const PageResult([], false));
          return TripSearchBloc(trips, const SearchQuery());
        },
        act: (b) => b.add(const TripSearchRequested(SearchQuery())),
        verify: (b) => expect(b.state.isEmpty, isTrue));

    blocTest<TripSearchBloc, TripSearchState>('a failure keeps the query for retry',
        build: () {
          when(() => trips.search(any(), page: any(named: 'page'))).thenThrow(const AppException(AppException.network));
          return TripSearchBloc(trips, const SearchQuery());
        },
        act: (b) => b.add(const TripSearchRequested(SearchQuery(seats: 3))),
        verify: (b) {
          expect(b.state.status, LoadStatus.failure);
          expect(b.state.query.seats, 3);
        });
  });

  group('BookingFormCubit', () {
    test('starts on the matched segment and limits seats to its free seats', () {
      final c = BookingFormCubit(MockBookings(), sampleTrip(free: [3, 1]), seats: 4, pickup: 0, dropoff: 2);
      expect((c.state.pickup, c.state.dropoff), (0, 2));
      expect(c.freeSeats, 1);
      expect(c.state.seats, 1);
    });

    test('a later pickup moves the drop-off forward and re-limits seats', () {
      final c = BookingFormCubit(MockBookings(), sampleTrip(free: [3, 4]), pickup: 0, dropoff: 1);
      c.setSeats(3);
      c.setPickup(1);
      expect(c.state.dropoff, 2);
      expect(c.freeSeats, 4);
      expect(c.dropoffOptions.map((s) => s.order), [2]);
    });

    test('a drop-off-only stop is never offered as a pickup', () {
      final c = BookingFormCubit(MockBookings(), sampleTrip());
      expect(c.pickupOptions.map((s) => s.order), [0, 1]);
    });

    blocTest<BookingFormCubit, BookingFormState>('a seat conflict from the backend is reported',
        build: () {
          final repo = MockBookings();
          when(() => repo.request(any())).thenThrow(const AppException('INSUFFICIENT_SEATS'));
          return BookingFormCubit(repo, sampleTrip());
        },
        act: (c) => c.submit(),
        expect: () => [
              isA<BookingFormState>().having((s) => s.status, 'status', LoadStatus.loading),
              isA<BookingFormState>().having((s) => (s.error as AppException).code, 'code', 'INSUFFICIENT_SEATS'),
            ]);
  });

  group('PublishTripCubit', () {
    late MockTrips trips;
    late MockVehicles vehicles;
    final now = DateTime(2026, 11, 3, 12);
    setUp(() {
      trips = MockTrips();
      vehicles = MockVehicles();
      when(() => vehicles.list()).thenAnswer((_) async => [const Vehicle(id: 'v-1', brand: 'Toyota', model: 'Camry', color: 'Ak', passengerSeats: 3)]);
    });

    test('the route needs both ends and distinct cities', () {
      final c = PublishTripCubit(trips, vehicles, now: now);
      expect(c.validate(PublishStep.route), PublishIssue.routeIncomplete);
      c
        ..setStopLocation(0, ashgabat)
        ..setStopLocation(1, ashgabat);
      expect(c.validate(PublishStep.route), PublishIssue.duplicateStop);
      c.setStopLocation(1, mary);
      expect(c.validate(PublishStep.route), isNull);
    });

    test('intermediate stops can be added and reordered, the ends stay fixed', () {
      final c = PublishTripCubit(trips, vehicles, now: now)
        ..setStopLocation(0, ashgabat)
        ..setStopLocation(1, mary)
        ..addStop()
        ..addStop()
        ..setStopLocation(1, tejen);
      expect(c.state.stops.map((s) => s.location?.id), [ashgabat.id, tejen.id, null, mary.id]);
      c.moveStop(1, 1);
      expect(c.state.stops.map((s) => s.location?.id), [ashgabat.id, null, tejen.id, mary.id]);
      c.moveStop(1, -1);
      expect(c.state.stops.first.location, ashgabat, reason: 'the departure cannot move');
      c.removeStop(1);
      expect(c.state.stops, hasLength(3));
    });

    test('seats are capped by the chosen vehicle', () async {
      final c = PublishTripCubit(trips, vehicles, now: now);
      await c.loadVehicles();
      expect(c.state.vehicleId, 'v-1');
      expect(c.state.maxSeats, 3);
      expect(c.state.seats, 3);
    });

    test('departure in the past is caught before sending', () {
      final c = PublishTripCubit(trips, vehicles, now: now)..setDate(DateTime(2026, 11, 1));
      expect(c.validate(PublishStep.schedule, now: now), PublishIssue.departurePast);
    });

    blocTest<PublishTripCubit, PublishTripState>('an overlap rejected by the backend is surfaced',
        build: () {
          when(() => trips.publish(any())).thenThrow(const AppException('TRIP_OVERLAP'));
          return PublishTripCubit(trips, vehicles, now: DateTime.now());
        },
        act: (c) async {
          await c.loadVehicles();
          c
            ..setStopLocation(0, ashgabat)
            ..setStopLocation(1, mary)
            ..setTime(const TimeOfDay(hour: 23, minute: 59));
          await c.submit();
        },
        verify: (c) {
          expect(c.state.submitStatus, LoadStatus.failure);
          expect((c.state.error as AppException).code, 'TRIP_OVERLAP');
        });
  });

  group('TripManageCubit', () {
    late MockTrips trips;
    late MockBookings bookings;
    setUp(() {
      trips = MockTrips();
      bookings = MockBookings();
      when(() => trips.trip('t-1')).thenAnswer((_) async => sampleTrip(viewer: const TripViewer(isDriver: true)));
    });

    test('groups requests by status', () async {
      when(() => bookings.forTrip('t-1')).thenAnswer((_) async => [
            booking('a', BookingStatus.pending),
            booking('b', BookingStatus.approved),
            booking('c', BookingStatus.rejected),
          ]);
      final c = TripManageCubit(trips, bookings, 't-1');
      await c.load();
      expect(c.state.pending.map((b) => b.id), ['a']);
      expect(c.state.accepted.map((b) => b.id), ['b']);
      expect(c.state.other.map((b) => b.id), ['c']);
    });

    test('a failed acceptance reloads the backend state and reports the conflict', () async {
      when(() => bookings.forTrip('t-1')).thenAnswer((_) async => [booking('a', BookingStatus.pending, seats: 3)]);
      when(() => bookings.approve('a')).thenThrow(const AppException('INSUFFICIENT_SEATS'));
      final c = TripManageCubit(trips, bookings, 't-1');
      await c.load();
      await c.approve('a');
      expect((c.state.error as AppException).code, 'INSUFFICIENT_SEATS');
      expect(c.state.busyId, isNull);
      verify(() => bookings.forTrip('t-1')).called(2);
    });

    test('a successful acceptance reloads and reports success', () async {
      when(() => bookings.forTrip('t-1')).thenAnswer((_) async => [booking('a', BookingStatus.pending)]);
      when(() => bookings.approve('a')).thenAnswer((_) async => booking('a', BookingStatus.approved));
      final c = TripManageCubit(trips, bookings, 't-1');
      await c.load();
      await c.approve('a');
      expect(c.state.done, ManageAction.accepted);
    });
  });
}
