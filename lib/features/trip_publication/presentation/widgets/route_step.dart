import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../locations/presentation/widgets/location_picker.dart';
import '../../../trips/domain/trip.dart';
import '../../../trips/presentation/widgets/trip_labels.dart';
import '../bloc/publish_trip_cubit.dart';

/// Step 1: departure, intermediate stops (reorderable) and destination.
class RouteStep extends StatelessWidget {
  const RouteStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final stops = context.select((PublishTripCubit c) => c.state.stops);
    final cubit = context.read<PublishTripCubit>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (var i = 0; i < stops.length; i++) ...[
          _StopEditor(index: i, count: stops.length, stop: stops[i]),
          if (i == stops.length - 2)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: OutlinedButton.icon(
                onPressed: stops.length < 8 ? cubit.addStop : null,
                icon: const Icon(Icons.add_location_alt_outlined),
                label: Text(l.publishAddStop),
              ),
            )
          else
            const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _StopEditor extends StatefulWidget {
  const _StopEditor({required this.index, required this.count, required this.stop});

  final int index;
  final int count;
  final StopDraft stop;

  @override
  State<_StopEditor> createState() => _StopEditorState();
}

class _StopEditorState extends State<_StopEditor> {
  late final _meeting = TextEditingController(text: widget.stop.meetingPoint);

  @override
  void didUpdateWidget(covariant _StopEditor old) {
    super.didUpdateWidget(old);
    if (widget.stop.meetingPoint != _meeting.text) _meeting.text = widget.stop.meetingPoint;
  }

  @override
  void dispose() {
    _meeting.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final lang = context.languageCode;
    final cubit = context.read<PublishTripCubit>();
    final i = widget.index;
    final first = i == 0;
    final last = i == widget.count - 1;
    final title = first ? l.publishDeparture : last ? l.publishDestination : l.publishStop(i);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(first ? Icons.trip_origin_rounded : last ? Icons.place_rounded : Icons.more_vert_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
              if (!first && !last) ...[
                IconButton(tooltip: l.publishMoveUp, onPressed: i > 1 ? () => cubit.moveStop(i, -1) : null, icon: const Icon(Icons.arrow_upward_rounded)),
                IconButton(tooltip: l.publishMoveDown, onPressed: i < widget.count - 2 ? () => cubit.moveStop(i, 1) : null, icon: const Icon(Icons.arrow_downward_rounded)),
                IconButton(tooltip: l.publishRemoveStop, onPressed: () => cubit.removeStop(i), icon: const Icon(Icons.delete_outline_rounded)),
              ],
            ]),
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                final loc = await pickLocation(context);
                if (loc != null) cubit.setStopLocation(i, loc);
              },
              child: InputDecorator(
                decoration: const InputDecoration(prefixIcon: Icon(Icons.location_city_rounded)),
                child: Text(widget.stop.location?.name(lang) ?? l.publishChooseCity,
                    style: widget.stop.location == null ? TextStyle(color: theme.colorScheme.onSurfaceVariant) : theme.textTheme.titleMedium),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _meeting,
              maxLength: 200,
              onChanged: (v) => cubit.setMeetingPoint(i, v),
              decoration: InputDecoration(
                labelText: '${l.publishMeetingPoint} (${l.commonOptional.toLowerCase()})',
                hintText: l.publishMeetingPointHint,
                counterText: '',
              ),
            ),
            if (!first && !last) ...[
              const SizedBox(height: 10),
              Text(l.publishStopType, style: theme.textTheme.labelMedium),
              const SizedBox(height: 6),
              Wrap(spacing: 8, children: [
                for (final t in StopType.values)
                  ChoiceChip(label: Text(l.stopType(t)), selected: widget.stop.type == t, onSelected: (_) => cubit.setStopType(i, t)),
              ]),
              const SizedBox(height: 6),
              _StopTime(index: i, value: widget.stop.plannedAt),
            ],
          ],
        ),
      ),
    );
  }
}

/// Optional estimated time at an intermediate stop, chosen relative to the departure day.
class _StopTime extends StatelessWidget {
  const _StopTime({required this.index, required this.value});
  final int index;
  final DateTime? value;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PublishTripCubit>();
    return Row(children: [
      Expanded(
        child: TextButton.icon(
          style: TextButton.styleFrom(alignment: Alignment.centerLeft, padding: EdgeInsets.zero),
          onPressed: () async {
            final s = cubit.state;
            final initial = value != null ? TimeOfDay.fromDateTime(value!) : s.time;
            final t = await showTimePicker(context: context, initialTime: initial);
            if (t == null) return;
            var at = DateTime(s.date.year, s.date.month, s.date.day, t.hour, t.minute);
            if (at.isBefore(s.departsAt)) at = at.add(const Duration(days: 1));
            cubit.setStopTime(index, at);
          },
          icon: const Icon(Icons.schedule_rounded),
          label: Text(value == null
              ? '${l.publishStopTime} (${l.commonOptional.toLowerCase()})'
              : '${l.publishStopTime}: ${Formatters.of(context).dayAndTime(value!)}'),
        ),
      ),
      if (value != null) IconButton(onPressed: () => cubit.setStopTime(index, null), icon: const Icon(Icons.close_rounded)),
    ]);
  }
}
