import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/paged_cubit.dart';
import '../../../bookings/domain/booking.dart';
import '../../../trips/domain/trip.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = LoadStatus.initial,
    this.upcomingBookings = const [],
    this.upcomingDrives = const [],
    this.recent = const [],
    this.error,
  });

  final LoadStatus status;
  final List<Booking> upcomingBookings;
  final List<Trip> upcomingDrives;
  final List<Trip> recent;
  final Object? error;

  @override
  List<Object?> get props => [status, upcomingBookings, upcomingDrives, recent, error];
}

/// The home feed: the user's next trips (both roles) and recently published rides.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._trips, this._bookings) : super(const HomeState());

  final TripsRepository _trips;
  final BookingsRepository _bookings;

  Future<void> load() async {
    emit(HomeState(status: LoadStatus.loading, upcomingBookings: state.upcomingBookings, upcomingDrives: state.upcomingDrives, recent: state.recent));
    try {
      final (bookings, drives, recent) = await (
        _bookings.mine(TripScope.upcoming),
        _trips.mine(TripScope.upcoming),
        _trips.search(const SearchQuery()),
      ).wait;
      emit(HomeState(
        status: LoadStatus.success,
        upcomingBookings: bookings.items.take(3).toList(),
        upcomingDrives: drives.items.take(3).toList(),
        recent: recent.items.take(6).toList(),
      ));
    } catch (e) {
      emit(HomeState(status: LoadStatus.failure, error: _firstError(e)));
    }
  }

  static Object _firstError(Object e) {
    if (e is ParallelWaitError) {
      final errors = e.errors;
      if (errors is (AsyncError?, AsyncError?, AsyncError?)) {
        for (final err in [errors.$1, errors.$2, errors.$3]) {
          if (err != null) return err.error;
        }
      }
    }
    return e;
  }
}
