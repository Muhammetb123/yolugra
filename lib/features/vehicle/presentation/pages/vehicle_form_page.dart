import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/photo_source.dart';
import '../../../../init/dependency_injection.dart';
import '../../domain/vehicle.dart';
import '../bloc/vehicle_cubits.dart';
import '../widgets/vehicle_labels.dart';

/// Adds or edits a car. Pops with the saved vehicle.
@RoutePage()
class VehicleFormPage extends StatelessWidget {
  const VehicleFormPage({super.key, this.vehicle});

  final Vehicle? vehicle;

  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => VehicleFormCubit(sl()), child: _Form(vehicle: vehicle));
}

class _Form extends StatefulWidget {
  const _Form({this.vehicle});
  final Vehicle? vehicle;

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final _key = GlobalKey<FormState>();
  late final _brand = TextEditingController(text: widget.vehicle?.brand);
  late final _model = TextEditingController(text: widget.vehicle?.model);
  late final _color = TextEditingController(text: widget.vehicle?.color);
  late final _plate = TextEditingController(text: widget.vehicle?.plate);
  late final _year = TextEditingController(text: widget.vehicle?.year?.toString());
  late VehicleType? _type = widget.vehicle?.type;
  late int _seats = widget.vehicle?.passengerSeats ?? 4;
  String? _photo;

  @override
  void dispose() {
    for (final c in [_brand, _model, _color, _plate, _year]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!_key.currentState!.validate()) return;
    context.read<VehicleFormCubit>().save(
          Vehicle(
            id: widget.vehicle?.id,
            brand: _brand.text.trim(),
            model: _model.text.trim(),
            color: _color.text.trim(),
            plate: _plate.text.trim(),
            year: int.tryParse(_year.text.trim()),
            type: _type,
            passengerSeats: _seats,
          ),
          photoPath: _photo,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String? required(String? v, int max) {
      final t = v?.trim() ?? '';
      if (t.isEmpty) return l.validationRequired;
      if (t.length > max) return l.validationTooLong(max);
      return null;
    }

    final existingPhoto = widget.vehicle?.photoUrl;
    return BlocConsumer<VehicleFormCubit, VehicleFormState>(
      listener: (context, s) {
        if (s.status == LoadStatus.success && s.saved != null) {
          showMessage(context, l.vehicleSaved);
          context.router.maybePop(s.saved);
        } else if (s.status == LoadStatus.failure) {
          showError(context, s.error!);
        }
      },
      builder: (context, s) => Scaffold(
        appBar: AppBar(title: Text(widget.vehicle == null ? l.vehicleAdd : l.vehicleEdit)),
        body: Form(
          key: _key,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              GestureDetector(
                onTap: () async {
                  final path = await pickPhoto(context);
                  if (path != null) setState(() => _photo = path);
                },
                child: Container(
                  height: 160,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(16)),
                  child: _photo != null
                      ? Image.file(File(_photo!), fit: BoxFit.cover)
                      : existingPhoto != null
                          ? Image.network(AppConfig.mediaUrl(existingPhoto), fit: BoxFit.cover)
                          : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              const Icon(Icons.add_a_photo_outlined, size: 36),
                              const SizedBox(height: 8),
                              Text('${l.vehiclePhoto} (${l.commonOptional.toLowerCase()})'),
                            ]),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(controller: _brand, textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: l.vehicleBrand, hintText: l.vehicleBrandHint), validator: (v) => required(v, 40)),
              const SizedBox(height: 12),
              TextFormField(controller: _model, textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: l.vehicleModel, hintText: l.vehicleModelHint), validator: (v) => required(v, 40)),
              const SizedBox(height: 12),
              TextFormField(controller: _color, textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(labelText: l.vehicleColor), validator: (v) => required(v, 30)),
              const SizedBox(height: 12),
              TextFormField(controller: _plate, textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(labelText: l.vehiclePlate, helperText: l.vehiclePlateNote, helperMaxLines: 2), validator: (v) => required(v, 20)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _year,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                decoration: InputDecoration(labelText: '${l.vehicleYear} (${l.commonOptional.toLowerCase()})'),
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  final y = int.tryParse(v);
                  return y == null || y < 1950 || y > 2100 ? l.validationYear : null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<VehicleType?>(
                initialValue: _type,
                decoration: InputDecoration(labelText: '${l.vehicleType} (${l.commonOptional.toLowerCase()})'),
                items: [
                  DropdownMenuItem(value: null, child: Text(l.commonNotSpecified)),
                  for (final t in VehicleType.values) DropdownMenuItem(value: t, child: Text(l.vehicleTypeLabel(t))),
                ],
                onChanged: (v) => setState(() => _type = v),
              ),
              const SizedBox(height: 16),
              CounterField(label: l.vehicleSeats, value: _seats, min: 1, max: 8, onChanged: (v) => setState(() => _seats = v)),
              Text(l.publishSeatsHint, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 24),
              PrimaryButton(label: l.commonSave, loading: s.status == LoadStatus.loading, onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
