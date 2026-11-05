import 'package:flutter/material.dart';

import '../../app/localization/l10n.dart';
import '../../app/theme/app_theme.dart';
import '../errors/error_text.dart';

/// Tone of a status chip. Feature code maps its statuses onto these.
enum StatusTone { pending, positive, negative, neutral }

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, required this.tone});

  final String label;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<StatusColors>()!;
    final color = switch (tone) {
      StatusTone.pending => colors.pending,
      StatusTone.positive => colors.positive,
      StatusTone.negative => colors.negative,
      StatusTone.neutral => colors.neutral,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w700)),
    );
  }
}

void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

void showError(BuildContext context, Object error) => showMessage(context, errorText(context.l10n, error));

/// Asks for confirmation. Resolves to true only when the user confirms.
Future<bool> confirm(BuildContext context, String message, {String? confirmLabel, bool danger = false}) async {
  final l = context.l10n;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.commonKeep)),
        FilledButton(
          style: danger ? FilledButton.styleFrom(backgroundColor: Theme.of(ctx).colorScheme.error, minimumSize: const Size(0, 44)) : FilledButton.styleFrom(minimumSize: const Size(0, 44)),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel ?? l.commonConfirm),
        ),
      ],
    ),
  );
  return ok ?? false;
}

/// A − n + control with bounds.
class CounterField extends StatelessWidget {
  const CounterField({super.key, required this.value, required this.min, required this.max, required this.onChanged, this.label});

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        if (label != null) Expanded(child: Text(label!, style: theme.textTheme.bodyLarge)),
        IconButton.filledTonal(
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove_rounded),
        ),
        SizedBox(
          width: 44,
          child: Text('$value', textAlign: TextAlign.center, style: theme.textTheme.titleLarge),
        ),
        IconButton.filledTonal(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add_rounded),
        ),
      ],
    );
  }
}
