import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/router/app_router.dart';
import '../bloc/notifications_cubits.dart';

/// The bell with an unread badge.
class NotificationsButton extends StatelessWidget {
  const NotificationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final unread = context.watch<UnreadCubit>().state;
    return IconButton(
      tooltip: context.l10n.notificationsTitle,
      onPressed: () async {
        await context.router.push(const NotificationsRoute());
        if (context.mounted) await context.read<UnreadCubit>().refresh();
      },
      icon: Badge(
        isLabelVisible: unread > 0,
        label: Text(unread > 99 ? '99+' : '$unread'),
        child: const Icon(Icons.notifications_none_rounded),
      ),
    );
  }
}
