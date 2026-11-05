import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../domain/trip.dart';
import 'trip_labels.dart';

/// Structured comfort options as chip groups. Used when publishing and editing a trip.
class AmenitiesEditor extends StatelessWidget {
  const AmenitiesEditor({super.key, required this.value, required this.onChanged});

  final Amenities value;
  final ValueChanged<Amenities> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final a = value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Group<YesNo>(
          icon: Icons.ac_unit_rounded, title: l.amenityAirConditioning, values: YesNo.values, selected: a.airConditioning,
          label: l.yesNo, onSelected: (v) => onChanged(a.copyWith(airConditioning: v)),
        ),
        _Group<YesNo>(
          icon: Icons.speaker_rounded, title: l.amenityAudio, values: YesNo.values, selected: a.audioSystem,
          label: l.yesNo, onSelected: (v) => onChanged(a.copyWith(audioSystem: v)),
        ),
        _Group<MusicPolicy>(
          icon: Icons.music_note_rounded, title: l.amenityMusic, values: MusicPolicy.values, selected: a.music,
          label: l.music, onSelected: (v) => onChanged(a.copyWith(music: v)),
        ),
        _Group<SmokingPolicy>(
          icon: Icons.smoke_free_rounded, title: l.amenitySmoking, values: SmokingPolicy.values, selected: a.smoking,
          label: l.smoking, onSelected: (v) => onChanged(a.copyWith(smoking: v)),
        ),
        _Group<PetsPolicy>(
          icon: Icons.pets_rounded, title: l.amenityPets, values: PetsPolicy.values, selected: a.pets,
          label: l.pets, onSelected: (v) => onChanged(a.copyWith(pets: v)),
        ),
        _Group<LuggageSize>(
          icon: Icons.luggage_rounded, title: l.amenityLuggage, values: LuggageSize.values, selected: a.luggage,
          label: l.luggage, onSelected: (v) => onChanged(a.copyWith(luggage: v)),
        ),
        _Group<YesNo>(
          icon: Icons.child_friendly_rounded, title: l.amenityChildSeat, values: YesNo.values, selected: a.childSeat,
          label: l.yesNo, onSelected: (v) => onChanged(a.copyWith(childSeat: v)),
        ),
        _Group<Conversation>(
          icon: Icons.forum_rounded, title: l.amenityConversation, values: Conversation.values, selected: a.conversation,
          label: l.conversation, onSelected: (v) => onChanged(a.copyWith(conversation: v)),
        ),
      ],
    );
  }
}

class _Group<T extends Enum> extends StatelessWidget {
  const _Group({required this.icon, required this.title, required this.values, required this.selected, required this.label, required this.onSelected});

  final IconData icon;
  final String title;
  final List<T> values;
  final T selected;
  final String Function(T) label;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // "Not specified" goes last so the meaningful choices come first.
    final ordered = [...values.where((v) => v.name != 'unspecified'), ...values.where((v) => v.name == 'unspecified')];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(title, style: theme.textTheme.titleSmall),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final v in ordered) ChoiceChip(label: Text(label(v)), selected: v == selected, onSelected: (_) => onSelected(v)),
          ]),
        ],
      ),
    );
  }
}
