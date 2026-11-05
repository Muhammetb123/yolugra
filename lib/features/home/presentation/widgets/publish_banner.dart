import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';

/// Invitation to publish a trip, in the accent color.
class PublishBanner extends StatelessWidget {
  const PublishBanner({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: [scheme.primary, Color.lerp(scheme.primary, Colors.black, 0.25)!]),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.homePublishTitle, style: theme.textTheme.titleLarge?.copyWith(color: scheme.onPrimary)),
                const SizedBox(height: 6),
                Text(l.homePublishSubtitle, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onPrimary.withValues(alpha: 0.85))),
                const SizedBox(height: 14),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: scheme.secondary, foregroundColor: scheme.onSecondary, minimumSize: const Size(0, 44)),
                  onPressed: onPressed,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(l.homePublishButton),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.airline_seat_recline_extra_rounded, size: 56, color: scheme.onPrimary.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}
