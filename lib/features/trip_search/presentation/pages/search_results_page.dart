import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../init/dependency_injection.dart';
import '../../../trips/domain/trip.dart';
import '../../../trips/presentation/widgets/trip_card.dart';
import '../bloc/trip_search_bloc.dart';
import '../widgets/filters_sheet.dart';
import '../widgets/search_form.dart';

@RoutePage()
class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key, required this.query});

  final SearchQuery query;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => TripSearchBloc(sl(), query)..add(TripSearchRequested(query)),
        child: const _ResultsView(),
      );
}

class _ResultsView extends StatelessWidget {
  const _ResultsView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<TripSearchBloc, TripSearchState>(
      builder: (context, state) {
        final q = state.query;
        final bloc = context.read<TripSearchBloc>();
        final subtitle = [
          q.date == null ? l.homeAnyDate : Formatters.of(context).relativeDay(q.date!),
          l.passengersCount(q.seats),
        ].join(' · ');
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(routeTitle(context, q.from, q.to), overflow: TextOverflow.ellipsis),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            actions: [
              Badge(
                isLabelVisible: q.activeFilters > 0,
                label: Text('${q.activeFilters}'),
                child: IconButton(
                  tooltip: l.searchFilters,
                  icon: const Icon(Icons.tune_rounded),
                  onPressed: () async {
                    final next = await showFiltersSheet(context, q);
                    if (next != null) bloc.add(TripSearchRequested(next));
                  },
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async => bloc.add(const TripSearchRefreshed()),
            child: switch (state.status) {
              LoadStatus.initial || LoadStatus.loading => const LoadingView(),
              LoadStatus.failure => ErrorView(error: state.error!, onRetry: () => bloc.add(const TripSearchRefreshed())),
              LoadStatus.success when state.trips.isEmpty => ListView(children: [
                  const SizedBox(height: 80),
                  EmptyState(icon: Icons.search_off_rounded, title: l.searchEmptyTitle, subtitle: l.searchEmptySubtitle),
                ]),
              LoadStatus.success => NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n.metrics.pixels > n.metrics.maxScrollExtent - 300) bloc.add(const TripSearchNextPage());
                    return false;
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.trips.length + (state.hasMore ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      if (i == state.trips.length) {
                        return const Padding(padding: EdgeInsets.all(16), child: LoadingView());
                      }
                      final t = state.trips[i];
                      return TripCard(
                        trip: t,
                        onTap: () => context.router.push(TripDetailsRoute(tripId: t.id, seats: q.seats, pickup: t.match?.pickupOrder, dropoff: t.match?.dropoffOrder)),
                      );
                    },
                  ),
                ),
            },
          ),
        );
      },
    );
  }
}
