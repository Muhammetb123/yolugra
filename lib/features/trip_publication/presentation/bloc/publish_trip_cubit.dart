import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/paged_cubit.dart';
import '../../../locations/domain/location.dart';
import '../../../trips/domain/trip.dart';
import '../../../vehicle/domain/vehicle.dart';

enum PublishStep { route, schedule, vehicle, comfort, price, review }

/// Problems the form can show before anything is sent. The backend enforces the same
/// rules (and the driver schedule rule) on its own.
enum PublishIssue { routeIncomplete, duplicateStop, departurePast, durationRange, noVehicle, seatsOverVehicle, priceRange }

class PublishTripState extends Equatable {
  const PublishTripState({
    required this.date,
    required this.time,
    this.step = PublishStep.route,
    this.stops = const [StopDraft(type: StopType.pickup), StopDraft(type: StopType.dropoff)],
    this.duration = const Duration(hours: 4),
    this.vehicles = const [],
    this.vehiclesStatus = LoadStatus.initial,
    this.vehicleId,
    this.seats = 3,
    this.amenities = const Amenities(),
    this.price,
    this.priceNegotiable = false,
    this.description = '',
    this.conditions = '',
    this.submitStatus = LoadStatus.initial,
    this.published,
    this.error,
    this.issue,
  });

  final PublishStep step;
  final List<StopDraft> stops;
  final DateTime date;
  final TimeOfDay time;
  final Duration duration;
  final List<Vehicle> vehicles;
  final LoadStatus vehiclesStatus;
  final String? vehicleId;
  final int seats;
  final Amenities amenities;
  final double? price;
  final bool priceNegotiable;
  final String description;
  final String conditions;
  final LoadStatus submitStatus;
  final Trip? published;
  final Object? error;
  final PublishIssue? issue;

  DateTime get departsAt => DateTime(date.year, date.month, date.day, time.hour, time.minute);
  DateTime get arrivesAt => departsAt.add(duration);
  Vehicle? get vehicle => vehicles.where((v) => v.id == vehicleId).firstOrNull;
  int get maxSeats => vehicle?.passengerSeats ?? 8;

  PublishTripState copyWith({
    PublishStep? step,
    List<StopDraft>? stops,
    DateTime? date,
    TimeOfDay? time,
    Duration? duration,
    List<Vehicle>? vehicles,
    LoadStatus? vehiclesStatus,
    String? Function()? vehicleId,
    int? seats,
    Amenities? amenities,
    double? Function()? price,
    bool? priceNegotiable,
    String? description,
    String? conditions,
    LoadStatus? submitStatus,
    Trip? published,
    Object? error,
    PublishIssue? issue,
  }) =>
      PublishTripState(
        step: step ?? this.step,
        stops: stops ?? this.stops,
        date: date ?? this.date,
        time: time ?? this.time,
        duration: duration ?? this.duration,
        vehicles: vehicles ?? this.vehicles,
        vehiclesStatus: vehiclesStatus ?? this.vehiclesStatus,
        vehicleId: vehicleId != null ? vehicleId() : this.vehicleId,
        seats: seats ?? this.seats,
        amenities: amenities ?? this.amenities,
        price: price != null ? price() : this.price,
        priceNegotiable: priceNegotiable ?? this.priceNegotiable,
        description: description ?? this.description,
        conditions: conditions ?? this.conditions,
        submitStatus: submitStatus ?? this.submitStatus,
        published: published ?? this.published,
        error: error,
        issue: issue,
      );

  @override
  List<Object?> get props => [step, stops, date, time, duration, vehicles, vehiclesStatus, vehicleId, seats, amenities,
        price, priceNegotiable, description, conditions, submitStatus, published, error, issue];
}

class PublishTripCubit extends Cubit<PublishTripState> {
  PublishTripCubit(this._trips, this._vehicles, {DateTime? now})
      : super(_initial(now ?? DateTime.now()));

  final TripsRepository _trips;
  final VehicleRepository _vehicles;

  static PublishTripState _initial(DateTime now) {
    final tomorrow = DateUtils.dateOnly(now).add(const Duration(days: 1));
    return PublishTripState(date: tomorrow, time: const TimeOfDay(hour: 8, minute: 0));
  }

  Future<void> loadVehicles({String? select}) async {
    emit(state.copyWith(vehiclesStatus: LoadStatus.loading));
    try {
      final list = await _vehicles.list();
      final chosen = select ?? state.vehicleId ?? list.firstOrNull?.id;
      final vehicle = list.where((v) => v.id == chosen).firstOrNull;
      final maxSeats = vehicle?.passengerSeats ?? 8;
      emit(state.copyWith(
        vehicles: list,
        vehiclesStatus: LoadStatus.success,
        vehicleId: () => vehicle?.id,
        seats: state.seats > maxSeats ? maxSeats : state.seats,
      ));
    } catch (e) {
      emit(state.copyWith(vehiclesStatus: LoadStatus.failure, error: e));
    }
  }

