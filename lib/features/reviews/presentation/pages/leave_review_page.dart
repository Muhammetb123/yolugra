import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/rating.dart';
import '../../../../init/dependency_injection.dart';
import '../bloc/review_cubit.dart';

/// Rates the other participant of a completed booking. The backend decides eligibility.
@RoutePage()
class LeaveReviewPage extends StatelessWidget {
  const LeaveReviewPage({super.key, @PathParam('bookingId') required this.bookingId, required this.name, required this.aboutDriver});

  final String bookingId;
  final String name;
  final bool aboutDriver;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => ReviewCubit(sl(), bookingId),
      child: BlocConsumer<ReviewCubit, ReviewState>(
        listener: (context, s) {
          if (s.status == LoadStatus.success) {
            showMessage(context, l.reviewThanks);
            context.router.maybePop(true);
          } else if (s.status == LoadStatus.failure) {
            showError(context, s.error!);
          }
        },
        builder: (context, s) {
          final cubit = context.read<ReviewCubit>();
          return Scaffold(
            appBar: AppBar(title: Text(l.reviewTitle)),
            body: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(aboutDriver ? l.reviewAboutDriver(name) : l.reviewAboutPassenger(name),
                    style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                StarRatingInput(value: s.rating, onChanged: cubit.setRating),
                if (s.rating == 0)
                  Text(l.reviewChooseRating, textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
                const SizedBox(height: 20),
                TextField(
                  maxLength: 1000,
                  maxLines: 5,
                  minLines: 3,
                  onChanged: cubit.setComment,
                  decoration: InputDecoration(hintText: l.reviewCommentHint),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: l.reviewSubmit,
                  loading: s.status == LoadStatus.loading,
                  onPressed: s.rating > 0 ? cubit.submit : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
