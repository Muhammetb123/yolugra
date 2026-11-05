import 'package:yolugra/features/locations/domain/location.dart';
import 'package:yolugra/features/profile/domain/profile.dart';
import 'package:yolugra/features/trips/domain/trip.dart';
import 'package:yolugra/features/vehicle/domain/vehicle.dart';

const ashgabat = Location(id: 'c2000000-0000-4000-8000-000000000001', nameTk: 'Aşgabat', nameRu: 'Ашхабад', nameEn: 'Ashgabat');
const tejen = Location(
    id: 'c2000000-0000-4000-8000-000000000003', parentId: 'a1000000-0000-4000-8000-000000000001', nameTk: 'Tejen', nameRu: 'Теджен', nameEn: 'Tejen');
const mary = Location(
    id: 'c2000000-0000-4000-8000-000000000008', parentId: 'a1000000-0000-4000-8000-000000000005', nameTk: 'Mary', nameRu: 'Мары', nameEn: 'Mary');

const driver = UserSummary(id: 'u-driver', firstName: 'Merdan', lastName: 'Ataýew', ratingAvg: 4.8, ratingCount: 12, completedTrips: 30);

/// Ashgabat -> Tejen -> Mary with four seats; [free] is the free seats per segment.
Trip sampleTrip({List<int> free = const [4, 4], TripViewer? viewer, String plate = ''}) {
  final dep = DateTime.now().add(const Duration(days: 2));
  return Trip(
    id: 't-1',
    status: TripStatus.active,
    driver: driver,
    vehicle: Vehicle(brand: 'Toyota', model: 'Camry', color: 'Ak', plate: plate, passengerSeats: 4),
    stops: [
      TripStop(order: 0, location: ashgabat, plannedAt: dep, type: StopType.pickup, meetingPoint: 'Teke bazar'),
      TripStop(order: 1, location: tejen, plannedAt: dep.add(const Duration(hours: 2))),
      TripStop(order: 2, location: mary, plannedAt: dep.add(const Duration(hours: 6)), type: StopType.dropoff),
    ],
    departsAt: dep,
    arrivesAt: dep.add(const Duration(hours: 6)),
    seatsTotal: 4,
    freeBySegment: free,
    price: 150,
    amenities: const Amenities(airConditioning: YesNo.yes, smoking: SmokingPolicy.prohibited),
    viewer: viewer,
  );
}

/// The JSON the Go backend returns for GET /v1/trips/{id} (shape from tripDTO).
Map<String, dynamic> tripJson({Map<String, dynamic>? viewer, Map<String, dynamic>? vehicle}) => {
      'id': 't-1',
      'status': 'full',
      'driver': {'id': 'u-driver', 'first_name': 'Merdan', 'last_name': 'Ataýew', 'rating_avg': 4.5, 'rating_count': 2, 'completed_trips': 3},
      'vehicle': vehicle ?? {'brand': 'Toyota', 'model': 'Camry', 'color': 'Ak', 'passenger_seats': 4},
      'stops': [
        {
          'order': 0,
          'location': {'id': ashgabat.id, 'type': 'city', 'name_tk': 'Aşgabat', 'name_ru': 'Ашхабад', 'name_en': 'Ashgabat'},
          'meeting_point': 'Teke bazar',
          'planned_at': '2026-11-15T03:00:00Z',
          'stop_type': 'pickup',
        },
        {
          'order': 1,
          'location': {'id': tejen.id, 'parent_id': tejen.parentId, 'type': 'city', 'name_tk': 'Tejen', 'name_ru': 'Теджен', 'name_en': 'Tejen'},
          'stop_type': 'both',
        },
        {
          'order': 2,
          'location': {'id': mary.id, 'type': 'city', 'name_tk': 'Mary', 'name_ru': 'Мары', 'name_en': 'Mary'},
          'planned_at': '2026-11-15T09:00:00Z',
          'stop_type': 'dropoff',
        },
      ],
      'departs_at': '2026-11-15T03:00:00Z',
      'arrives_at': '2026-11-15T09:00:00Z',
      'seats_total': 4,
      'free_seats_by_segment': [2, 0],
      'price': 150,
      'price_negotiable': true,
      'currency': 'TMT',
      'amenities': {
        'air_conditioning': 'yes',
        'audio_system': 'unspecified',
        'music_policy': 'driver_decides',
        'smoking_policy': 'prohibited',
        'pets_policy': 'not_allowed',
        'luggage_size': 'medium',
        'child_seat': 'no',
        'conversation': 'no_preference',
      },
      'created_at': '2026-11-01T10:00:00Z',
      'updated_at': '2026-11-01T10:00:00Z',
      'match': {'pickup_order': 1, 'dropoff_order': 2, 'free_seats': 0},
      'viewer': ?viewer,
    };
