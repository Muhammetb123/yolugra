import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/widgets/paged_list_view.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../init/dependency_injection.dart';
import '../../domain/app_notification.dart';
import '../bloc/notifications_cubits.dart';
import '../widgets/notification_tile.dart';

@RoutePage()
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => NotificationsCubit(sl())..refresh(),
        // The list widget reads the same cubit through its PagedCubit type.
        child: Builder(
          builder: (context) => BlocProvider<PagedCubit<AppNotification>>.value(
            value: context.read<NotificationsCubit>(),
            child: const _View(),
          ),
        ),
      );
}

class _View extends StatelessWidget {
  const _View();

  /// Opens the screen that the notification is about.
  void _open(BuildContext context, AppNotification n) {
    context.read<NotificationsCubit>().markRead(n);
    final router = context.router;
    switch (n.type) {
      case NotificationType.bookingRequested:
      case NotificationType.bookingCancelledByPassenger:
        if (n.tripId != null) router.push(TripManageRoute(tripId: n.tripId!));
      case NotificationType.reviewReceived:
        router.push(const ProfileRoute());
      case NotificationType.tripCompleted:
      case NotificationType.tripReminder:
        if (n.bookingId != null) {
          router.push(BookingDetailsRoute(bookingId: n.bookingId!));
        } else if (n.tripId != null) {
          router.push(TripManageRoute(tripId: n.tripId!));
        }
      default:
        if (n.bookingId != null) {
          router.push(BookingDetailsRoute(bookingId: n.bookingId!));
        } else if (n.tripId != null) {
          router.push(TripDetailsRoute(tripId: n.tripId!));
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.notificationsTitle),
        actions: [
          IconButton(
            tooltip: l.notificationsMarkAll,
            icon: const Icon(Icons.done_all_rounded),
            onPressed: () async {
              await context.read<NotificationsCubit>().markAllRead();
              if (context.mounted) context.read<UnreadCubit>().clear();
            },
          ),
        ],
      ),
      body: PagedListView<AppNotification>(
        empty: EmptyState(icon: Icons.notifications_none_rounded, title: l.notificationsEmpty),
        itemBuilder: (context, n) => NotificationTile(notification: n, onTap: () => _open(context, n)),
      ),
    );
  }
}
