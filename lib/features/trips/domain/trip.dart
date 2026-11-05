import 'package:equatable/equatable.dart';

import '../../../core/utils/wire.dart';
import '../../bookings/domain/booking_status.dart';
import '../../locations/domain/location.dart';
import '../../profile/domain/profile.dart';
import '../../vehicle/domain/vehicle.dart';

/// "active" is the published state.
enum TripStatus {
  active,
  full,
  inProgress,
  completed,
  cancelled,
  expired;

  bool get bookable => this == active || this == full;
  bool get upcoming => this == active || this == full || this == inProgress;
}

enum StopType {
  pickup,
  dropoff,
  both;

  bool get allowsPickup => this != dropoff;
  bool get allowsDropoff => this != pickup;
}

enum YesNo { yes, no, unspecified }

enum MusicPolicy { allowed, none, driverDecides, unspecified }

enum SmokingPolicy { allowed, prohibited, unspecified }

enum PetsPolicy { allowed, notAllowed, unspecified }

enum LuggageSize { none, small, medium, large, unspecified }

enum Conversation { friendly, quiet, noPreference, unspecified }

class Amenities extends Equatable {
  const Amenities({
    this.airConditioning = YesNo.unspecified,
    this.audioSystem = YesNo.unspecified,
    this.music = MusicPolicy.unspecified,
    this.smoking = SmokingPolicy.unspecified,
    this.pets = PetsPolicy.unspecified,
    this.luggage = LuggageSize.unspecified,
    this.childSeat = YesNo.unspecified,
    this.conversation = Conversation.unspecified,
  });

  final YesNo airConditioning;
  final YesNo audioSystem;
  final MusicPolicy music;
  final SmokingPolicy smoking;
  final PetsPolicy pets;
  final LuggageSize luggage;
  final YesNo childSeat;
  final Conversation conversation;

  Amenities copyWith({
    YesNo? airConditioning,
    YesNo? audioSystem,
    MusicPolicy? music,
    SmokingPolicy? smoking,
    PetsPolicy? pets,
    LuggageSize? luggage,
    YesNo? childSeat,
    Conversation? conversation,
  }) =>
      Amenities(
        airConditioning: airConditioning ?? this.airConditioning,
        audioSystem: audioSystem ?? this.audioSystem,
        music: music ?? this.music,
        smoking: smoking ?? this.smoking,
        pets: pets ?? this.pets,
        luggage: luggage ?? this.luggage,
        childSeat: childSeat ?? this.childSeat,
        conversation: conversation ?? this.conversation,
      );

  @override
  List<Object?> get props => [airConditioning, audioSystem, music, smoking, pets, luggage, childSeat, conversation];
}

class TripStop extends Equatable {
  const TripStop({required this.order, required this.location, this.meetingPoint, this.plannedAt, this.type = StopType.both});

  final int order;
  final Location location;
  final String? meetingPoint;
  final DateTime? plannedAt;
  final StopType type;

  @override
  List<Object?> get props => [order, location, meetingPoint, plannedAt, type];
}

/// The matched part of a trip in search results.
class SegmentMatch extends Equatable {
  const SegmentMatch({required this.pickupOrder, required this.dropoffOrder, required this.freeSeats});

  final int pickupOrder;
  final int dropoffOrder;
  final int freeSeats;

  @override
  List<Object?> get props => [pickupOrder, dropoffOrder, freeSeats];
}

class TripViewer extends Equatable {
  const TripViewer({required this.isDriver, this.bookingId, this.bookingStatus});

  final bool isDriver;
  final String? bookingId;
  final BookingStatus? bookingStatus;

  @override
  List<Object?> get props => [isDriver, bookingId, bookingStatus];
}

class Trip extends Equatable {
  const Trip({
    required this.id,
    required this.status,
    required this.driver,
    required this.stops,
    required this.departsAt,
    required this.arrivesAt,
    required this.seatsTotal,
    required this.freeBySegment,
    this.vehicle,
    this.price,
    this.priceNegotiable = false,
    this.currency = 'TMT',
    this.description,
    this.conditions,
    this.amenities = const Amenities(),
    this.match,
    this.viewer,
    this.pendingRequests,
    this.approvedSeats,
  });

  final String id;
  final TripStatus status;
  final UserSummary driver;
  final Vehicle? vehicle;
  final List<TripStop> stops;
  final DateTime departsAt;
  final DateTime arrivesAt;
  final int seatsTotal;

  /// Free seats on each segment: element i is the part from stop i to stop i+1.
  /// It is a snapshot for display; the backend re-checks seats on every request.
  final List<int> freeBySegment;
  final double? price;
  final bool priceNegotiable;
  final String currency;
  final String? description;
  final String? conditions;
  final Amenities amenities;
  final SegmentMatch? match;
  final TripViewer? viewer;
  final int? pendingRequests;
  final int? approvedSeats;

  TripStop get origin => stops.first;
  TripStop get destination => stops.last;
  bool get isMine => viewer?.isDriver ?? false;

  /// Free seats on every segment of [from, to).
  int freeSeats(int from, int to) {
    if (from < 0 || to > stops.length - 1 || from >= to || freeBySegment.isEmpty) return 0;
    return freeBySegment.sublist(from, to).reduce((a, b) => a < b ? a : b);
  }

  /// The pickup and drop-off to show for this trip: the search match or the whole route.
  (int, int) get defaultSegment => match != null ? (match!.pickupOrder, match!.dropoffOrder) : (0, stops.length - 1);

