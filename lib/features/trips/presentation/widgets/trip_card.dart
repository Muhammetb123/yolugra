import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/rating.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../domain/trip.dart';
import 'trip_labels.dart';

/// A trip in a list: time, matched route part, price, seats, driver and car.
class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip, required this.onTap, this.showStatus = false, this.footer});

  final Trip trip;
  final VoidCallback onTap;
  final bool showStatus;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final fmt = Formatters.of(context);
    final lang = context.languageCode;
    final (from, to) = trip.defaultSegment;
    final pickup = trip.stops[from];
    final dropoff = trip.stops[to];
    final depart = pickup.plannedAt ?? trip.departsAt;
    final arrive = dropoff.plannedAt ?? trip.arrivesAt;
    final free = trip.match?.freeSeats ?? trip.freeSeats(from, to);
    final amenities = l.amenityLines(trip.amenities).take(3);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(fmt.relativeDay(depart), style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
                  const Spacer(),
                  if (showStatus) TripStatusChip(trip.status) else Text(fmt.price(trip.price), style: theme.textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: 10),
              _Leg(time: fmt.time(depart), place: pickup.location.name(lang), strong: true),
              Padding(
                padding: const EdgeInsets.only(left: 58),
                child: Text(
                  trip.stops.length > 2 && to - from > 1 ? '· · ·  ${fmt.duration(arrive.difference(depart))}' : fmt.duration(arrive.difference(depart)),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
              _Leg(time: '≈${fmt.time(arrive)}', place: dropoff.location.name(lang)),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                children: [
                  UserAvatar(name: trip.driver.fullName, photoUrl: trip.driver.photoUrl, radius: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trip.driver.fullName, style: theme.textTheme.titleSmall, overflow: TextOverflow.ellipsis),
                        RatingBadge(average: trip.driver.ratingAvg, count: trip.driver.ratingCount, compact: true),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(l.seatsLeft(free),
                          style: theme.textTheme.labelLarge?.copyWith(color: free > 0 ? theme.colorScheme.primary : theme.colorScheme.error)),
                      if (trip.vehicle != null)
                        Text('${trip.vehicle!.title} · ${trip.vehicle!.color}',
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
              if (amenities.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    for (final (icon, text) in amenities)
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(text, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ]),
                  ],
                ),
              ],
              if (footer != null) ...[const SizedBox(height: 12), footer!],
            ],
          ),
        ),
      ),
    );
  }
}

class _Leg extends StatelessWidget {
  const _Leg({required this.time, required this.place, this.strong = false});

  final String time;
  final String place;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(width: 58, child: Text(time, style: theme.textTheme.titleMedium)),
        Expanded(
          child: Text(place,
              style: strong ? theme.textTheme.titleMedium : theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
