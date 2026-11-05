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
import '../../../bookings/domain/booking_status.dart';
import '../../../trips/domain/trip.dart';
import '../../../trips/presentation/widgets/route_timeline.dart';
import '../../../trips/presentation/widgets/trip_labels.dart';
import '../bloc/trip_details_cubits.dart';
import '../widgets/booking_sheet.dart';
import '../widgets/trip_detail_sections.dart';

@RoutePage()
class TripDetailsPage extends StatelessWidget {
  const TripDetailsPage({
    super.key,
    @PathParam('tripId') required this.tripId,
    @QueryParam('seats') this.seats,
    @QueryParam('pickup') this.pickup,
    @QueryParam('dropoff') this.dropoff,
  });

  final String tripId;
  final int? seats;
  final int? pickup;
  final int? dropoff;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => TripDetailsCubit(sl(), tripId)..load(),
        child: _TripDetailsView(seats: seats, pickup: pickup, dropoff: dropoff),
      );
}

class _TripDetailsView extends StatelessWidget {
  const _TripDetailsView({this.seats, this.pickup, this.dropoff});

  final int? seats;
  final int? pickup;
  final int? dropoff;

  Future<void> _book(BuildContext context, Trip trip) async {
    final booking = await showBookingSheet(context, trip, seats: seats, pickup: pickup, dropoff: dropoff);
    if (booking == null || !context.mounted) return;
    showMessage(context, context.l10n.bookSent);
    await context.read<TripDetailsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocBuilder<TripDetailsCubit, TripDetailsState>(
      builder: (context, state) {
        final trip = state.trip;
        return Scaffold(
          appBar: AppBar(title: Text(l.tripTitle)),
          body: switch ((state.status, trip)) {
            (LoadStatus.failure, null) => ErrorView(error: state.error!, onRetry: context.read<TripDetailsCubit>().load),
            (_, null) => const LoadingView(),
            (_, final Trip t) => RefreshIndicator(
                onRefresh: context.read<TripDetailsCubit>().load,
                child: _Body(trip: t, highlight: _segment(t)),
              ),
          },
          bottomNavigationBar: trip == null ? null : _ActionBar(trip: trip, onBook: () => _book(context, trip)),
        );
      },
    );
  }

  (int, int)? _segment(Trip t) {
    if (pickup == null || dropoff == null || pickup! >= dropoff! || dropoff! >= t.stops.length) return null;
    return (pickup!, dropoff!);
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.trip, this.highlight});

  final Trip trip;
  final (int, int)? highlight;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final fmt = Formatters.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(children: [
          Expanded(child: Text(fmt.fullDate(trip.departsAt), style: theme.textTheme.titleLarge)),
          TripStatusChip(trip.status),
        ]),
        const SizedBox(height: 12),
        SectionCard(
          title: l.tripRoute,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RouteTimeline(stops: trip.stops, highlight: highlight),
              Text(l.tripEstimateNote, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PriceSection(trip: trip, segment: highlight ?? trip.defaultSegment),
        const SizedBox(height: 12),
        DriverSection(driver: trip.driver, onTap: () => context.router.push(PublicProfileRoute(userId: trip.driver.id))),
        if (trip.vehicle != null) ...[
          const SizedBox(height: 12),
          VehicleSection(vehicle: trip.vehicle!, plateVisible: trip.isMine || (trip.viewer?.bookingStatus?.contactVisible ?? false)),
        ],
        const SizedBox(height: 12),
        AmenitiesSection(amenities: trip.amenities),
        if ((trip.description?.isNotEmpty ?? false) || (trip.conditions?.isNotEmpty ?? false)) ...[
          const SizedBox(height: 12),
          SectionCard(
            title: l.tripDescription,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (trip.description?.isNotEmpty ?? false) Text(trip.description!),
              if (trip.conditions?.isNotEmpty ?? false) ...[
                const SizedBox(height: 12),
                Text(l.tripConditions, style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(trip.conditions!),
              ],
            ]),
          ),
        ],
        const SizedBox(height: 12),
        InfoRow(icon: Icons.payments_outlined, text: l.tripPaymentNote, muted: true),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// The bottom action depends on who looks: the driver manages, a passenger with a
/// request sees it, anyone else may request seats while the trip is bookable.
class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.trip, required this.onBook});

  final Trip trip;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final viewer = trip.viewer;
    final status = viewer?.bookingStatus;
    final hasBooking = viewer?.bookingId != null && status != null && (status.isActive || status == BookingStatus.completed);
    final Widget button;
    if (trip.isMine) {
      button = FilledButton.icon(
        onPressed: () => context.router.push(TripManageRoute(tripId: trip.id)),
        icon: const Icon(Icons.manage_accounts_rounded),
        label: Text(l.tripManageRequests),
      );
    } else if (hasBooking) {
      button = OutlinedButton.icon(
        onPressed: () => context.router.push(BookingDetailsRoute(bookingId: viewer!.bookingId!)),
        icon: const Icon(Icons.confirmation_number_outlined),
        label: Text(l.bookViewRequest),
      );
    } else if (trip.status.bookable && trip.departsAt.isAfter(DateTime.now())) {
      button = FilledButton.icon(onPressed: onBook, icon: const Icon(Icons.event_seat_rounded), label: Text(l.bookFormTitle));
    } else {
      return const SizedBox.shrink();
    }
    return SafeArea(
      child: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 12), child: button),
    );
  }
}
