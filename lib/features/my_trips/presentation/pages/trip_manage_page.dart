import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../init/dependency_injection.dart';
import '../../../bookings/domain/booking.dart';
import '../../../trips/domain/trip.dart';
import '../../../trips/presentation/widgets/route_timeline.dart';
import '../../../trips/presentation/widgets/trip_labels.dart';
import '../bloc/trip_manage_cubit.dart';
import '../widgets/booking_request_tile.dart';

/// The driver's dashboard for one trip.
@RoutePage()
class TripManagePage extends StatelessWidget {
  const TripManagePage({super.key, @PathParam('tripId') required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (_) => TripManageCubit(sl(), sl(), tripId)..load(), child: const _ManageView());
}

class _ManageView extends StatelessWidget {
  const _ManageView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocConsumer<TripManageCubit, TripManageState>(
      listenWhen: (a, b) => a.done != b.done || a.error != b.error,
      listener: (context, s) {
        if (s.error != null && s.status == LoadStatus.success) showError(context, s.error!);
        final msg = switch (s.done) {
          ManageAction.accepted => l.manageAccepted1,
          ManageAction.rejected => l.manageRejected1,
          ManageAction.bookingCancelled => l.bookingCancelled,
          ManageAction.tripCancelled => l.manageTripCancelled,
          ManageAction.tripCompleted => l.manageTripCompleted,
          ManageAction.tripUpdated => l.editTripSaved,
          null => null,
        };
        if (msg != null) showMessage(context, msg);
      },
      builder: (context, s) {
        final cubit = context.read<TripManageCubit>();
        final trip = s.trip;
        return Scaffold(
          appBar: AppBar(
            title: Text(l.manageTitle),
            actions: [if (trip != null && trip.status.bookable && trip.departsAt.isAfter(DateTime.now())) _Menu(trip: trip)],
          ),
          body: trip == null
              ? (s.status == LoadStatus.failure ? ErrorView(error: s.error!, onRetry: cubit.load) : const LoadingView())
              : RefreshIndicator(onRefresh: cubit.load, child: _Body(state: s, trip: trip)),
        );
      },
    );
  }
}

class _Menu extends StatelessWidget {
  const _Menu({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<TripManageCubit>();
    return PopupMenuButton<String>(
      onSelected: (v) async {
        switch (v) {
          case 'edit':
            final updated = await context.router.push<Trip>(EditTripRoute(tripId: trip.id, trip: trip));
            if (updated != null) await cubit.load();
          case 'cancel':
            if (await confirm(context, l.manageCancelTripConfirm, confirmLabel: l.manageCancelTrip, danger: true)) await cubit.cancelTrip();
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: 'edit', child: ListTile(leading: const Icon(Icons.edit_outlined), title: Text(l.manageEditTrip))),
        PopupMenuItem(
          value: 'cancel',
          child: ListTile(
            leading: Icon(Icons.cancel_outlined, color: Theme.of(context).colorScheme.error),
            title: Text(l.manageCancelTrip, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state, required this.trip});

  final TripManageState state;
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final fmt = Formatters.of(context);
    final cubit = context.read<TripManageCubit>();
    final upcoming = trip.status.bookable && trip.departsAt.isAfter(DateTime.now());
    final canComplete = trip.status.upcoming && !trip.departsAt.isAfter(DateTime.now());

    Widget tile(Booking b, {bool decide = false, bool cancel = false, bool rate = false}) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: BookingRequestTile(
            booking: b,
            trip: trip,
            busy: state.busyId == b.id,
            onOpenPassenger: () => context.router.push(PublicProfileRoute(userId: b.passenger.id)),
            onAccept: decide ? () => cubit.approve(b.id) : null,
            onReject: decide
                ? () async {
                    if (await confirm(context, l.manageRejectConfirm, confirmLabel: l.manageReject, danger: true)) await cubit.reject(b.id);
                  }
                : null,
            onCancel: cancel
                ? () async {
                    if (await confirm(context, l.manageCancelBookingConfirm, confirmLabel: l.manageCancelBooking, danger: true)) {
                      await cubit.cancelBooking(b.id);
                    }
                  }
                : null,
            onRate: rate
                ? () async {
                    await context.router.push(LeaveReviewRoute(bookingId: b.id, name: b.passenger.fullName, aboutDriver: false));
                    await cubit.load();
                  }
                : null,
          ),
        );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(children: [
          Expanded(child: Text(fmt.fullDate(trip.departsAt), style: theme.textTheme.titleLarge)),
          TripStatusChip(trip.status),
        ]),
        const SizedBox(height: 12),
        SectionCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            RouteTimeline(stops: trip.stops),
            const Divider(),
            const SizedBox(height: 8),
            Text(l.myTripsSeatsBooked(trip.approvedSeats ?? 0, trip.seatsTotal), style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            Text('${fmt.price(trip.price)} · ${l.tripPerSeat}', style: theme.textTheme.bodyMedium),
          ]),
        ),
        if (state.pending.isNotEmpty) ...[
          _Heading(l.managePending),
          for (final b in state.pending) tile(b, decide: upcoming),
        ],
        if (state.accepted.isNotEmpty) ...[
          _Heading(l.manageAccepted),
          for (final b in state.accepted)
            tile(b, cancel: upcoming && b.status == BookingStatus.approved, rate: b.status == BookingStatus.completed && !b.reviewed),
        ],
        if (state.pending.isEmpty && state.accepted.isEmpty)
          Padding(padding: const EdgeInsets.symmetric(vertical: 24), child: EmptyState(icon: Icons.inbox_outlined, title: l.manageNoRequests)),
        if (state.other.isNotEmpty) ...[
          _Heading(l.manageOther),
          for (final b in state.other) tile(b),
        ],
        if (canComplete) ...[
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: state.busyId != null
                ? null
                : () async {
                    if (await confirm(context, l.manageCompleteConfirm, confirmLabel: l.manageCompleteTrip)) await cubit.completeTrip();
                  },
            icon: const Icon(Icons.flag_rounded),
            label: Text(l.manageCompleteTrip),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      );
}
