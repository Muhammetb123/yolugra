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
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../trip_details/presentation/widgets/trip_detail_sections.dart';
import '../../../trips/domain/trip.dart';
import '../../../trips/presentation/widgets/route_timeline.dart';
import '../../../trips/presentation/widgets/trip_labels.dart';
import '../../domain/booking.dart';
import '../bloc/booking_details_cubit.dart';
import '../widgets/call_button.dart';

@RoutePage()
class BookingDetailsPage extends StatelessWidget {
  const BookingDetailsPage({super.key, @PathParam('bookingId') required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (_) => BookingDetailsCubit(sl(), bookingId)..load(), child: const _View());
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocConsumer<BookingDetailsCubit, BookingDetailsState>(
      listener: (context, s) {
        if (s.cancelled) showMessage(context, l.bookingCancelled);
        if (s.error != null && s.booking != null) showError(context, s.error!);
      },
      builder: (context, s) {
        final b = s.booking;
        return Scaffold(
          appBar: AppBar(title: Text(l.bookingTitle)),
          body: b == null
              ? (s.status == LoadStatus.failure ? ErrorView(error: s.error!, onRetry: context.read<BookingDetailsCubit>().load) : const LoadingView())
              : RefreshIndicator(onRefresh: context.read<BookingDetailsCubit>().load, child: _Body(booking: b, cancelling: s.cancelling)),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.booking, required this.cancelling});

  final Booking booking;
  final bool cancelling;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final fmt = Formatters.of(context);
    final trip = booking.trip;
    final me = context.select((AuthBloc b) => b.profile?.id);
    final iAmPassenger = booking.passenger.id == me;
    final canCancel = booking.status.isActive && trip != null && (booking.status == BookingStatus.pending || trip.departsAt.isAfter(DateTime.now()));
    final canReview = booking.status == BookingStatus.completed && !booking.reviewed;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(children: [
          Expanded(child: Text(trip == null ? '' : fmt.fullDate(trip.departsAt), style: theme.textTheme.titleLarge)),
          BookingStatusChip(booking.status),
        ]),
        const SizedBox(height: 12),
        if (trip != null)
          SectionCard(
            title: l.bookingYourSegment,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              RouteTimeline(stops: trip.stops, highlight: (booking.pickupOrder, booking.dropoffOrder)),
              InfoRow(icon: Icons.event_seat_rounded, text: '${l.bookingRequestedSeats}: ${booking.seats}'),
              if (trip.price != null) InfoRow(icon: Icons.payments_outlined, text: l.bookTotal(fmt.price(trip.price! * booking.seats))),
              if (booking.luggage != LuggageSize.unspecified) InfoRow(icon: Icons.luggage_rounded, text: l.luggage(booking.luggage)),
            ]),
          ),
        const SizedBox(height: 12),
        SectionCard(
          title: l.bookingContact,
          child: booking.contactPhone != null
              ? CallButton(phone: booking.contactPhone!, label: iAmPassenger ? l.bookingCallDriver : l.bookingCallPassenger)
              : InfoRow(icon: Icons.lock_outline_rounded, text: l.bookingContactHidden, muted: true),
        ),
        if (trip != null) ...[
          const SizedBox(height: 12),
          DriverSection(driver: trip.driver, onTap: () => context.router.push(PublicProfileRoute(userId: trip.driver.id))),
          if (trip.vehicle != null) ...[
            const SizedBox(height: 12),
            VehicleSection(vehicle: trip.vehicle!, plateVisible: booking.status.contactVisible),
          ],
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.router.push(TripDetailsRoute(tripId: trip.id, pickup: booking.pickupOrder, dropoff: booking.dropoffOrder)),
            icon: const Icon(Icons.info_outline_rounded),
            label: Text(l.tripTitle),
          ),
        ],
        if (canReview && trip != null) ...[
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () async {
              await context.router.push(LeaveReviewRoute(bookingId: booking.id, name: trip.driver.fullName, aboutDriver: iAmPassenger));
              if (context.mounted) await context.read<BookingDetailsCubit>().load();
            },
            icon: const Icon(Icons.star_rounded),
            label: Text(l.bookingRate),
          ),
        ],
        if (booking.reviewed) ...[const SizedBox(height: 12), InfoRow(icon: Icons.check_circle_outline_rounded, text: l.bookingReviewed)],
        if (canCancel) ...[
          const SizedBox(height: 24),
          SecondaryButtonDanger(
            loading: cancelling,
            label: l.bookingCancel,
            onPressed: () async {
              if (await confirm(context, l.bookingCancelConfirm, confirmLabel: l.bookingCancel, danger: true) && context.mounted) {
                await context.read<BookingDetailsCubit>().cancel();
              }
            },
          ),
        ],
        const SizedBox(height: 12),
        InfoRow(icon: Icons.payments_outlined, text: l.tripPaymentNote, muted: true),
      ],
    );
  }
}

class SecondaryButtonDanger extends StatelessWidget {
  const SecondaryButtonDanger({super.key, required this.label, required this.onPressed, this.loading = false});

  final String label;
  final VoidCallback onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(foregroundColor: error, side: BorderSide(color: error.withValues(alpha: 0.5))),
      onPressed: loading ? null : onPressed,
      child: loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(label),
    );
  }
}
