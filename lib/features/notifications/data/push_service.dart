import 'dart:async';
import 'dart:convert';
import 'dart:ui' show Color;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../core/network/api_client.dart';
import '../../../core/utils/wire.dart';
import '../../../firebase_options.dart';
import '../domain/app_notification.dart';

/// The inbox row a push mirrors, so tapping the push opens the same screen as the row.
class PushPayload {
  const PushPayload({required this.type, this.notificationId, this.tripId, this.bookingId, this.body});

  factory PushPayload.fromMessage(RemoteMessage m) => PushPayload.fromData(m.data, body: m.notification?.body);

  factory PushPayload.fromData(Map<String, dynamic> data, {String? body}) => PushPayload(
        type: fromWire(NotificationType.values, data['type'], NotificationType.unknown),
        notificationId: data['notification_id'] as String?,
        tripId: data['trip_id'] as String?,
        bookingId: data['booking_id'] as String?,
        body: body,
      );

  final NotificationType type;
  final String? notificationId;
  final String? tripId;
  final String? bookingId;

  /// The visible text, already localized by the backend.
  final String? body;
}

/// Firebase Cloud Messaging for the signed-in user. The backend sends a push for every
/// inbox notification; the inbox stays the source of truth, so a lost push only means
/// the user sees the notification on the next badge refresh.
class PushService {
  PushService(this._api, {required this.available});

