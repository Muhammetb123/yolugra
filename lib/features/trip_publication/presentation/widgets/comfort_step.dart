import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../trips/domain/trip.dart';
import '../../../trips/presentation/widgets/amenities_editor.dart';
import '../bloc/publish_trip_cubit.dart';

/// Step 4: comfort options. Everything is optional and defaults to "not specified".
class ComfortStep extends StatelessWidget {
  const ComfortStep({super.key});

  @override
  Widget build(BuildContext context) {
    final amenities = context.select((PublishTripCubit c) => c.state.amenities);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(context.l10n.publishComfortHint, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        AmenitiesEditor(value: amenities, onChanged: (Amenities a) => context.read<PublishTripCubit>().setAmenities(a)),
      ],
    );
  }
}
