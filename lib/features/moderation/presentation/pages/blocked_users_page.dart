import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../../init/dependency_injection.dart';
import '../../../profile/domain/profile.dart';
import '../../../profile/presentation/widgets/user_labels.dart';
import '../bloc/moderation_cubits.dart';

/// The users the signed-in user blocked, each with an unblock action.
@RoutePage()
class BlockedUsersPage extends StatelessWidget {
  const BlockedUsersPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (_) => BlockedUsersCubit(sl())..load(), child: const BlockedUsersView());
}

class BlockedUsersView extends StatelessWidget {
  const BlockedUsersView({super.key, this.onOpenUser});

  /// Opens a user's profile. Defaults to the public profile route; tests replace it.
  final void Function(UserSummary user)? onOpenUser;

  Future<void> _unblock(BuildContext context, UserSummary user) async {
    final l = context.l10n;
    final err = await context.read<BlockedUsersCubit>().unblock(user.id);
    if (!context.mounted) return;
    if (err == null) {
      showMessage(context, l.unblockDone);
    } else {
      showError(context, err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final open = onOpenUser ?? (UserSummary u) => context.router.push(PublicProfileRoute(userId: u.id));
    return Scaffold(
      appBar: AppBar(title: Text(l.profileBlockedUsers)),
      body: BlocBuilder<BlockedUsersCubit, BlockedUsersState>(
        builder: (context, s) {
          final cubit = context.read<BlockedUsersCubit>();
          if (s.status == LoadStatus.failure && s.items.isEmpty) return ErrorView(error: s.error!, onRetry: cubit.load);
          if (s.status != LoadStatus.success && s.items.isEmpty) return const LoadingView();
          if (s.items.isEmpty) return EmptyState(icon: Icons.block_rounded, title: l.blockedUsersEmpty, subtitle: l.blockedUsersHint);
          return RefreshIndicator(
            onRefresh: cubit.load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                for (final u in s.items)
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: 16, right: 8),
                      onTap: u.deleted ? null : () => open(u),
                      leading: UserAvatar(name: u.fullName, photoUrl: u.photoUrl),
                      title: Text(l.userName(u)),
                      trailing: s.busyId == u.id
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                            )
                          : TextButton(onPressed: s.busyId == null ? () => _unblock(context, u) : null, child: Text(l.unblockUser)),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
