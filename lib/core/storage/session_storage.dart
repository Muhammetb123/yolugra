import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keeps the session secrets. The access token lives only in memory; the refresh token
/// and the device id are stored in the platform keystore.
class SessionStorage {
  SessionStorage(this._secure);

  final FlutterSecureStorage _secure;

  static const _refreshKey = 'refresh_token';
  static const _deviceKey = 'device_id';

  String? _accessToken;
  String? _deviceId;

  String? get accessToken => _accessToken;

  Future<String?> readRefreshToken() => _secure.read(key: _refreshKey);

  Future<void> save({required String accessToken, required String refreshToken}) async {
    _accessToken = accessToken;
    await _secure.write(key: _refreshKey, value: refreshToken);
  }

  Future<void> clear() async {
    _accessToken = null;
    await _secure.delete(key: _refreshKey);
  }

  /// A stable random id for this installation. The backend binds OTPs and refresh
  /// tokens to it; it allows letters, digits, '.', '_', ':' and '-'.
  Future<String> deviceId() async {
    if (_deviceId != null) return _deviceId!;
    var id = await _secure.read(key: _deviceKey);
    if (id == null || id.isEmpty) {
      final rnd = Random.secure();
      id = 'app-${List.generate(16, (_) => rnd.nextInt(256).toRadixString(16).padLeft(2, '0')).join()}';
      await _secure.write(key: _deviceKey, value: id);
    }
    return _deviceId = id;
  }
}
