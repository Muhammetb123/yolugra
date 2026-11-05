import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../trips/presentation/widgets/trip_labels.dart';
import '../../domain/booking.dart';

/// A passenger's booking: the booked part of the route, time, driver and status.
class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, required this.onTap});

  final Booking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final fmt = Formatters.of(context);
    final lang = context.languageCode;
    final trip = booking.trip;
    final pickup = booking.pickup;
    final dropoff = booking.dropoff;
    final when = pickup?.plannedAt ?? trip?.departsAt;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                if (when != null) Text(fmt.dayAndTime(when), style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
                const Spacer(),
                BookingStatusChip(booking.status),
              ]),
              const SizedBox(height: 8),
              Text('${pickup?.location.name(lang) ?? ''} → ${dropoff?.location.name(lang) ?? ''}', style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),
              if (trip != null)
                Row(children: [
                  UserAvatar(name: trip.driver.fullName, photoUrl: trip.driver.photoUrl, radius: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(trip.driver.fullName, style: theme.textTheme.bodyMedium)),
                  Text('${l.seatsCount(booking.seats)} · ${fmt.price(trip.price)}', style: theme.textTheme.bodyMedium),
                ]),
            ],
          ),
        ),
      ),
    );
  }
}
