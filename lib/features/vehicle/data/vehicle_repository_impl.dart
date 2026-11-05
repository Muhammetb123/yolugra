import '../../../core/network/api_client.dart';
import '../../../core/utils/wire.dart';
import '../domain/vehicle.dart';

Vehicle vehicleFromJson(Map<String, dynamic> j) => Vehicle(
      id: j['id'] as String?,
      brand: j['brand'] as String? ?? '',
      model: j['model'] as String? ?? '',
      color: j['color'] as String? ?? '',
      plate: j['plate'] as String? ?? '',
      year: j['year'] as int?,
      type: j['vehicle_type'] == null ? null : fromWire(VehicleType.values, j['vehicle_type'], VehicleType.other),
      passengerSeats: j['passenger_seats'] as int?,
      photoUrl: j['photo_url'] as String?,
    );

Map<String, dynamic> vehicleToJson(Vehicle v) => {
      'brand': v.brand,
      'model': v.model,
      'color': v.color,
      'plate': v.plate,
      'year': v.year,
      'vehicle_type': v.type == null ? '' : wire(v.type!),
      'passenger_seats': v.passengerSeats,
    };

class VehicleRepositoryImpl implements VehicleRepository {
  VehicleRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<List<Vehicle>> list() async =>
      ((await _api.get('/v1/me/vehicles'))['items'] as List).cast<Map<String, dynamic>>().map(vehicleFromJson).toList();

  @override
  Future<Vehicle> create(Vehicle v) async => vehicleFromJson(await _api.post('/v1/me/vehicles', body: vehicleToJson(v)));

  @override
  Future<Vehicle> update(Vehicle v) async => vehicleFromJson(await _api.put('/v1/me/vehicles/${v.id}', body: vehicleToJson(v)));

  @override
  Future<void> delete(String id) => _api.delete('/v1/me/vehicles/$id');

  @override
  Future<Vehicle> uploadPhoto(String id, String filePath) async =>
      vehicleFromJson(await _api.upload('/v1/me/vehicles/$id/photo', filePath));
}
