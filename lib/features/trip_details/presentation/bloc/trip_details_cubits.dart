import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/paged_cubit.dart';
import '../../../bookings/domain/booking.dart';
import '../../../trips/domain/trip.dart';

class TripDetailsState extends Equatable {
  const TripDetailsState({this.status = LoadStatus.initial, this.trip, this.error});

  final LoadStatus status;
  final Trip? trip;
  final Object? error;

  @override
  List<Object?> get props => [status, trip, error];
}

class TripDetailsCubit extends Cubit<TripDetailsState> {
  TripDetailsCubit(this._repo, this.tripId) : super(const TripDetailsState());

  final TripsRepository _repo;
  final String tripId;

  Future<void> load() async {
    emit(TripDetailsState(status: LoadStatus.loading, trip: state.trip));
    try {
      emit(TripDetailsState(status: LoadStatus.success, trip: await _repo.trip(tripId)));
    } catch (e) {
      emit(TripDetailsState(status: LoadStatus.failure, trip: state.trip, error: e));
    }
  }
}

class BookingFormState extends Equatable {
  const BookingFormState({
    required this.pickup,
    required this.dropoff,
    this.seats = 1,
    this.luggage = LuggageSize.unspecified,
    this.message = '',
    this.status = LoadStatus.initial,
    this.booking,
    this.error,
  });

  final int pickup;
  final int dropoff;
  final int seats;
  final LuggageSize luggage;
  final String message;
  final LoadStatus status;
  final Booking? booking;
  final Object? error;

  bool get validSegment => pickup < dropoff;

  BookingFormState copyWith({int? pickup, int? dropoff, int? seats, LuggageSize? luggage, String? message, LoadStatus? status, Booking? booking, Object? error}) =>
      BookingFormState(
        pickup: pickup ?? this.pickup,
        dropoff: dropoff ?? this.dropoff,
        seats: seats ?? this.seats,
        luggage: luggage ?? this.luggage,
        message: message ?? this.message,
        status: status ?? this.status,
        booking: booking ?? this.booking,
        error: error,
      );

  @override
  List<Object?> get props => [pickup, dropoff, seats, luggage, message, status, booking, error];
}

/// The seat request form. The free-seat count it shows comes from the last trip
/// snapshot; the backend checks seats again when the request is sent and accepted.
class BookingFormCubit extends Cubit<BookingFormState> {
  BookingFormCubit(this._repo, this.trip, {int? seats, int? pickup, int? dropoff})
      : super(_initial(trip, seats, pickup, dropoff));

  static BookingFormState _initial(Trip trip, int? seats, int? pickup, int? dropoff) {
    final last = trip.stops.length - 1;
    var from = pickup ?? trip.defaultSegment.$1;
    var to = dropoff ?? trip.defaultSegment.$2;
    if (from < 0 || from >= last || !trip.stops[from].type.allowsPickup) from = 0;
    if (to <= from || to > last || !trip.stops[to].type.allowsDropoff) to = last;
    final free = trip.freeSeats(from, to);
    final wanted = seats ?? 1;
    return BookingFormState(pickup: from, dropoff: to, seats: free <= 0 ? 1 : wanted.clamp(1, free));
  }

  final BookingsRepository _repo;
  final Trip trip;

  int get freeSeats => state.validSegment ? trip.freeSeats(state.pickup, state.dropoff) : 0;

  List<TripStop> get pickupOptions => trip.stops.where((s) => s.type.allowsPickup && s.order < trip.stops.length - 1).toList();
  List<TripStop> get dropoffOptions => trip.stops.where((s) => s.type.allowsDropoff && s.order > state.pickup).toList();

  void setPickup(int order) {
    var dropoff = state.dropoff;
    if (dropoff <= order) dropoff = trip.stops.length - 1;
    emit(state.copyWith(pickup: order, dropoff: dropoff, seats: _clampSeats(state.seats, order, dropoff)));
  }

  void setDropoff(int order) => emit(state.copyWith(dropoff: order, seats: _clampSeats(state.seats, state.pickup, order)));

  void setSeats(int n) => emit(state.copyWith(seats: n));

  void setLuggage(LuggageSize l) => emit(state.copyWith(luggage: l));

  void setMessage(String m) => emit(state.copyWith(message: m));

  int _clampSeats(int seats, int from, int to) {
    final free = trip.freeSeats(from, to);
    return free <= 0 ? 1 : seats.clamp(1, free);
  }

  Future<void> submit() async {
    if (!state.validSegment || state.status == LoadStatus.loading) return;
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      final b = await _repo.request(BookingRequest(
        tripId: trip.id,
        pickupOrder: state.pickup,
        dropoffOrder: state.dropoff,
        seats: state.seats,
        luggage: state.luggage,
        message: state.message.trim(),
      ));
      emit(state.copyWith(status: LoadStatus.success, booking: b));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e));
    }
  }
}
