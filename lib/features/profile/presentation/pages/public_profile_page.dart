import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../init/dependency_injection.dart';
import '../../../reviews/domain/review.dart';
import '../../../reviews/presentation/widgets/review_tile.dart';
import '../bloc/profile_cubits.dart';
import '../widgets/profile_header.dart';

/// A user's public profile and the reviews they received. Never shows a phone number.
@RoutePage()
class PublicProfilePage extends StatelessWidget {
  const PublicProfilePage({super.key, @PathParam('userId') required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => PublicProfileCubit(sl(), userId)..load()),
          BlocProvider<PagedCubit<Review>>(create: (_) => reviewsCubit(sl(), userId)..refresh()),
        ],
        child: const _View(),
      );
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final profileState = context.watch<PublicProfileCubit>().state;
    final reviews = context.watch<PagedCubit<Review>>().state;
    final p = profileState.profile;
    return Scaffold(
      appBar: AppBar(title: Text(p?.fullName ?? '')),
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
