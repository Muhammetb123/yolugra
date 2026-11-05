import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../init/dependency_injection.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../bookings/presentation/widgets/booking_card.dart';
import '../../../notifications/presentation/widgets/notifications_button.dart';
import '../../../trip_search/presentation/widgets/search_form.dart';
import '../../../trips/presentation/widgets/trip_card.dart';
import '../bloc/home_cubit.dart';
import '../widgets/publish_banner.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => HomeCubit(sl(), sl())..load(), child: const _HomeView());
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final name = context.select((AuthBloc b) => b.profile?.firstName ?? '');
    return Scaffold(
      appBar: AppBar(
        title: Text(l.homeGreeting(name)),
        actions: const [NotificationsButton(), SizedBox(width: 8)],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<HomeCubit>().load(),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              Text(l.homeTitle, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 12),
              SearchForm(onSearch: (q) => context.router.push(SearchResultsRoute(query: q))),
              if (state.upcomingBookings.isNotEmpty || state.upcomingDrives.isNotEmpty) ...[
                _Heading(l.homeUpcoming, onMore: () => context.router.navigate(const MyTripsRoute())),
                for (final b in state.upcomingBookings)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: BookingCard(booking: b, onTap: () => context.router.push(BookingDetailsRoute(bookingId: b.id))),
                  ),
                for (final t in state.upcomingDrives)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TripCard(trip: t, showStatus: true, onTap: () => context.router.push(TripManageRoute(tripId: t.id))),
                  ),
              ],
              const SizedBox(height: 20),
              PublishBanner(onPressed: () => context.router.navigate(const PublishTripRoute())),
              _Heading(l.homeRecent),
              if (state.status == LoadStatus.loading && state.recent.isEmpty)
                const Padding(padding: EdgeInsets.all(24), child: LoadingView())
              else if (state.status == LoadStatus.failure)
                ErrorView(error: state.error!, onRetry: () => context.read<HomeCubit>().load())
              else if (state.recent.isEmpty)
                EmptyState(icon: Icons.directions_car_outlined, title: l.homeNoRecent)
              else
                for (final t in state.recent)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TripCard(trip: t, onTap: () => context.router.push(TripDetailsRoute(tripId: t.id))),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text, {this.onMore});
  final String text;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 10),
        child: Row(children: [
          Expanded(child: Text(text, style: Theme.of(context).textTheme.titleLarge)),
          if (onMore != null) TextButton(onPressed: onMore, child: Text(context.l10n.commonSeeAll)),
        ]),
      );
}
