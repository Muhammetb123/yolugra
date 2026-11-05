import '../../../core/network/api_client.dart';
import '../../../core/utils/wire.dart';
import '../../bookings/domain/booking_status.dart';
import '../../locations/data/locations_repository_impl.dart';
import '../../profile/data/profile_repository_impl.dart';
import '../../vehicle/data/vehicle_repository_impl.dart';
import '../domain/trip.dart';

Amenities amenitiesFromJson(Map<String, dynamic>? j) {
  if (j == null) return const Amenities();
  return Amenities(
    airConditioning: fromWire(YesNo.values, j['air_conditioning'], YesNo.unspecified),
    audioSystem: fromWire(YesNo.values, j['audio_system'], YesNo.unspecified),
    music: fromWire(MusicPolicy.values, j['music_policy'], MusicPolicy.unspecified),
    smoking: fromWire(SmokingPolicy.values, j['smoking_policy'], SmokingPolicy.unspecified),
    pets: fromWire(PetsPolicy.values, j['pets_policy'], PetsPolicy.unspecified),
    luggage: fromWire(LuggageSize.values, j['luggage_size'], LuggageSize.unspecified),
    childSeat: fromWire(YesNo.values, j['child_seat'], YesNo.unspecified),
    conversation: fromWire(Conversation.values, j['conversation'], Conversation.unspecified),
  );
}

Map<String, String> amenitiesToJson(Amenities a) => {
      'air_conditioning': wire(a.airConditioning),
      'audio_system': wire(a.audioSystem),
      'music_policy': wire(a.music),
      'smoking_policy': wire(a.smoking),
      'pets_policy': wire(a.pets),
      'luggage_size': wire(a.luggage),
      'child_seat': wire(a.childSeat),
      'conversation': wire(a.conversation),
    };

Trip tripFromJson(Map<String, dynamic> j) {
  final viewer = j['viewer'] as Map<String, dynamic>?;
  final match = j['match'] as Map<String, dynamic>?;
  return Trip(
    id: j['id'] as String,
    status: fromWire(TripStatus.values, j['status'], TripStatus.active),
    driver: userSummaryFromJson(j['driver'] as Map<String, dynamic>),
    vehicle: j['vehicle'] == null ? null : vehicleFromJson(j['vehicle'] as Map<String, dynamic>),
    stops: (j['stops'] as List).cast<Map<String, dynamic>>().map((s) => TripStop(
          order: s['order'] as int,
          location: locationFromJson(s['location'] as Map<String, dynamic>),
          meetingPoint: s['meeting_point'] as String?,
          plannedAt: parseTime(s['planned_at']),
          type: fromWire(StopType.values, s['stop_type'], StopType.both),
        )).toList(),
    departsAt: DateTime.parse(j['departs_at'] as String),
    arrivesAt: DateTime.parse(j['arrives_at'] as String),
    seatsTotal: j['seats_total'] as int,
    freeBySegment: (j['free_seats_by_segment'] as List? ?? const []).cast<int>(),
    price: parseDouble(j['price']),
    priceNegotiable: j['price_negotiable'] as bool? ?? false,
    currency: j['currency'] as String? ?? 'TMT',
    description: j['description'] as String?,
    conditions: j['conditions'] as String?,
    amenities: amenitiesFromJson(j['amenities'] as Map<String, dynamic>?),
    match: match == null
        ? null
        : SegmentMatch(
            pickupOrder: match['pickup_order'] as int,
            dropoffOrder: match['dropoff_order'] as int,
            freeSeats: match['free_seats'] as int,
          ),
    viewer: viewer == null
        ? null
        : TripViewer(
            isDriver: viewer['is_driver'] as bool? ?? false,
            bookingId: viewer['booking_id'] as String?,
            bookingStatus: viewer['booking_status'] == null
                ? null
                : fromWire(BookingStatus.values, viewer['booking_status'], BookingStatus.pending),
          ),
    pendingRequests: j['pending_requests'] as int?,
    approvedSeats: j['approved_seats'] as int?,
  );
}

