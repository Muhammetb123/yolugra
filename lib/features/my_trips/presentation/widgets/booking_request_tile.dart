import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/rating.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../bookings/domain/booking.dart';
import '../../../bookings/presentation/widgets/call_button.dart';
import '../../../trips/domain/trip.dart';
import '../../../trips/presentation/widgets/trip_labels.dart';

/// One passenger request as the driver sees it: who, which part of the route, how many
/// seats, luggage and message. The phone appears only once the backend shares it.
class BookingRequestTile extends StatelessWidget {
  const BookingRequestTile({
    super.key,
    required this.booking,
    required this.trip,
    this.busy = false,
    this.onAccept,
    this.onReject,
    this.onCancel,
    this.onRate,
    this.onOpenPassenger,
  });

  final Booking booking;
  final Trip trip;
  final bool busy;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onCancel;
  final VoidCallback? onRate;
  final VoidCallback? onOpenPassenger;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.languageCode;
    final theme = Theme.of(context);
    final fmt = Formatters.of(context);
    final p = booking.passenger;
    final from = trip.stops.elementAtOrNull(booking.pickupOrder)?.location.name(lang) ?? '';
    final to = trip.stops.elementAtOrNull(booking.dropoffOrder)?.location.name(lang) ?? '';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onOpenPassenger,
              child: Row(children: [
                UserAvatar(name: p.fullName, photoUrl: p.photoUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p.fullName, style: theme.textTheme.titleMedium),
                    RatingBadge(average: p.ratingAvg, count: p.ratingCount, compact: true),
                  ]),
                ),
                BookingStatusChip(booking.status),
              ]),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Icon(Icons.route_rounded, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(child: Text('$from → $to', style: theme.textTheme.titleSmall)),
              Text(l.seatsCount(booking.seats), style: theme.textTheme.titleSmall),
            ]),
            if (booking.luggage != LuggageSize.unspecified) ...[
              const SizedBox(height: 6),
              Text('${l.bookLuggage}: ${l.luggage(booking.luggage)}', style: theme.textTheme.bodySmall),
            ],
            if (booking.message?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
                child: Text('“${booking.message}”'),
              ),
            ],
            const SizedBox(height: 6),
            Text(l.manageRequestedAt(fmt.dayAndTime(booking.createdAt)), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            if (booking.contactPhone != null) ...[
              const SizedBox(height: 10),
              CallButton(phone: booking.contactPhone!, label: l.bookingCallPassenger),
            ],
            if (busy)
              const Padding(padding: EdgeInsets.only(top: 12), child: LinearProgressIndicator())
            else if (onAccept != null || onReject != null || onCancel != null || onRate != null) ...[
              const SizedBox(height: 12),
              Row(children: [
                if (onReject != null)
                  Expanded(child: OutlinedButton(style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)), onPressed: onReject, child: Text(l.manageReject))),
                if (onReject != null && onAccept != null) const SizedBox(width: 12),
                if (onAccept != null)
                  Expanded(child: FilledButton(style: FilledButton.styleFrom(minimumSize: const Size(0, 44)), onPressed: onAccept, child: Text(l.manageAccept))),
                if (onCancel != null)
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
                      onPressed: onCancel,
                      child: Text(l.manageCancelBooking),
                    ),
                  ),
                if (onRate != null)
                  Expanded(child: OutlinedButton.icon(style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)), onPressed: onRate, icon: const Icon(Icons.star_outline_rounded), label: Text(l.manageRatePassenger))),
              ]),
            ],
          ],
        ),
      ),
    );
  }
}
