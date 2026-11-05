import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yolugra/core/config/app_config.dart';
import 'package:yolugra/core/config/server_address.dart';

void main() {
  group('normalize', () {
    test('accepts what people type for a laptop on Wi-Fi', () {
      expect(ServerAddress.normalize('192.168.68.108:8081'), 'http://192.168.68.108:8081');
      expect(ServerAddress.normalize(' http://192.168.68.108:8081/ '), 'http://192.168.68.108:8081');
      expect(ServerAddress.normalize('https://api.example.tm'), 'https://api.example.tm');
    });

    test('rejects text that is not an address', () {
      for (final raw in ['', '   ', 'ftp://host', 'http://']) {
        expect(ServerAddress.normalize(raw), isNull, reason: raw);
      }
    });
  });

  test('a saved address is used after restart, and reset returns to the build address', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final address = ServerAddress(prefs);
    expect(AppConfig.apiBaseUrl, AppConfig.buildApiBaseUrl);

    await address.set('http://192.168.68.108:8081');
    expect(AppConfig.apiBaseUrl, 'http://192.168.68.108:8081');
    expect(AppConfig.mediaUrl('/media/a.jpg'), 'http://192.168.68.108:8081/media/a.jpg');

    AppConfig.useApiBaseUrl(AppConfig.buildApiBaseUrl);
    final restarted = ServerAddress(prefs);
    expect(restarted.current, 'http://192.168.68.108:8081');
    expect(restarted.isOverridden, isTrue);

    await restarted.set(null);
    expect(AppConfig.apiBaseUrl, AppConfig.buildApiBaseUrl);
    expect(ServerAddress(prefs).isOverridden, isFalse);
  });
}
