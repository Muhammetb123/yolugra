import 'package:flutter/material.dart';

import '../../app/localization/l10n.dart';
import '../../app/theme/app_theme.dart';
import '../utils/formatters.dart';

/// Average rating with its count, or a "new" label when nobody has rated yet.
/// Ratings are never invented: with zero reviews no stars are shown.
class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.average, required this.count, this.compact = false});

  final double average;
  final int count;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    if (count == 0) return Text(context.l10n.newDriver, style: style);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 18, color: AppColors.saffron),
        const SizedBox(width: 2),
        Text(
          compact ? Formatters.rating(average) : context.l10n.ratingValue(Formatters.rating(average), count),
          style: style?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface),
        ),
      ],
    );
  }
}

/// Five tappable stars.
class StarRatingInput extends StatelessWidget {
  const StarRatingInput({super.key, required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 1; i <= 5; i++)
          IconButton(
            iconSize: 44,
            onPressed: () => onChanged(i),
            icon: Icon(i <= value ? Icons.star_rounded : Icons.star_outline_rounded,
                color: i <= value ? AppColors.saffron : Theme.of(context).colorScheme.outline),
          ),
      ],
    );
  }
}
