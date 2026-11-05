import '../../../core/network/api_client.dart';
import '../../../core/utils/wire.dart';
import '../../profile/data/profile_repository_impl.dart';
import '../../trips/data/trips_repository_impl.dart';
import '../../trips/domain/trip.dart';
import '../domain/booking.dart';

Booking bookingFromJson(Map<String, dynamic> j) => Booking(
      id: j['id'] as String,
      tripId: j['trip_id'] as String,
      status: fromWire(BookingStatus.values, j['status'], BookingStatus.pending),
      seats: j['seats'] as int,
      pickupOrder: j['pickup_order'] as int,
      dropoffOrder: j['dropoff_order'] as int,
      luggage: fromWire(LuggageSize.values, j['luggage'], LuggageSize.unspecified),
      message: j['message'] as String?,
      createdAt: DateTime.parse(j['created_at'] as String),
      decidedAt: parseTime(j['decided_at']),
      passenger: userSummaryFromJson(j['passenger'] as Map<String, dynamic>),
      trip: j['trip'] == null ? null : tripFromJson(j['trip'] as Map<String, dynamic>),
      contactPhone: j['contact_phone'] as String?,
      reviewed: j['reviewed'] as bool? ?? false,
    );

class BookingsRepositoryImpl implements BookingsRepository {
  BookingsRepositoryImpl(this._api);

  final ApiClient _api;

  List<Booking> _items(Map<String, dynamic> res) =>
      (res['items'] as List).cast<Map<String, dynamic>>().map(bookingFromJson).toList();

  @override
  Future<Booking> request(BookingRequest r) async => bookingFromJson(await _api.post('/v1/trips/${r.tripId}/bookings', body: {
        'pickup_order': r.pickupOrder,
        'dropoff_order': r.dropoffOrder,
        'seats': r.seats,
        'luggage': wire(r.luggage),
        'message': r.message,
      }));

  @override
  Future<Booking> booking(String id) async => bookingFromJson(await _api.get('/v1/bookings/$id'));

  @override
  Future<Booking> approve(String id) async => bookingFromJson(await _api.post('/v1/bookings/$id/approve'));

  @override
  Future<Booking> reject(String id) async => bookingFromJson(await _api.post('/v1/bookings/$id/reject'));

  @override
  Future<Booking> cancel(String id) async => bookingFromJson(await _api.post('/v1/bookings/$id/cancel'));

  @override
  Future<String> contact(String id) async => (await _api.get('/v1/bookings/$id/contact'))['phone'] as String;

  @override
  Future<List<Booking>> forTrip(String tripId) async => _items(await _api.get('/v1/trips/$tripId/bookings'));

  @override
  Future<PageResult<Booking>> mine(TripScope scope, {int page = 1}) async {
    final res = await _api.get('/v1/me/bookings', query: {'scope': wire(scope), 'page': page});
    return PageResult(_items(res), res['has_more'] as bool? ?? false);
  }
}
