import 'package:equatable/equatable.dart';

import '../../../core/utils/wire.dart';
import '../../profile/domain/profile.dart';
import '../../trips/domain/trip.dart';
import 'booking_status.dart';

export 'booking_status.dart';

class Booking extends Equatable {
  const Booking({
    required this.id,
    required this.tripId,
    required this.status,
    required this.seats,
    required this.pickupOrder,
    required this.dropoffOrder,
    required this.passenger,
    required this.createdAt,
    this.luggage = LuggageSize.unspecified,
    this.message,
    this.decidedAt,
    this.trip,
    this.contactPhone,
    this.reviewed = false,
  });

  final String id;
  final String tripId;
  final BookingStatus status;
  final int seats;
  final int pickupOrder;
  final int dropoffOrder;
  final LuggageSize luggage;
  final String? message;
  final DateTime createdAt;
  final DateTime? decidedAt;
  final UserSummary passenger;
  final Trip? trip;

  /// The other participant's number. The backend sends it only to a participant of an
  /// accepted booking; it is never derived on the client.
  final String? contactPhone;
  final bool reviewed;

  TripStop? get pickup => trip?.stops.elementAtOrNull(pickupOrder);
  TripStop? get dropoff => trip?.stops.elementAtOrNull(dropoffOrder);

  @override
  List<Object?> get props => [id, tripId, status, seats, pickupOrder, dropoffOrder, luggage, message, createdAt,
        decidedAt, passenger, trip, contactPhone, reviewed];
}

class BookingRequest {
  const BookingRequest({
    required this.tripId,
    required this.pickupOrder,
    required this.dropoffOrder,
    required this.seats,
    this.luggage = LuggageSize.unspecified,
    this.message = '',
  });

  final String tripId;
  final int pickupOrder;
  final int dropoffOrder;
  final int seats;
  final LuggageSize luggage;
  final String message;
}

abstract interface class BookingsRepository {
  Future<Booking> request(BookingRequest request);
  Future<Booking> booking(String id);
  Future<Booking> approve(String id);
  Future<Booking> reject(String id);
  Future<Booking> cancel(String id);
  Future<String> contact(String id);
  Future<List<Booking>> forTrip(String tripId);
  Future<PageResult<Booking>> mine(TripScope scope, {int page = 1});
}
