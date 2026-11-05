import '../../../core/network/api_client.dart';
import '../../../core/utils/wire.dart';
import '../../../core/storage/session_storage.dart';
import '../domain/profile.dart';

UserSummary userSummaryFromJson(Map<String, dynamic> j) => UserSummary(
      id: j['id'] as String,
      firstName: j['first_name'] as String? ?? '',
      lastName: j['last_name'] as String? ?? '',
      photoUrl: j['photo_url'] as String?,
      ratingAvg: parseDouble(j['rating_avg']) ?? 0,
      ratingCount: j['rating_count'] as int? ?? 0,
      completedTrips: j['completed_trips'] as int? ?? 0,
    );

Profile profileFromJson(Map<String, dynamic> j) => Profile(
      id: j['id'] as String,
      phone: j['phone'] as String?,
      firstName: j['first_name'] as String? ?? '',
      lastName: j['last_name'] as String? ?? '',
      bio: j['bio'] as String?,
      photoUrl: j['photo_url'] as String?,
      locale: j['locale'] as String?,
      ratingAvg: parseDouble(j['rating_avg']) ?? 0,
      ratingCount: j['rating_count'] as int? ?? 0,
      tripsAsDriver: j['trips_as_driver'] as int? ?? 0,
      tripsAsPassenger: j['trips_as_passenger'] as int? ?? 0,
      memberSince: parseTime(j['member_since']) ?? DateTime.now(),
      profileComplete: j['profile_complete'] as bool? ?? false,
    );

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._api, this._session);

  final ApiClient _api;
  final SessionStorage _session;

  @override
  Future<Profile> me() async => profileFromJson(await _api.get('/v1/me'));

  @override
  Future<Profile> update({String? firstName, String? lastName, String? bio, String? locale}) async =>
      profileFromJson(await _api.patch('/v1/me', body: {
        'first_name': ?firstName,
        'last_name': ?lastName,
        'bio': ?bio,
        'locale': ?locale,
      }));

  @override
  Future<Profile> uploadPhoto(String filePath) async => profileFromJson(await _api.upload('/v1/me/photo', filePath));

  @override
  Future<Profile> removePhoto() async => profileFromJson(await _api.delete('/v1/me/photo'));

  @override
  Future<Profile> user(String id) async => profileFromJson(await _api.get('/v1/users/$id'));

  @override
  Future<String?> requestPhoneChange(String phone) async {
    final res = await _api.post('/v1/me/phone/request-otp', body: {'phone': phone, 'device_id': await _session.deviceId()});
    return res['dev_code'] as String?;
  }

  @override
  Future<Profile> confirmPhoneChange(String phone, String code) async =>
      profileFromJson(await _api.post('/v1/me/phone/verify', body: {'phone': phone, 'code': code}));
}
