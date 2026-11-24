import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../init/dependency_injection.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../moderation/presentation/bloc/moderation_cubits.dart';
import '../../../reviews/domain/review.dart';
import '../../../reviews/presentation/widgets/review_tile.dart';
import '../../domain/profile.dart';
import '../bloc/profile_cubits.dart';
import '../widgets/profile_header.dart';

/// A user's public profile and the reviews they received. Never shows a phone number.
/// For another user it also offers to report or block them.
@RoutePage()
class PublicProfilePage extends StatelessWidget {
  const PublicProfilePage({super.key, @PathParam('userId') required this.userId, @QueryParam('trip') this.tripId});

  final String userId;

  /// The trip this profile was opened from. A report made here mentions it.
  final String? tripId;

  @override
  Widget build(BuildContext context) {
    final own = context.read<AuthBloc>().profile?.id == userId;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PublicProfileCubit(sl(), userId)..load()),
        BlocProvider<PagedCubit<Review>>(create: (_) => reviewsCubit(sl(), userId)..refresh()),
        BlocProvider(create: (_) {
          final block = UserBlockCubit(sl(), userId);
          if (!own) block.load();
          return block;
        }),
      ],
      child: _View(own: own, tripId: tripId),
    );
  }
}

/// Blocks after a confirmation, unblocks at once, and says what happened.
Future<void> _setBlocked(BuildContext context, Profile profile, bool blocked) async {
  final l = context.l10n;
  final cubit = context.read<UserBlockCubit>();
  if (blocked && !await confirm(context, l.blockConfirm(profile.fullName), confirmLabel: l.blockUser, danger: true)) return;
  final err = await cubit.setBlocked(blocked);
  if (!context.mounted) return;
  if (err == null) {
    showMessage(context, blocked ? l.blockDone : l.unblockDone);
  } else {
    showError(context, err);
  }
}

class _View extends StatelessWidget {
  const _View({required this.own, this.tripId});

  final bool own;
  final String? tripId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final profileState = context.watch<PublicProfileCubit>().state;
    final reviews = context.watch<PagedCubit<Review>>().state;
    final block = context.watch<UserBlockCubit>().state;
    final p = profileState.profile;
    return Scaffold(
      appBar: AppBar(
        title: Text(p?.fullName ?? ''),
        actions: [if (p != null && !own) _UserMenu(profile: p, tripId: tripId, block: block)],
      ),
      body: p == null
          ? (profileState.status == LoadStatus.failure
              ? ErrorView(error: profileState.error!, onRetry: context.read<PublicProfileCubit>().load)
              : const LoadingView())
          : NotificationListener<ScrollNotification>(
              onNotification: (n) {
                if (n.metrics.pixels > n.metrics.maxScrollExtent - 300) context.read<PagedCubit<Review>>().loadMore();
                return false;
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (block.blocked) ...[
                    _BlockedBanner(busy: block.busy, onUnblock: () => _setBlocked(context, p, false)),
                    const SizedBox(height: 16),
                  ],
                  ProfileHeader(profile: p),
                  const SizedBox(height: 24),
                  Text(l.reviewsTitle, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  if (reviews.status == LoadStatus.loading && reviews.items.isEmpty)
                    const LoadingView()
                  else if (reviews.items.isEmpty)
                    EmptyState(icon: Icons.reviews_outlined, title: l.reviewsEmpty)
                  else
                    for (final r in reviews.items) Padding(padding: const EdgeInsets.only(bottom: 10), child: ReviewTile(review: r)),
                ],
              ),
            ),
    );
  }
}

enum _UserAction { report, block }

class _UserMenu extends StatelessWidget {
  const _UserMenu({required this.profile, required this.block, this.tripId});

  final Profile profile;
  final UserBlockState block;
  final String? tripId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final error = Theme.of(context).colorScheme.error;
    return PopupMenuButton<_UserAction>(
      enabled: !block.busy,
      onSelected: (action) {
        switch (action) {
          case _UserAction.report:
            context.router.push(ReportUserRoute(userId: profile.id, name: profile.fullName, tripId: tripId));
          case _UserAction.block:
            _setBlocked(context, profile, !block.blocked);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _UserAction.report,
          child: ListTile(leading: const Icon(Icons.flag_outlined), title: Text(l.reportUser)),
        ),
        PopupMenuItem(
          value: _UserAction.block,
          child: block.blocked
              ? ListTile(leading: const Icon(Icons.lock_open_rounded), title: Text(l.unblockUser))
              : ListTile(leading: Icon(Icons.block_rounded, color: error), title: Text(l.blockUser, style: TextStyle(color: error))),
        ),
      ],
    );
  }
}

class _BlockedBanner extends StatelessWidget {
  const _BlockedBanner({required this.busy, required this.onUnblock});

  final bool busy;
  final VoidCallback onUnblock;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(children: [
          Icon(Icons.block_rounded, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(child: Text(l.blockedBanner, style: theme.textTheme.bodyMedium)),
          TextButton(onPressed: busy ? null : onUnblock, child: Text(l.unblockUser)),
        ]),
      ),
    );
  }
}
