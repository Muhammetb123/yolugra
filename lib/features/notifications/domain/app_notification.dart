import 'package:equatable/equatable.dart';

import '../../../core/utils/wire.dart';
import '../../locations/domain/location.dart';
import '../../profile/domain/profile.dart';

enum NotificationType {
  bookingRequested,
  bookingApproved,
  bookingRejected,
  bookingCancelledByPassenger,
  bookingCancelledByDriver,
  bookingExpired,
  tripCancelled,
  tripUpdated,
  tripReminder,
  tripCompleted,
  reviewReceived,
  unknown,
}

/// An inbox entry. The text is rendered on the device in the selected language from
/// the type and references; the server never sends phone numbers or codes here.
class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.type,
    required this.read,
    required this.createdAt,
    this.tripId,
    this.bookingId,
    this.actor,
    this.from,
    this.to,
    this.departsAt,
  });

  final String id;
  final NotificationType type;
  final bool read;
  final DateTime createdAt;
  final String? tripId;
  final String? bookingId;
  final UserSummary? actor;
  final Location? from;
  final Location? to;
  final DateTime? departsAt;

  AppNotification markRead() => AppNotification(
      id: id, type: type, read: true, createdAt: createdAt, tripId: tripId, bookingId: bookingId,
      actor: actor, from: from, to: to, departsAt: departsAt);

  @override
  List<Object?> get props => [id, type, read, createdAt, tripId, bookingId, actor, from, to, departsAt];
}

abstract interface class NotificationsRepository {
  Future<PageResult<AppNotification>> list({DateTime? before});
  Future<int> unreadCount();
  Future<void> markRead({List<String> ids = const []});
}
