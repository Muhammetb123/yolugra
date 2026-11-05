import '../../../core/network/api_client.dart';
import '../../../core/utils/wire.dart';
import '../domain/location.dart';

Location locationFromJson(Map<String, dynamic> j) => Location(
      id: j['id'] as String,
      parentId: j['parent_id'] as String?,
      type: fromWire(LocationType.values, j['type'], LocationType.city),
      nameTk: j['name_tk'] as String? ?? '',
      nameRu: j['name_ru'] as String? ?? '',
      nameEn: j['name_en'] as String? ?? '',
    );

/// Locations come from the backend, so new places need no app release.
class LocationsRepositoryImpl implements LocationsRepository {
  LocationsRepositoryImpl(this._api);

  final ApiClient _api;
  List<Location>? _cache;

  @override
  Future<List<Location>> all({bool refresh = false}) async {
    if (_cache != null && !refresh) return _cache!;
    final res = await _api.get('/v1/locations');
    return _cache = (res['items'] as List).cast<Map<String, dynamic>>().map(locationFromJson).toList();
  }
}
