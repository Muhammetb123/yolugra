import '../../../core/network/api_client.dart';
import '../../../core/utils/wire.dart';
import '../../locations/data/locations_repository_impl.dart';
import '../../profile/data/profile_repository_impl.dart';
import '../domain/app_notification.dart';

AppNotification notificationFromJson(Map<String, dynamic> j) => AppNotification(
      id: j['id'] as String,
      type: fromWire(NotificationType.values, j['type'], NotificationType.unknown),
      read: j['read'] as bool? ?? false,
      createdAt: DateTime.parse(j['created_at'] as String),
      tripId: j['trip_id'] as String?,
      bookingId: j['booking_id'] as String?,
      actor: j['actor'] == null ? null : userSummaryFromJson(j['actor'] as Map<String, dynamic>),
      from: j['from'] == null ? null : locationFromJson(j['from'] as Map<String, dynamic>),
      to: j['to'] == null ? null : locationFromJson(j['to'] as Map<String, dynamic>),
      departsAt: parseTime(j['departs_at']),
    );

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<PageResult<AppNotification>> list({DateTime? before}) async {
    final res = await _api.get('/v1/me/notifications', query: {'before': before?.toUtc().toIso8601String()});
    return PageResult(
      (res['items'] as List).cast<Map<String, dynamic>>().map(notificationFromJson).toList(),
      res['has_more'] as bool? ?? false,
    );
  }

  @override
  Future<int> unreadCount() async => (await _api.get('/v1/me/notifications/unread-count'))['unread'] as int? ?? 0;

  @override
  Future<void> markRead({List<String> ids = const []}) => _api.post('/v1/me/notifications/read', body: {'ids': ids});
}
