import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../../trips/domain/trip.dart';

/// Request and seat counts under a driver's own trip.
class DriverTripFooter extends StatelessWidget {
  const DriverTripFooter({super.key, required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final pending = trip.pendingRequests ?? 0;
    return Row(children: [
      if (pending > 0)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: theme.colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(20)),
          child: Text(l.myTripsNewRequests(pending), style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
        ),
      const Spacer(),
      Text(l.myTripsSeatsBooked(trip.approvedSeats ?? 0, trip.seatsTotal), style: theme.textTheme.bodySmall),
    ]);
  }
}
