import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../trips/presentation/widgets/trip_labels.dart';
import '../bloc/publish_trip_cubit.dart';

/// Step 6: everything at a glance, each block editable, before publishing.
class ReviewStep extends StatelessWidget {
  const ReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.languageCode;
    final fmt = Formatters.of(context);
    final theme = Theme.of(context);
    final s = context.watch<PublishTripCubit>().state;
    final cubit = context.read<PublishTripCubit>();
    Widget edit(PublishStep step) => IconButton(onPressed: () => cubit.goTo(step), icon: const Icon(Icons.edit_outlined));
    final amenities = l.amenityLines(s.amenities);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionCard(
          title: l.publishStepRoute,
          trailing: edit(PublishStep.route),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (final st in s.stops)
              InfoRow(
                icon: st == s.stops.first ? Icons.trip_origin_rounded : st == s.stops.last ? Icons.place_rounded : Icons.more_vert_rounded,
                text: [st.location?.name(lang) ?? '—', if (st.meetingPoint.trim().isNotEmpty) st.meetingPoint.trim()].join(' · '),
              ),
          ]),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: l.publishStepSchedule,
          trailing: edit(PublishStep.schedule),
          child: Column(children: [
            InfoRow(icon: Icons.event_rounded, text: '${fmt.fullDate(s.departsAt)}, ${fmt.time(s.departsAt)}'),
            InfoRow(icon: Icons.flag_rounded, text: l.publishArrivalPreview(fmt.dayAndTime(s.arrivesAt))),
          ]),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: l.publishStepVehicle,
          trailing: edit(PublishStep.vehicle),
          child: Column(children: [
            InfoRow(icon: Icons.directions_car_rounded, text: s.vehicle == null ? '—' : '${s.vehicle!.title} · ${s.vehicle!.color}'),
            InfoRow(icon: Icons.event_seat_rounded, text: l.seatsCount(s.seats)),
          ]),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: l.publishStepComfort,
          trailing: edit(PublishStep.comfort),
          child: amenities.isEmpty
              ? InfoRow(icon: Icons.remove_circle_outline_rounded, text: l.commonNotSpecified, muted: true)
              : Column(children: [for (final (i, t) in amenities) InfoRow(icon: i, text: t)]),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: l.publishStepPrice,
          trailing: edit(PublishStep.price),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(fmt.price(s.price), style: theme.textTheme.titleLarge),
            if (s.priceNegotiable) Text(l.tripNegotiable),
            if (s.description.trim().isNotEmpty) ...[const SizedBox(height: 8), Text(s.description.trim())],
            if (s.conditions.trim().isNotEmpty) ...[const SizedBox(height: 8), Text(s.conditions.trim(), style: theme.textTheme.bodySmall)],
          ]),
        ),
      ],
    );
  }
}
