import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/trip.dart';

/// The route as a vertical timeline. Stops outside [highlight] are dimmed, so a
/// passenger sees which part of the journey is theirs.
class RouteTimeline extends StatelessWidget {
  const RouteTimeline({super.key, required this.stops, this.highlight, this.showMeetingPoints = true});

  final List<TripStop> stops;
  final (int, int)? highlight;
  final bool showMeetingPoints;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fmt = Formatters.of(context);
    final l = context.l10n;
    final lang = context.languageCode;
    return Column(
      children: [
        for (final s in stops)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 52,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      s.plannedAt == null ? '' : fmt.time(s.plannedAt!),
                      style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700, color: _inRange(s.order) ? null : theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                ),
                _Rail(first: s.order == 0, last: s.order == stops.length - 1, active: _inRange(s.order), activeBelow: _segmentActive(s.order)),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.location.name(lang),
                          style: theme.textTheme.titleMedium?.copyWith(
                              color: _inRange(s.order) ? null : theme.colorScheme.onSurfaceVariant),
                        ),
                        if (showMeetingPoints && (s.meetingPoint?.isNotEmpty ?? false))
                          Text(s.meetingPoint!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        if (s.order != 0 && s.order != stops.length - 1 && s.type != StopType.both)
                          Text(s.type == StopType.pickup ? l.tripStopPickupOnly : l.tripStopDropoffOnly,
                              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.secondary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  bool _inRange(int order) => highlight == null || (order >= highlight!.$1 && order <= highlight!.$2);
  bool _segmentActive(int order) => highlight == null || (order >= highlight!.$1 && order < highlight!.$2);
}

class _Rail extends StatelessWidget {
  const _Rail({required this.first, required this.last, required this.active, required this.activeBelow});

  final bool first;
  final bool last;
  final bool active;
  final bool activeBelow;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final on = scheme.primary;
    final off = scheme.outlineVariant;
    return SizedBox(
      width: 16,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: first || last ? (active ? on : off) : scheme.surface,
              border: Border.all(color: active ? on : off, width: 3),
            ),
          ),
          if (!last) Expanded(child: Container(width: 3, color: activeBelow ? on : off)),
        ],
      ),
    );
  }
}