  @override
  List<Object?> get props => [id, status, driver, vehicle, stops, departsAt, arrivesAt, seatsTotal, freeBySegment,
        price, priceNegotiable, description, conditions, amenities, match, viewer, pendingRequests, approvedSeats];
}

enum TimeWindow { any, morning, afternoon, evening }

enum SearchSort { departure, priceAsc, priceDesc, rating }

class SearchQuery extends Equatable {
  const SearchQuery({
    this.from,
    this.to,
    this.date,
    this.seats = 1,
    this.timeWindow = TimeWindow.any,
    this.priceMax,
    this.airConditioning = false,
    this.petsAllowed = false,
    this.noSmoking = false,
    this.childSeat = false,
    this.minLuggage,
    this.topRated = false,
    this.sort = SearchSort.departure,
  });

  final Location? from;
  final Location? to;
  final DateTime? date;
  final int seats;
  final TimeWindow timeWindow;
  final double? priceMax;
  final bool airConditioning;
  final bool petsAllowed;
  final bool noSmoking;
  final bool childSeat;
  final LuggageSize? minLuggage;
  final bool topRated;
  final SearchSort sort;

  int get activeFilters => [
        timeWindow != TimeWindow.any,
        priceMax != null,
        airConditioning,
        petsAllowed,
        noSmoking,
        childSeat,
        minLuggage != null,
        topRated,
      ].where((f) => f).length;

  SearchQuery copyWith({
    Location? Function()? from,
    Location? Function()? to,
    DateTime? Function()? date,
    int? seats,
    TimeWindow? timeWindow,
    double? Function()? priceMax,
    bool? airConditioning,
    bool? petsAllowed,
    bool? noSmoking,
    bool? childSeat,
    LuggageSize? Function()? minLuggage,
    bool? topRated,
    SearchSort? sort,
  }) =>
      SearchQuery(
        from: from != null ? from() : this.from,
        to: to != null ? to() : this.to,
        date: date != null ? date() : this.date,
        seats: seats ?? this.seats,
        timeWindow: timeWindow ?? this.timeWindow,
        priceMax: priceMax != null ? priceMax() : this.priceMax,
        airConditioning: airConditioning ?? this.airConditioning,
        petsAllowed: petsAllowed ?? this.petsAllowed,
        noSmoking: noSmoking ?? this.noSmoking,
        childSeat: childSeat ?? this.childSeat,
        minLuggage: minLuggage != null ? minLuggage() : this.minLuggage,
        topRated: topRated ?? this.topRated,
        sort: sort ?? this.sort,
      );

  /// Keeps the route, date and seats; clears every filter.
  SearchQuery withoutFilters() => SearchQuery(from: from, to: to, date: date, seats: seats, sort: sort);

  @override
  List<Object?> get props => [from, to, date, seats, timeWindow, priceMax, airConditioning, petsAllowed, noSmoking,
        childSeat, minLuggage, topRated, sort];
}

/// A stop being edited in the publication form.
class StopDraft extends Equatable {
  const StopDraft({this.location, this.meetingPoint = '', this.plannedAt, this.type = StopType.both});

  final Location? location;
  final String meetingPoint;
  final DateTime? plannedAt;
  final StopType type;

  StopDraft copyWith({Location? location, String? meetingPoint, DateTime? Function()? plannedAt, StopType? type}) => StopDraft(
        location: location ?? this.location,
        meetingPoint: meetingPoint ?? this.meetingPoint,
        plannedAt: plannedAt != null ? plannedAt() : this.plannedAt,
        type: type ?? this.type,
      );

  @override
  List<Object?> get props => [location, meetingPoint, plannedAt, type];
}

/// A new trip. The backend validates everything again.
class TripDraft extends Equatable {
  const TripDraft({
    required this.stops,
    required this.departsAt,
    required this.duration,
    required this.vehicleId,
    required this.seats,
    this.price,
    this.priceNegotiable = false,
    this.description = '',
    this.conditions = '',
    this.amenities = const Amenities(),
  });

  final List<StopDraft> stops;
  final DateTime departsAt;
  final Duration duration;
  final String vehicleId;
  final int seats;
  final double? price;
  final bool priceNegotiable;
  final String description;
  final String conditions;
  final Amenities amenities;

  DateTime get arrivesAt => departsAt.add(duration);

  @override
  List<Object?> get props => [stops, departsAt, duration, vehicleId, seats, price, priceNegotiable, description, conditions, amenities];
}

/// A driver's edit of a published trip. Null fields stay unchanged.
class TripPatch {
  const TripPatch({
    this.seats,
    this.price,
    this.clearPrice = false,
    this.priceNegotiable,
    this.description,
    this.conditions,
    this.amenities,
    this.departsAt,
    this.arrivesAt,
    this.meetingPoints = const {},
  });

  final int? seats;
  final double? price;
  final bool clearPrice;
  final bool? priceNegotiable;
  final String? description;
  final String? conditions;
  final Amenities? amenities;
  final DateTime? departsAt;
  final DateTime? arrivesAt;
  final Map<int, String> meetingPoints;
}

enum TripScope { upcoming, history }

abstract interface class TripsRepository {
  Future<PageResult<Trip>> search(SearchQuery query, {int page = 1});
  Future<Trip> trip(String id);
  Future<Trip> publish(TripDraft draft);
  Future<Trip> update(String id, TripPatch patch);
  Future<Trip> cancel(String id);
  Future<Trip> complete(String id);
  Future<PageResult<Trip>> mine(TripScope scope, {int page = 1});
}
