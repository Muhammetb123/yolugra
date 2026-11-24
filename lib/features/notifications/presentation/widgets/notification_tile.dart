import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../profile/presentation/widgets/user_labels.dart';
import '../../domain/app_notification.dart';

/// The localized sentence for a notification, built on the device from its type.
String notificationText(AppLocalizations l, String lang, AppNotification n) {
  final route = n.from != null && n.to != null ? '${n.from!.name(lang)} → ${n.to!.name(lang)}' : '';
  final actor = n.actor;
  final name = actor == null || (!actor.deleted && actor.fullName.isEmpty) ? l.noteSomeone : l.userName(actor);
  return switch (n.type) {
    NotificationType.bookingRequested => l.noteBookingRequested(name, route),
    NotificationType.bookingApproved => l.noteBookingApproved(route),
    NotificationType.bookingRejected => l.noteBookingRejected(route),
    NotificationType.bookingCancelledByPassenger => l.noteBookingCancelledByPassenger(name, route),
    NotificationType.bookingCancelledByDriver => l.noteBookingCancelledByDriver(route),
    NotificationType.bookingExpired => l.noteBookingExpired(route),
    NotificationType.tripCancelled => l.noteTripCancelled(route),
    NotificationType.tripUpdated => l.noteTripUpdated(route),
    NotificationType.tripReminder => l.noteTripReminder(route),
    NotificationType.tripCompleted => l.noteTripCompleted(route),
    NotificationType.reviewReceived => l.noteReviewReceived(name),
    NotificationType.unknown => l.notificationsTitle,
  };
}

IconData notificationIcon(NotificationType t) => switch (t) {
      NotificationType.bookingRequested => Icons.person_add_alt_1_rounded,
      NotificationType.bookingApproved => Icons.check_circle_rounded,
      NotificationType.bookingRejected || NotificationType.bookingExpired => Icons.cancel_rounded,
      NotificationType.bookingCancelledByPassenger || NotificationType.bookingCancelledByDriver || NotificationType.tripCancelled => Icons.event_busy_rounded,
      NotificationType.tripUpdated => Icons.edit_calendar_rounded,
      NotificationType.tripReminder => Icons.alarm_rounded,
      NotificationType.tripCompleted => Icons.flag_rounded,
      NotificationType.reviewReceived => Icons.star_rounded,
      NotificationType.unknown => Icons.notifications_rounded,
    };

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final n = notification;
    final fmt = Formatters.of(context);
    return Card(
      color: n.read ? null : theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.surface,
          child: Icon(notificationIcon(n.type), color: theme.colorScheme.primary),
        ),
        title: Text(notificationText(context.l10n, context.languageCode, n),
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: n.read ? FontWeight.w400 : FontWeight.w700)),
        subtitle: Text(fmt.dayAndTime(n.createdAt)),
      ),
    );
  }
}
