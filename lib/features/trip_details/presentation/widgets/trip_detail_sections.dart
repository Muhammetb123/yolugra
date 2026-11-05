import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/rating.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../profile/domain/profile.dart';
import '../../../trips/domain/trip.dart';
import '../../../trips/presentation/widgets/trip_labels.dart';
import '../../../vehicle/domain/vehicle.dart';
import '../../../vehicle/presentation/widgets/vehicle_labels.dart';

class PriceSection extends StatelessWidget {
  const PriceSection({super.key, required this.trip, required this.segment});

  final Trip trip;
  final (int, int) segment;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final free = trip.freeSeats(segment.$1, segment.$2);
    return SectionCard(
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(Formatters.of(context).price(trip.price), style: theme.textTheme.headlineSmall),
              Text(trip.priceNegotiable ? '${l.tripPerSeat} · ${l.tripNegotiable}' : l.tripPerSeat,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(l.seatsLeft(free), style: theme.textTheme.titleMedium?.copyWith(color: free > 0 ? theme.colorScheme.primary : theme.colorScheme.error)),
            Text(l.myTripsSeatsBooked(trip.seatsTotal - free, trip.seatsTotal),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ]),
        ],
      ),
    );
  }
}

class DriverSection extends StatelessWidget {
  const DriverSection({super.key, required this.driver, required this.onTap});

  final UserSummary driver;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        leading: UserAvatar(name: driver.fullName, photoUrl: driver.photoUrl, radius: 26),
        title: Text(driver.fullName, style: theme.textTheme.titleMedium),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 2),
          RatingBadge(average: driver.ratingAvg, count: driver.ratingCount),
          Text(l.completedTripsCount(driver.completedTrips), style: theme.textTheme.bodySmall),
        ]),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

/// Make, model and color for everyone; the plate only when the backend sent it.
class VehicleSection extends StatelessWidget {
  const VehicleSection({super.key, required this.vehicle, required this.plateVisible});

  final Vehicle vehicle;
  final bool plateVisible;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final details = [
      vehicle.color,
      if (vehicle.year != null) '${vehicle.year}',
      if (vehicle.type != null) l.vehicleTypeLabel(vehicle.type!),
    ].join(' · ');
    return SectionCard(
      title: l.tripVehicle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            if (vehicle.photoUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(AppConfig.mediaUrl(vehicle.photoUrl!), width: 72, height: 54, fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox(width: 72, height: 54)),
              )
            else
              Container(
                width: 72,
                height: 54,
                decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.directions_car_rounded, color: theme.colorScheme.primary),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(vehicle.title, style: theme.textTheme.titleMedium),
                Text(details, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ]),
            ),
          ]),
          const SizedBox(height: 12),
          if (vehicle.plate.isNotEmpty && plateVisible)
            InfoRow(icon: Icons.pin_outlined, text: '${l.tripPlate}: ${vehicle.plate}')
          else
            InfoRow(icon: Icons.lock_outline_rounded, text: l.tripPlateHidden, muted: true),
        ],
      ),
    );
  }
}

class AmenitiesSection extends StatelessWidget {
  const AmenitiesSection({super.key, required this.amenities});

  final Amenities amenities;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lines = l.amenityLines(amenities);
    return SectionCard(
      title: l.tripComfort,
      child: lines.isEmpty
          ? InfoRow(icon: Icons.remove_circle_outline_rounded, text: l.commonNotSpecified, muted: true)
          : Column(children: [for (final (icon, text) in lines) InfoRow(icon: icon, text: text)]),
    );
  }
}
