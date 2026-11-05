import '../../../core/errors/app_exception.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/session_storage.dart';
import '../../profile/domain/profile.dart';
import '../domain/auth_repository.dart';

/// Uses the existing endpoints POST /v1/auth/request-otp, /verify-otp, /refresh and /logout.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api, this._session, this._profiles);

  final ApiClient _api;
  final SessionStorage _session;
  final ProfileRepository _profiles;

  @override
  Stream<void> get sessionExpired => _api.sessionExpired;

  @override
  Future<String?> requestCode(String phone) async {
    final normalized = normalizePhone(phone);
    if (normalized == null) throw const AppException('INVALID_PHONE');
    final res = await _api.publicPost('/v1/auth/request-otp', {'phone': normalized, 'device_id': await _session.deviceId()});
    return res['dev_code'] as String?;
  }

  @override
  Future<Profile> verifyCode(String phone, String code) async {
    final res = await _api.publicPost('/v1/auth/verify-otp', {
      'phone': normalizePhone(phone) ?? phone,
      'code': code,
      'device_id': await _session.deviceId(),
    });
    await _session.save(accessToken: res['access_token'] as String, refreshToken: res['refresh_token'] as String);
    return _profiles.me();
  }

  @override
  Future<Profile?> restore() async {
    if (await _session.readRefreshToken() == null) return null;
    if (!await _api.refreshSession()) {
      // A stored token that could not be refreshed for network reasons is kept,
      // but the app cannot open without a profile.
      if (await _session.readRefreshToken() == null) return null;
      throw const AppException(AppException.network);
    }
    return _profiles.me();
  }

  @override
  Future<void> logout() async {
    final refresh = await _session.readRefreshToken();
    try {
      if (refresh != null) await _api.publicPost('/v1/auth/logout', {'refresh_token': refresh});
    } on AppException {
      // Signing out locally must work offline too.
    } finally {
      await _session.clear();
    }
  }
}
