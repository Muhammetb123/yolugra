import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../init/dependency_injection.dart';
import '../../domain/moderation.dart';
import '../bloc/moderation_cubits.dart';
import '../widgets/report_labels.dart';

/// Reports a user to the Ýolugra team: a reason and what happened. [tripId] is set when
/// the form was opened from a trip, so the team knows which one it is about.
@RoutePage()
class ReportUserPage extends StatelessWidget {
  const ReportUserPage({super.key, @PathParam('userId') required this.userId, this.name = '', @QueryParam('trip') this.tripId});

  final String userId;
  final String name;
  final String? tripId;

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (_) => ReportCubit(sl(), userId, tripId: tripId), child: ReportUserView(name: name));
}

class ReportUserView extends StatelessWidget {
  const ReportUserView({super.key, this.name = '', this.onSent});

  final String name;

  /// Runs after the report was accepted. Defaults to leaving the page; tests replace it.
  final VoidCallback? onSent;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return BlocConsumer<ReportCubit, ReportState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, s) {
        if (s.status == LoadStatus.success) {
          showMessage(context, l.reportSent);
          (onSent ?? () => context.router.maybePop(true))();
        } else if (s.status == LoadStatus.failure) {
          showError(context, s.error!);
        }
      },
      builder: (context, s) {
        final cubit = context.read<ReportCubit>();
        return Scaffold(
          appBar: AppBar(title: Text(l.reportTitle)),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              if (name.isNotEmpty) ...[
                Text(l.reportAbout(name), style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
              ],
              RadioGroup<ReportReason>(
                groupValue: s.reason,
                onChanged: (r) => r == null ? null : cubit.setReason(r),
                child: Column(children: [
                  for (final r in ReportReason.values)
                    RadioListTile<ReportReason>(contentPadding: EdgeInsets.zero, value: r, title: Text(l.reportReason(r))),
                ]),
              ),
              const SizedBox(height: 12),
              TextField(
                maxLength: maxReportDetails,
                maxLines: 6,
                minLines: 3,
                textCapitalization: TextCapitalization.sentences,
                onChanged: cubit.setDetails,
                decoration: InputDecoration(
                  labelText: l.reportDetails,
                  alignLabelWithHint: true,
                  helperText: s.detailsRequired ? l.reportDetailsRequired : l.reportDetailsHint,
                  helperMaxLines: 2,
                ),
              ),
              const SizedBox(height: 8),
              InfoRow(icon: Icons.shield_outlined, text: l.reportNote, muted: true),
              const SizedBox(height: 16),
              PrimaryButton(
                label: l.reportSubmit,
                loading: s.status == LoadStatus.loading,
                onPressed: s.canSubmit ? cubit.submit : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
