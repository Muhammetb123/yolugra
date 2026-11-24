import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/widgets/paged_list_view.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../init/dependency_injection.dart';
import '../../domain/app_notification.dart';
import '../bloc/notifications_cubits.dart';
import '../notification_target.dart';
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
    // A row without a target stays on this screen instead of opening it again.
    if (n.tripId == null && n.bookingId == null && n.type != NotificationType.reviewReceived) return;
    openNotificationTarget(context.router, n.type, tripId: n.tripId, bookingId: n.bookingId);
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
