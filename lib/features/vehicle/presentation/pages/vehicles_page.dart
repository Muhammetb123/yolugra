import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../init/dependency_injection.dart';
import '../../domain/vehicle.dart';
import '../bloc/vehicle_cubits.dart';
import '../widgets/vehicle_tile.dart';

@RoutePage()
class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => VehiclesCubit(sl())..load(), child: const _View());
}

class _View extends StatelessWidget {
  const _View();

  Future<void> _open(BuildContext context, [Vehicle? v]) async {
    final saved = await context.router.push<Vehicle>(VehicleFormRoute(vehicle: v));
    if (saved != null && context.mounted) await context.read<VehiclesCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.vehiclesTitle)),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _open(context), icon: const Icon(Icons.add_rounded), label: Text(l.vehicleAdd)),
      body: BlocBuilder<VehiclesCubit, VehiclesState>(
        builder: (context, s) {
          if (s.status == LoadStatus.failure && s.items.isEmpty) return ErrorView(error: s.error!, onRetry: context.read<VehiclesCubit>().load);
          if (s.status != LoadStatus.success && s.items.isEmpty) return const LoadingView();
          if (s.items.isEmpty) return EmptyState(icon: Icons.directions_car_outlined, title: l.vehicleEmpty, subtitle: l.vehiclePlateNote);
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              for (final v in s.items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: VehicleTile(
                    vehicle: v,
                    onTap: () => _open(context, v),
                    trailing: IconButton(
                      tooltip: l.commonDelete,
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: () async {
                        if (!await confirm(context, l.vehicleDeleteConfirm, confirmLabel: l.commonDelete, danger: true)) return;
                        if (!context.mounted) return;
                        final err = await context.read<VehiclesCubit>().delete(v.id!);
                        if (err != null && context.mounted) showError(context, err);
                      },
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: InfoRow(icon: Icons.lock_outline_rounded, text: l.vehiclePlateNote, muted: true),
              ),
            ],
          );
        },
      ),
    );
  }
}
