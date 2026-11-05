import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../domain/review.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({super.key, required this.review});
  final Review review;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final r = review;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            UserAvatar(name: r.author.fullName, photoUrl: r.author.photoUrl, radius: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.author.fullName, style: theme.textTheme.titleSmall),
                Text('${r.authorRole == ReviewerRole.driver ? l.reviewByDriver : l.reviewByPassenger} · ${Formatters.of(context).fullDate(r.createdAt)}',
                    style: theme.textTheme.bodySmall),
              ]),
            ),
            Row(children: [
              for (var i = 1; i <= 5; i++) Icon(i <= r.rating ? Icons.star_rounded : Icons.star_outline_rounded, size: 16, color: AppColors.saffron),
            ]),
          ]),
          if (r.comment?.isNotEmpty ?? false) ...[const SizedBox(height: 10), Text(r.comment!)],
        ]),
      ),
    );
  }
}
