import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../vehicle/domain/vehicle.dart';
import '../../../vehicle/presentation/widgets/vehicle_tile.dart';
import '../bloc/publish_trip_cubit.dart';

/// Step 3: which car, and how many passenger seats (the driver's seat is not counted).
class VehicleStep extends StatelessWidget {
  const VehicleStep({super.key});

  Future<void> _add(BuildContext context) async {
    final created = await context.router.push<Vehicle>(VehicleFormRoute());
    if (created != null && context.mounted) await context.read<PublishTripCubit>().loadVehicles(select: created.id);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.watch<PublishTripCubit>().state;
    final cubit = context.read<PublishTripCubit>();
    if (s.vehiclesStatus == LoadStatus.loading && s.vehicles.isEmpty) return const LoadingView();
    if (s.vehiclesStatus == LoadStatus.failure && s.vehicles.isEmpty) {
      return ErrorView(error: s.error ?? '', onRetry: cubit.loadVehicles);
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.publishChooseVehicle, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        if (s.vehicles.isEmpty)
          EmptyState(icon: Icons.directions_car_outlined, title: l.publishNoVehicles)
        else
          for (final v in s.vehicles)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: VehicleTile(vehicle: v, selected: v.id == s.vehicleId, onTap: () => cubit.selectVehicle(v.id!)),
            ),
        OutlinedButton.icon(onPressed: () => _add(context), icon: const Icon(Icons.add_rounded), label: Text(l.vehicleAdd)),
        const SizedBox(height: 16),
        SectionCard(
          title: l.publishSeats,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CounterField(value: s.seats, min: 1, max: s.maxSeats, onChanged: cubit.setSeats, label: l.seatsCount(s.seats)),
            const SizedBox(height: 8),
            InfoRow(icon: Icons.info_outline_rounded, text: l.publishSeatsHint, muted: true),
          ]),
        ),
      ],
    );
  }
}
