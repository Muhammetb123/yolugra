import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/rating.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../domain/profile.dart';

/// Photo, name, rating and trip counts. Shared by the own and the public profile.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile, this.onPhotoTap, this.photoBusy = false});

  final Profile profile;
  final VoidCallback? onPhotoTap;
  final bool photoBusy;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Column(
      children: [
        GestureDetector(
          onTap: onPhotoTap,
          child: Stack(alignment: Alignment.bottomRight, children: [
            UserAvatar(name: profile.fullName, photoUrl: profile.photoUrl, radius: 48),
            if (photoBusy) const Positioned.fill(child: CircularProgressIndicator()),
            if (onPhotoTap != null)
              CircleAvatar(radius: 16, backgroundColor: theme.colorScheme.primary, child: Icon(Icons.camera_alt_rounded, size: 16, color: theme.colorScheme.onPrimary)),
          ]),
        ),
        const SizedBox(height: 12),
        Text(profile.fullName, style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
        const SizedBox(height: 4),
        RatingBadge(average: profile.ratingAvg, count: profile.ratingCount),
        const SizedBox(height: 4),
        Text(l.profileMemberSince(Formatters.of(context).monthYear(profile.memberSince)), style: theme.textTheme.bodySmall),
        if (profile.bio?.isNotEmpty ?? false) ...[
          const SizedBox(height: 12),
          Text(profile.bio!, textAlign: TextAlign.center),
        ],
        const SizedBox(height: 16),
        Row(children: [
          _Stat(value: '${profile.tripsAsDriver}', label: l.profileTripsAsDriver),
          _Stat(value: '${profile.tripsAsPassenger}', label: l.profileTripsAsPassenger),
          _Stat(value: profile.ratingCount == 0 ? '—' : Formatters.rating(profile.ratingAvg), label: l.profileRating),
        ]),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(children: [
        Text(value, style: theme.textTheme.titleLarge),
        Text(label, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
      ]),
    );
  }
}
