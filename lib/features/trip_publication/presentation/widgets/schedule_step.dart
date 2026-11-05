import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/section_card.dart';
import '../bloc/publish_trip_cubit.dart';

/// Step 2: date, time and the estimated duration. The duration matters: the backend
/// uses it to keep a driver's trips from overlapping.
class ScheduleStep extends StatelessWidget {
  const ScheduleStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final fmt = Formatters.of(context);
    final theme = Theme.of(context);
    final s = context.watch<PublishTripCubit>().state;
    final cubit = context.read<PublishTripCubit>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionCard(
          child: Column(children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_rounded),
              title: Text(l.publishDate),
              subtitle: Text(fmt.fullDate(s.date), style: theme.textTheme.titleMedium),
              trailing: const Icon(Icons.edit_calendar_rounded),
              onTap: () async {
                final now = DateTime.now();
                final d = await showDatePicker(
                  context: context,
                  firstDate: DateUtils.dateOnly(now),
                  lastDate: now.add(const Duration(days: 89)),
                  initialDate: s.date.isBefore(now) ? now : s.date,
                );
                if (d != null) cubit.setDate(d);
              },
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule_rounded),
              title: Text(l.publishTime),
              subtitle: Text(fmt.time(s.departsAt), style: theme.textTheme.titleMedium),
              trailing: const Icon(Icons.edit_rounded),
              onTap: () async {
                final t = await showTimePicker(context: context, initialTime: s.time);
                if (t != null) cubit.setTime(t);
              },
            ),
          ]),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: l.publishDuration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fmt.duration(s.duration), style: theme.textTheme.headlineSmall),
              Slider(
                min: 15,
                max: 24 * 60,
                divisions: (24 * 60 - 15) ~/ 15,
                value: s.duration.inMinutes.clamp(15, 24 * 60).toDouble(),
                label: fmt.duration(s.duration),
                onChanged: (v) => cubit.setDuration(Duration(minutes: (v / 15).round() * 15)),
              ),
              InfoRow(icon: Icons.flag_rounded, text: l.publishArrivalPreview(fmt.dayAndTime(s.arrivesAt))),
              InfoRow(icon: Icons.info_outline_rounded, text: l.tripEstimateNote, muted: true),
            ],
          ),
        ),
      ],
    );
  }
}
