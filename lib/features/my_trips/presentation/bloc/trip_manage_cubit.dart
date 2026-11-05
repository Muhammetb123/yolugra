import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/paged_cubit.dart';
import '../../../bookings/domain/booking.dart';
import '../../../trips/domain/trip.dart';

enum ManageAction { accepted, rejected, bookingCancelled, tripCancelled, tripCompleted, tripUpdated }

class TripManageState extends Equatable {
  const TripManageState({
    this.status = LoadStatus.initial,
    this.trip,
    this.bookings = const [],
    this.busyId,
    this.done,
    this.error,
  });

  final LoadStatus status;
  final Trip? trip;
  final List<Booking> bookings;

  /// The booking or trip id an action is running on.
  final String? busyId;
  final ManageAction? done;
  final Object? error;

  List<Booking> get pending => bookings.where((b) => b.status == BookingStatus.pending).toList();
  List<Booking> get accepted => bookings.where((b) => b.status == BookingStatus.approved || b.status == BookingStatus.completed).toList();
  List<Booking> get other => bookings.where((b) => !b.status.isActive && b.status != BookingStatus.completed).toList();

  TripManageState copyWith({LoadStatus? status, Trip? trip, List<Booking>? bookings, String? Function()? busyId, ManageAction? done, Object? error}) =>
      TripManageState(
        status: status ?? this.status,
        trip: trip ?? this.trip,
        bookings: bookings ?? this.bookings,
        busyId: busyId != null ? busyId() : this.busyId,
        done: done,
        error: error,
      );

  @override
  List<Object?> get props => [status, trip, bookings, busyId, done, error];
}

/// The driver's view of one trip: requests, accepted passengers and trip actions.
/// After every action the trip and its bookings are reloaded from the backend, which
/// stays the only source of seat availability.
class TripManageCubit extends Cubit<TripManageState> {
  TripManageCubit(this._trips, this._bookings, this.tripId) : super(const TripManageState());

  final TripsRepository _trips;
  final BookingsRepository _bookings;
  final String tripId;

  Future<void> load() async {
    emit(state.copyWith(status: state.trip == null ? LoadStatus.loading : state.status));
    try {
      final (trip, bookings) = await (_trips.trip(tripId), _bookings.forTrip(tripId)).wait;
      emit(state.copyWith(status: LoadStatus.success, trip: trip, bookings: bookings));
    } on ParallelWaitError catch (e) {
      final errors = e.errors as (AsyncError?, AsyncError?);
      emit(state.copyWith(status: LoadStatus.failure, error: (errors.$1 ?? errors.$2)?.error ?? e));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e));
    }
  }

  Future<void> approve(String bookingId) => _run(bookingId, () => _bookings.approve(bookingId), ManageAction.accepted);
  Future<void> reject(String bookingId) => _run(bookingId, () => _bookings.reject(bookingId), ManageAction.rejected);
  Future<void> cancelBooking(String bookingId) => _run(bookingId, () => _bookings.cancel(bookingId), ManageAction.bookingCancelled);
  Future<void> cancelTrip() => _run(tripId, () => _trips.cancel(tripId), ManageAction.tripCancelled);
  Future<void> completeTrip() => _run(tripId, () => _trips.complete(tripId), ManageAction.tripCompleted);

  Future<void> _run(String id, Future<Object> Function() action, ManageAction done) async {
    if (state.busyId != null) return;
    emit(state.copyWith(busyId: () => id));
    try {
      await action();
      await load();
      emit(state.copyWith(busyId: () => null, done: done));
    } catch (e) {
      // Reload so the screen shows what the backend decided (for example, a seat
      // conflict after another request was accepted first).
      await load();
      emit(state.copyWith(busyId: () => null, error: e));
    }
  }
}

class EditTripState extends Equatable {
  const EditTripState({this.status = LoadStatus.initial, this.trip, this.error});

  final LoadStatus status;
  final Trip? trip;
  final Object? error;

  @override
  List<Object?> get props => [status, trip, error];
}

class EditTripCubit extends Cubit<EditTripState> {
  EditTripCubit(this._repo, this.tripId) : super(const EditTripState());

  final TripsRepository _repo;
  final String tripId;

  Future<void> save(TripPatch patch) async {
    emit(const EditTripState(status: LoadStatus.loading));
    try {
      emit(EditTripState(status: LoadStatus.success, trip: await _repo.update(tripId, patch)));
    } catch (e) {
      emit(EditTripState(status: LoadStatus.failure, error: e));
    }
  }
}
