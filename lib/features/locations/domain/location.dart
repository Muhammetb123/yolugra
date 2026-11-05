import 'package:equatable/equatable.dart';

enum LocationType { welayat, city, etrap, settlement }

/// A canonical place managed by the backend, with names in the three app languages.
class Location extends Equatable {
  const Location({
    required this.id,
    required this.nameTk,
    required this.nameRu,
    required this.nameEn,
    this.parentId,
    this.type = LocationType.city,
  });

  final String id;
  final String? parentId;
  final LocationType type;
  final String nameTk;
  final String nameRu;
  final String nameEn;

  String name(String lang) => switch (lang) {
        'ru' => nameRu,
        'en' => nameEn,
        _ => nameTk,
      };

  /// True when [query] matches the name in any language, so a Russian speaker typing
  /// "Мары" and an English speaker typing "Mary" find the same place.
  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return [nameTk, nameRu, nameEn].any((n) => n.toLowerCase().contains(q));
  }

  @override
  List<Object?> get props => [id];
}

abstract interface class LocationsRepository {
  /// Active locations. Cached after the first successful load.
  Future<List<Location>> all({bool refresh = false});
}
