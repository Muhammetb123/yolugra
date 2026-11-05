import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/widgets/paged_list_view.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../init/dependency_injection.dart';
import '../../../bookings/domain/booking.dart';
import '../../../bookings/presentation/widgets/booking_card.dart';
import '../../../trips/domain/trip.dart';
import '../../../trips/presentation/widgets/trip_card.dart';
import '../widgets/driver_trip_footer.dart';

/// One account, two roles: trips I drive, seats I booked, and the history of both.
@RoutePage()
class MyTripsPage extends StatelessWidget {
  const MyTripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.myTripsTitle),
          bottom: TabBar(tabs: [Tab(text: l.myTripsAsDriver), Tab(text: l.myTripsAsPassenger), Tab(text: l.myTripsHistory)]),
        ),
        body: const TabBarView(children: [_DriverTab(TripScope.upcoming), _PassengerTab(TripScope.upcoming), _HistoryTab()]),
      ),
    );
  }
}

class _DriverTab extends StatelessWidget {
  const _DriverTab(this.scope, {super.key});
  final TripScope scope;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final repo = sl<TripsRepository>();
    return BlocProvider<PagedCubit<Trip>>(
      create: (_) => PagedCubit<Trip>((p) => repo.mine(scope, page: p))..refresh(),
      child: PagedListView<Trip>(
        empty: EmptyState(
          icon: Icons.directions_car_outlined,
          title: scope == TripScope.upcoming ? l.myTripsEmptyDriver : l.myTripsEmptyHistory,
          action: scope == TripScope.upcoming
              ? FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
                  onPressed: () => context.router.navigate(const PublishTripRoute()),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(l.homePublishButton),
                )
              : null,
        ),
        itemBuilder: (context, t) => TripCard(
          trip: t,
          showStatus: true,
          footer: DriverTripFooter(trip: t),
          onTap: () async {
            await context.router.push(TripManageRoute(tripId: t.id));
            if (context.mounted) await context.read<PagedCubit<Trip>>().refresh();
          },
        ),
      ),
    );
  }
}

class _PassengerTab extends StatelessWidget {
  const _PassengerTab(this.scope, {super.key});
  final TripScope scope;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final repo = sl<BookingsRepository>();
    return BlocProvider<PagedCubit<Booking>>(
      create: (_) => PagedCubit<Booking>((p) => repo.mine(scope, page: p))..refresh(),
      child: PagedListView<Booking>(
        empty: EmptyState(
          icon: Icons.event_seat_outlined,
          title: scope == TripScope.upcoming ? l.myTripsEmptyPassenger : l.myTripsEmptyHistory,
          action: scope == TripScope.upcoming
              ? FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
                  onPressed: () => context.router.navigate(const SearchRoute()),
                  icon: const Icon(Icons.search_rounded),
                  label: Text(l.homeSearch),
                )
              : null,
        ),
        itemBuilder: (context, b) => BookingCard(
          booking: b,
          onTap: () async {
            await context.router.push(BookingDetailsRoute(bookingId: b.id));
            if (context.mounted) await context.read<PagedCubit<Booking>>().refresh();
          },
        ),
      ),
    );
  }
}

/// Past trips in both roles, switched with a segmented control.
class _HistoryTab extends StatefulWidget {
  const _HistoryTab();

  @override
  State<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<_HistoryTab> {
  bool _asDriver = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: false, label: Text(l.historyAsPassengerTitle), icon: const Icon(Icons.event_seat_outlined)),
              ButtonSegment(value: true, label: Text(l.historyAsDriverTitle), icon: const Icon(Icons.directions_car_outlined)),
            ],
            selected: {_asDriver},
            onSelectionChanged: (v) => setState(() => _asDriver = v.first),
          ),
        ),
        Expanded(
          child: _asDriver
              ? const _DriverTab(TripScope.history, key: ValueKey('driver-history'))
              : const _PassengerTab(TripScope.history, key: ValueKey('passenger-history')),
        ),
      ],
    );
  }
}
