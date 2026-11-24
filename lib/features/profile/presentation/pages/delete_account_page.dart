import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../init/dependency_injection.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../bloc/profile_cubits.dart';

/// Says what deleting the account removes and what stays, then deletes it. The backend
/// does the work in one transaction; afterwards the app returns to sign-in.
@RoutePage()
class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (_) => DeleteAccountCubit(sl()), child: const DeleteAccountView());
}

class DeleteAccountView extends StatelessWidget {
  const DeleteAccountView({super.key});

  Future<void> _delete(BuildContext context) async {
    final l = context.l10n;
    final cubit = context.read<DeleteAccountCubit>();
    if (await confirm(context, l.deleteAccountConfirm, confirmLabel: l.commonDelete, danger: true)) await cubit.submit();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    return BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, s) {
        if (s.status == LoadStatus.success) {
          showMessage(context, l.deleteAccountDone);
          context.read<AuthBloc>().add(const AuthAccountDeleted());
        } else if (s.status == LoadStatus.failure) {
          showError(context, s.error!);
        }
      },
      builder: (context, s) {
        final busy = s.status == LoadStatus.loading || s.status == LoadStatus.success;
        return Scaffold(
          appBar: AppBar(title: Text(l.deleteAccountTitle)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l.deleteAccountIntro, style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              SectionCard(
                title: l.deleteAccountRemovedTitle,
                child: Column(children: [
                  InfoRow(icon: Icons.person_outline_rounded, text: l.deleteAccountRemovedProfile),
                  InfoRow(icon: Icons.directions_car_outlined, text: l.deleteAccountRemovedVehicles),
                  InfoRow(icon: Icons.star_outline_rounded, text: l.deleteAccountRemovedReviews),
                  InfoRow(icon: Icons.notes_rounded, text: l.deleteAccountRemovedTexts),
                  InfoRow(icon: Icons.notifications_none_rounded, text: l.deleteAccountRemovedInbox),
                ]),
              ),
              const SizedBox(height: 12),
              InfoRow(icon: Icons.event_busy_rounded, text: l.deleteAccountCancelled),
              const SizedBox(height: 12),
              SectionCard(
                title: l.deleteAccountKeptTitle,
                child: Column(children: [
                  InfoRow(icon: Icons.history_rounded, text: l.deleteAccountKeptHistory, muted: true),
                  InfoRow(icon: Icons.star_half_rounded, text: l.deleteAccountKeptRatings, muted: true),
                  InfoRow(icon: Icons.flag_outlined, text: l.deleteAccountKeptReports, muted: true),
                ]),
              ),
              const SizedBox(height: 16),
              Text(l.deleteAccountAfter, style: muted),
              const SizedBox(height: 24),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error, foregroundColor: theme.colorScheme.onError),
                onPressed: busy ? null : () => _delete(context),
                child: busy
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                    : Text(l.deleteAccountButton),
              ),
            ),
          ),
        );
      },
    );
  }
}