  /// Initializes Firebase where the project is configured (Android and iOS). Returns
  /// false elsewhere (desktop, web), and the service then does nothing.
  static Future<bool> initialize() async {
    final mobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
    if (kIsWeb || !mobile) return false;
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      return true;
    } catch (e) {
      debugPrint('Firebase is not available: $e');
      return false;
    }
  }

  static const _unregisterTimeout = Duration(seconds: 3);

  /// Created by MainActivity with high importance (heads-up banners); the backend names
  /// the same channel for background pushes. Matches `notification_channel_id` in
  /// android/app/src/main/res/values/strings.xml.
  static const _androidChannelId = 'yolugra_default';

  final ApiClient _api;
  final bool available;
  final _received = StreamController<PushPayload>.broadcast();
  final _opened = StreamController<PushPayload>.broadcast();
  final _subs = <StreamSubscription<Object?>>[];
  final _local = FlutterLocalNotificationsPlugin();
  String? _token;
  bool _initialChecked = false;
  bool _localReady = false;

  bool get _android => defaultTargetPlatform == TargetPlatform.android;

  /// Pushes that arrived while the app was on screen. The service shows them as system
  /// banners itself (FCM does not then); listeners only refresh what they display.
  Stream<PushPayload> get received => _received.stream;

  /// Pushes the user tapped, including the one that launched the app.
  Stream<PushPayload> get opened => _opened.stream;

  String get _platform => defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';

  // The backend sends with the FCM HTTP v1 `message.token` field, which takes the
  // registration token from getToken(). firebase_messaging 17 deprecates it in favour
  // of Firebase Installation IDs (register/onRegistered); moving to those needs the
  // backend to switch its send target at the same time.

  /// Starts receiving pushes for the signed-in user. Safe to call again.
  Future<void> enable() async {
    if (!available || _subs.isNotEmpty) return;
    final fm = FirebaseMessaging.instance;
    await _initLocal();
    _subs
      ..add(FirebaseMessaging.onMessage.listen(_onForeground))
      ..add(FirebaseMessaging.onMessageOpenedApp.listen((m) => _opened.add(PushPayload.fromMessage(m))))
      // ignore: deprecated_member_use
      ..add(fm.onTokenRefresh.listen(_register));

    // A push that cold-started the app is handled once, before the permission prompt.
    if (!_initialChecked) {
      _initialChecked = true;
      try {
        final initial = await fm.getInitialMessage();
        if (initial != null) _opened.add(PushPayload.fromMessage(initial));
      } catch (e) {
        debugPrint('Initial push unavailable: $e');
      }
      // A banner the app showed itself, tapped after the app was closed.
      if (_localReady) {
        try {
          final launch = await _local.getNotificationAppLaunchDetails();
          final response = launch?.notificationResponse;
          if (launch?.didNotificationLaunchApp == true && response != null) _onLocalTap(response);
        } catch (e) {
          debugPrint('Local notification launch details unavailable: $e');
        }
      }
    }

    try {
      // Android 13+ and iOS show the system prompt once; later calls return the stored answer.
      await fm.requestPermission();
      // iOS shows the banner itself while the app is open once asked to; Android needs
      // the local notification from _onForeground.
      await fm.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      // ignore: deprecated_member_use
      final token = await fm.getToken();
      if (token != null) await _register(token);
    } catch (e) {
      // No Google Play services, no network: the next start retries.
      debugPrint('Push registration failed: $e');
    }
  }

  /// Stops pushes for this device. Call while the session is still valid, so the
  /// backend can forget the token; the local token is deleted either way.
  Future<void> disable() async {
    if (!available || (_subs.isEmpty && _token == null)) return;
    for (final s in _subs) {
      unawaited(s.cancel());
    }
    _subs.clear();
    final token = _token;
    _token = null;
    if (token != null) {
      try {
        await _api.delete('/v1/me/push-token', body: {'token': token}).timeout(_unregisterTimeout);
      } catch (_) {
        // Deleting the token below makes FCM reject it, and the backend then drops it.
      }
    }
    try {
      // ignore: deprecated_member_use
      await FirebaseMessaging.instance.deleteToken().timeout(_unregisterTimeout);
    } catch (_) {}
    // Banners of the signed-out user must not open their trips for the next one.
    if (_localReady) {
      try {
        await _local.cancelAll();
      } catch (_) {}
    }
  }

  /// Android only: on iOS the plugin would take over the notification center delegate
  /// that firebase_messaging relies on, and iOS shows foreground pushes by itself.
  Future<void> _initLocal() async {
    if (_localReady || !_android) return;
    try {
      await _local.initialize(
        // Monochrome silhouette; kept by the manifest's default_notification_icon reference.
        settings: const InitializationSettings(android: AndroidInitializationSettings('@drawable/ic_notification')),
        onDidReceiveNotificationResponse: _onLocalTap,
      );
      _localReady = true;
    } catch (e) {
      debugPrint('Local notifications unavailable: $e');
    }
  }

  void _onForeground(RemoteMessage m) {
    _received.add(PushPayload.fromMessage(m));
    final n = m.notification;
    if (!_localReady || n == null || ((n.title ?? '').isEmpty && (n.body ?? '').isEmpty)) return;
    unawaited(_local
        .show(
          // Stable per push, so a redelivered message replaces its banner. 31 bits: Android ids are ints.
          id: (m.messageId ?? m.data['notification_id'] ?? DateTime.now().toIso8601String()).hashCode & 0x7fffffff,
          title: n.title,
          body: n.body,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannelId,
              // Used only if the channel is missing; MainActivity names it per language.
              'Notifications',
              importance: Importance.high,
              priority: Priority.high,
              color: Color(0xFF0B7A6B), // AppTheme.teal, as default_notification_color
            ),
          ),
          payload: jsonEncode({...m.data, 'body': n.body}),
        )
        .catchError((Object e) => debugPrint('Foreground banner failed: $e')));
  }

  void _onLocalTap(NotificationResponse r) {
    final raw = r.payload;
    if (raw == null) return;
    try {
      final data = (jsonDecode(raw) as Map).cast<String, dynamic>();
      _opened.add(PushPayload.fromData(data, body: data['body'] as String?));
    } catch (e) {
      debugPrint('Bad local notification payload: $e');
    }
  }

  Future<void> _register(String token) async {
    _token = token;
    try {
      await _api.put('/v1/me/push-token', body: {'token': token, 'platform': _platform});
    } catch (e) {
      debugPrint('Push token upload failed: $e');
    }
  }
}
