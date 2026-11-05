import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../init/dependency_injection.dart';
import '../../../trips/domain/trip.dart';
import '../../../trips/presentation/widgets/amenities_editor.dart';
import '../bloc/trip_manage_cubit.dart';

/// Edits what a driver may change after publishing. The route is fixed (bookings refer
/// to its stops); the schedule can move only while nobody has asked for a seat.
@RoutePage()
class EditTripPage extends StatelessWidget {
  const EditTripPage({super.key, @PathParam('tripId') required this.tripId, required this.trip});

  final String tripId;
  final Trip trip;

  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => EditTripCubit(sl(), tripId), child: _EditView(trip: trip));
}

class _EditView extends StatefulWidget {
  const _EditView({required this.trip});
  final Trip trip;

  @override
  State<_EditView> createState() => _EditViewState();
}

class _EditViewState extends State<_EditView> {
  late Trip t = widget.trip;
  late int _seats = t.seatsTotal;
  late final _price = TextEditingController(text: t.price?.toStringAsFixed(0) ?? '');
  late bool _negotiable = t.priceNegotiable;
  late final _description = TextEditingController(text: t.description ?? '');
  late final _conditions = TextEditingController(text: t.conditions ?? '');
  late Amenities _amenities = t.amenities;
  late DateTime _departs = t.departsAt.toLocal();
  late final Duration _duration = t.arrivesAt.difference(t.departsAt);
  late final _meeting = {for (final s in t.stops) s.order: TextEditingController(text: s.meetingPoint ?? '')};

  bool get _scheduleLocked => (t.pendingRequests ?? 0) > 0 || (t.approvedSeats ?? 0) > 0;

  @override
  void dispose() {
    for (final c in [_price, _description, _conditions, ..._meeting.values]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    final priceText = _price.text.trim();
    final price = double.tryParse(priceText);
    final moved = !_departs.isAtSameMomentAs(t.departsAt.toLocal());
    final meeting = <int, String>{
      for (final s in t.stops)
        if ((_meeting[s.order]!.text.trim()) != (s.meetingPoint ?? '')) s.order: _meeting[s.order]!.text.trim(),
    };
    context.read<EditTripCubit>().save(TripPatch(
          seats: _seats != t.seatsTotal ? _seats : null,
          price: price,
          clearPrice: priceText.isEmpty && t.price != null,
          priceNegotiable: _negotiable,
          description: _description.text.trim(),
          conditions: _conditions.text.trim(),
          amenities: _amenities,
          departsAt: moved ? _departs : null,
          arrivesAt: moved ? _departs.add(_duration) : null,
          meetingPoints: meeting,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.languageCode;
    final fmt = Formatters.of(context);
    final maxSeats = t.vehicle?.passengerSeats ?? 8;
    return BlocConsumer<EditTripCubit, EditTripState>(
      listener: (context, s) {
        if (s.status == LoadStatus.success && s.trip != null) {
          showMessage(context, l.editTripSaved);
          context.router.maybePop(s.trip);
        } else if (s.status == LoadStatus.failure) {
          showError(context, s.error!);
        }
      },
      builder: (context, s) => Scaffold(
        appBar: AppBar(title: Text(l.editTripTitle)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SectionCard(
              title: l.publishStepSchedule,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  enabled: !_scheduleLocked,
                  leading: const Icon(Icons.event_rounded),
                  title: Text('${fmt.fullDate(_departs)}, ${fmt.time(_departs)}'),
                  trailing: const Icon(Icons.edit_calendar_rounded),
                  onTap: () async {
                    final now = DateTime.now();
                    final d = await showDatePicker(context: context, firstDate: DateUtils.dateOnly(now), lastDate: now.add(const Duration(days: 89)), initialDate: _departs);
                    if (d == null || !context.mounted) return;
                    final tm = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_departs));
                    if (tm == null) return;
                    setState(() => _departs = DateTime(d.year, d.month, d.day, tm.hour, tm.minute));
                  },
                ),
                if (_scheduleLocked) InfoRow(icon: Icons.lock_outline_rounded, text: l.editTripScheduleLocked, muted: true),
              ]),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: l.tripMeetingPoint,
              child: Column(children: [
                for (final st in t.stops)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: _meeting[st.order],
                      maxLength: 200,
                      decoration: InputDecoration(labelText: st.location.name(lang), hintText: l.publishMeetingPointHint, counterText: ''),
                    ),
                  ),
              ]),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: l.publishSeats,
              child: CounterField(value: _seats, min: 1, max: maxSeats, onChanged: (v) => setState(() => _seats = v), label: l.seatsCount(_seats)),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: l.publishStepPrice,
              child: Column(children: [
                TextField(
                  controller: _price,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  decoration: InputDecoration(labelText: l.publishPrice, helperText: l.publishPriceHint, suffixText: 'TMT'),
                ),
                SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.publishNegotiable), value: _negotiable, onChanged: (v) => setState(() => _negotiable = v)),
                TextField(controller: _description, maxLength: 1000, maxLines: 4, minLines: 2, decoration: InputDecoration(labelText: l.publishDescription)),
                TextField(controller: _conditions, maxLength: 500, maxLines: 3, minLines: 1, decoration: InputDecoration(labelText: l.publishConditions)),
              ]),
            ),
            const SizedBox(height: 12),
            SectionCard(title: l.tripComfort, child: AmenitiesEditor(value: _amenities, onChanged: (a) => setState(() => _amenities = a))),
            const SizedBox(height: 20),
            PrimaryButton(label: l.commonSave, loading: s.status == LoadStatus.loading, onPressed: _save),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
