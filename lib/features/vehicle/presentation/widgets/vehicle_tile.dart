import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/config/app_config.dart';
import '../../domain/vehicle.dart';

/// A vehicle row. The owner sees the plate; [selected] marks the chosen car.
class VehicleTile extends StatelessWidget {
  const VehicleTile({super.key, required this.vehicle, this.onTap, this.selected = false, this.trailing});

  final Vehicle vehicle;
  final VoidCallback? onTap;
  final bool selected;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l = context.l10n;
    final subtitle = [
      vehicle.color,
      if (vehicle.plate.isNotEmpty) vehicle.plate,
      if (vehicle.passengerSeats != null) l.seatsCount(vehicle.passengerSeats!),
    ].join(' · ');
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: selected ? scheme.primary : scheme.outlineVariant, width: selected ? 2 : 1),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: vehicle.photoUrl == null
              ? Container(width: 52, height: 52, color: scheme.primaryContainer, child: Icon(Icons.directions_car_rounded, color: scheme.primary))
              : Image.network(AppConfig.mediaUrl(vehicle.photoUrl!), width: 52, height: 52, fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(width: 52, height: 52, color: scheme.primaryContainer)),
        ),
        title: Text(vehicle.title, style: theme.textTheme.titleMedium),
        subtitle: Text(subtitle),
        trailing: trailing ?? (selected ? Icon(Icons.check_circle_rounded, color: scheme.primary) : null),
      ),
    );
  }
}