  // Route.
  void setStopLocation(int index, Location location) => _updateStop(index, (s) => s.copyWith(location: location));
  void setMeetingPoint(int index, String text) => _updateStop(index, (s) => s.copyWith(meetingPoint: text));
  void setStopType(int index, StopType type) => _updateStop(index, (s) => s.copyWith(type: type));
  void setStopTime(int index, DateTime? t) => _updateStop(index, (s) => s.copyWith(plannedAt: () => t));

  void addStop() {
    final stops = [...state.stops]..insert(state.stops.length - 1, const StopDraft());
    emit(state.copyWith(stops: stops));
  }

  void removeStop(int index) {
    if (index == 0 || index == state.stops.length - 1) return;
    emit(state.copyWith(stops: [...state.stops]..removeAt(index)));
  }

  /// Moves an intermediate stop; the departure and destination stay at the ends.
  void moveStop(int index, int delta) {
    final target = index + delta;
    if (index <= 0 || index >= state.stops.length - 1 || target <= 0 || target >= state.stops.length - 1) return;
    final stops = [...state.stops];
    final s = stops.removeAt(index);
    stops.insert(target, s);
    emit(state.copyWith(stops: stops));
  }

  void _updateStop(int index, StopDraft Function(StopDraft) f) {
    final stops = [...state.stops];
    stops[index] = f(stops[index]);
    emit(state.copyWith(stops: stops));
  }

  // Schedule.
  void setDate(DateTime d) => emit(state.copyWith(date: d));
  void setTime(TimeOfDay t) => emit(state.copyWith(time: t));
  void setDuration(Duration d) => emit(state.copyWith(duration: d));

  // Vehicle and seats.
  void selectVehicle(String id) {
    final v = state.vehicles.where((x) => x.id == id).firstOrNull;
    final max = v?.passengerSeats ?? 8;
    emit(state.copyWith(vehicleId: () => id, seats: state.seats > max ? max : state.seats));
  }

  void setSeats(int n) => emit(state.copyWith(seats: n));

  // Comfort and price.
  void setAmenities(Amenities a) => emit(state.copyWith(amenities: a));
  void setPrice(double? p) => emit(state.copyWith(price: () => p));
  void setNegotiable(bool v) => emit(state.copyWith(priceNegotiable: v));
  void setDescription(String v) => emit(state.copyWith(description: v));
  void setConditions(String v) => emit(state.copyWith(conditions: v));

  PublishIssue? validate(PublishStep step, {DateTime? now}) {
    final s = state;
    switch (step) {
      case PublishStep.route:
        if (s.stops.any((x) => x.location == null)) return PublishIssue.routeIncomplete;
        final ids = s.stops.map((x) => x.location!.id).toSet();
        if (ids.length != s.stops.length) return PublishIssue.duplicateStop;
      case PublishStep.schedule:
        if (!s.departsAt.isAfter(now ?? DateTime.now())) return PublishIssue.departurePast;
        if (s.duration < const Duration(minutes: 15) || s.duration > const Duration(hours: 48)) return PublishIssue.durationRange;
      case PublishStep.vehicle:
        if (s.vehicle == null) return PublishIssue.noVehicle;
        if (s.seats > s.maxSeats) return PublishIssue.seatsOverVehicle;
      case PublishStep.price:
        if (s.price != null && (s.price! < 0 || s.price! > 100000)) return PublishIssue.priceRange;
      case PublishStep.comfort:
      case PublishStep.review:
        break;
    }
    return null;
  }

  /// Advances when the current step is valid; otherwise reports the issue.
  void next() {
    final issue = validate(state.step);
    if (issue != null) {
      emit(state.copyWith(issue: issue));
      return;
    }
    final i = PublishStep.values.indexOf(state.step);
    if (i < PublishStep.values.length - 1) emit(state.copyWith(step: PublishStep.values[i + 1]));
  }

  void back() {
    final i = PublishStep.values.indexOf(state.step);
    if (i > 0) emit(state.copyWith(step: PublishStep.values[i - 1]));
  }

  void goTo(PublishStep step) => emit(state.copyWith(step: step));

  Future<void> submit() async {
    for (final step in PublishStep.values) {
      final issue = validate(step);
      if (issue != null) {
        emit(state.copyWith(step: step, issue: issue));
        return;
      }
    }
    emit(state.copyWith(submitStatus: LoadStatus.loading));
    try {
      final trip = await _trips.publish(TripDraft(
        stops: state.stops,
        departsAt: state.departsAt,
        duration: state.duration,
        vehicleId: state.vehicleId!,
        seats: state.seats,
        price: state.price,
        priceNegotiable: state.priceNegotiable,
        description: state.description.trim(),
        conditions: state.conditions.trim(),
        amenities: state.amenities,
      ));
      emit(state.copyWith(submitStatus: LoadStatus.success, published: trip));
    } catch (e) {
      emit(state.copyWith(submitStatus: LoadStatus.failure, error: e));
    }
  }

  /// Starts a fresh form after a successful publication.
  void reset() => emit(_initial(DateTime.now()).copyWith(vehicles: state.vehicles, vehiclesStatus: state.vehiclesStatus, vehicleId: () => state.vehicleId));
}
