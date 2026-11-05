import 'package:equatable/equatable.dart';

enum VehicleType { sedan, hatchback, wagon, suv, minivan, minibus, other }

/// A car. [plate] is empty when the viewer may not see it; [passengerSeats] excludes the driver.
class Vehicle extends Equatable {
  const Vehicle({
    this.id,
    required this.brand,
    required this.model,
    required this.color,
    this.plate = '',
    this.year,
    this.type,
    this.passengerSeats,
    this.photoUrl,
  });

  final String? id;
  final String brand;
  final String model;
  final String color;
  final String plate;
  final int? year;
  final VehicleType? type;
  final int? passengerSeats;
  final String? photoUrl;

  String get title => '$brand $model';

  @override
  List<Object?> get props => [id, brand, model, color, plate, year, type, passengerSeats, photoUrl];
}

abstract interface class VehicleRepository {
  Future<List<Vehicle>> list();
  Future<Vehicle> create(Vehicle v);
  Future<Vehicle> update(Vehicle v);
  Future<void> delete(String id);
  Future<Vehicle> uploadPhoto(String id, String filePath);
}
