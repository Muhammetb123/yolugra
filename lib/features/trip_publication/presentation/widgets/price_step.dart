import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/widgets/section_card.dart';
import '../bloc/publish_trip_cubit.dart';

/// Step 5: price per seat in manat (informational, no payments) and descriptions.
class PriceStep extends StatefulWidget {
  const PriceStep({super.key});

  @override
  State<PriceStep> createState() => _PriceStepState();
}

class _PriceStepState extends State<PriceStep> {
  late final PublishTripCubit _cubit = context.read<PublishTripCubit>();
  late final _price = TextEditingController(text: _cubit.state.price?.toStringAsFixed(0) ?? '');
  late final _description = TextEditingController(text: _cubit.state.description);
  late final _conditions = TextEditingController(text: _cubit.state.conditions);

  @override
  void dispose() {
    _price.dispose();
    _description.dispose();
    _conditions.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final negotiable = context.select((PublishTripCubit c) => c.state.priceNegotiable);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _price,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          onChanged: (v) => _cubit.setPrice(v.trim().isEmpty ? null : double.tryParse(v)),
          decoration: InputDecoration(
            labelText: l.publishPrice,
            helperText: l.publishPriceHint,
            prefixIcon: const Icon(Icons.payments_outlined),
            suffixText: 'TMT',
          ),
        ),
        SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.publishNegotiable), value: negotiable, onChanged: _cubit.setNegotiable),
        InfoRow(icon: Icons.info_outline_rounded, text: l.tripPaymentNote, muted: true),
        const SizedBox(height: 16),
        TextField(
          controller: _description,
          maxLength: 1000,
          maxLines: 5,
          minLines: 3,
          onChanged: _cubit.setDescription,
          decoration: InputDecoration(labelText: '${l.publishDescription} (${l.commonOptional.toLowerCase()})', hintText: l.publishDescriptionHint, alignLabelWithHint: true),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _conditions,
          maxLength: 500,
          maxLines: 3,
          minLines: 2,
          onChanged: _cubit.setConditions,
          decoration: InputDecoration(labelText: '${l.publishConditions} (${l.commonOptional.toLowerCase()})', hintText: l.publishConditionsHint, alignLabelWithHint: true),
        ),
      ],
    );
  }
}