Map<String, dynamic> draftToJson(TripDraft d) => {
      'vehicle_id': d.vehicleId,
      'departs_at': d.departsAt.toUtc().toIso8601String(),
      'arrives_at': d.arrivesAt.toUtc().toIso8601String(),
      'seats_total': d.seats,
      'price': d.price,
      'price_negotiable': d.priceNegotiable,
      'description': d.description,
      'conditions': d.conditions,
      'amenities': amenitiesToJson(d.amenities),
      'stops': [
        for (final s in d.stops)
          {
            'location_id': s.location!.id,
            'meeting_point': s.meetingPoint,
            'planned_at': s.plannedAt?.toUtc().toIso8601String(),
            'stop_type': wire(s.type),
          },
      ],
    };

Map<String, dynamic> patchToJson(TripPatch p) => {
      'seats_total': ?p.seats,
      'price': ?p.price,
      if (p.clearPrice) 'clear_price': true,
      'price_negotiable': ?p.priceNegotiable,
      'description': ?p.description,
      'conditions': ?p.conditions,
      if (p.amenities != null) 'amenities': amenitiesToJson(p.amenities!),
      if (p.departsAt != null) 'departs_at': p.departsAt!.toUtc().toIso8601String(),
      if (p.arrivesAt != null) 'arrives_at': p.arrivesAt!.toUtc().toIso8601String(),
      if (p.meetingPoints.isNotEmpty) 'meeting_points': p.meetingPoints.map((k, v) => MapEntry('$k', v)),
    };

/// Builds the GET /v1/trips query. Dates are sent as the local calendar day; the
/// backend interprets them in Turkmenistan time.
// Not DateFormat: in Turkmen the app registers only "tk" date data, so the default locale is missing.
String _wireDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

Map<String, dynamic> queryToParams(SearchQuery q, int page) {
  final (from, to) = switch (q.timeWindow) {
    TimeWindow.any => (null, null),
    TimeWindow.morning => (null, '11:59'),
    TimeWindow.afternoon => ('12:00', '17:59'),
    TimeWindow.evening => ('18:00', null),
  };
  return {
    'from': q.from?.id,
    'to': q.to?.id,
    'date': q.date == null ? null : _wireDate(q.date!),
    'seats': q.seats,
    'time_from': from,
    'time_to': to,
    'price_max': q.priceMax,
    'air_conditioning': q.airConditioning ? 'yes' : null,
    'pets': q.petsAllowed ? 'allowed' : null,
    'smoking': q.noSmoking ? 'prohibited' : null,
    'child_seat': q.childSeat ? 'yes' : null,
    'luggage': q.minLuggage == null ? null : wire(q.minLuggage!),
    'min_rating': q.topRated ? 4 : null,
    'sort': wire(q.sort),
    'page': page,
    'limit': 20,
  };
}

class TripsRepositoryImpl implements TripsRepository {
  TripsRepositoryImpl(this._api);

  final ApiClient _api;

  PageResult<Trip> _page(Map<String, dynamic> res) => PageResult(
        (res['items'] as List).cast<Map<String, dynamic>>().map(tripFromJson).toList(),
        res['has_more'] as bool? ?? false,
      );

  @override
  Future<PageResult<Trip>> search(SearchQuery query, {int page = 1}) async =>
      _page(await _api.get('/v1/trips', query: queryToParams(query, page)));

  @override
  Future<Trip> trip(String id) async => tripFromJson(await _api.get('/v1/trips/$id'));

  @override
  Future<Trip> publish(TripDraft draft) async => tripFromJson(await _api.post('/v1/trips', body: draftToJson(draft)));

  @override
  Future<Trip> update(String id, TripPatch patch) async =>
      tripFromJson(await _api.patch('/v1/trips/$id', body: patchToJson(patch)));

  @override
  Future<Trip> cancel(String id) async => tripFromJson(await _api.post('/v1/trips/$id/cancel'));

  @override
  Future<Trip> complete(String id) async => tripFromJson(await _api.post('/v1/trips/$id/complete'));

  @override
  Future<PageResult<Trip>> mine(TripScope scope, {int page = 1}) async =>
      _page(await _api.get('/v1/me/trips', query: {'scope': wire(scope), 'page': page}));
}
