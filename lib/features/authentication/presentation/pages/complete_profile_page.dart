import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../init/dependency_injection.dart';
import '../../../profile/presentation/bloc/profile_cubits.dart';
import '../../../profile/presentation/widgets/name_fields.dart';
import '../bloc/auth_bloc.dart';

/// First and last name are mandatory before the app opens.
@RoutePage()
class CompleteProfilePage extends StatelessWidget {
  const CompleteProfilePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => ProfileFormCubit(sl()), child: const _View());
}

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  final _form = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [TextButton(onPressed: () => context.read<AuthBloc>().add(const AuthLogoutRequested()), child: Text(l.profileLogout))],
      ),
      body: BlocConsumer<ProfileFormCubit, ProfileFormState>(
        listener: (context, state) {
          if (state.status == LoadStatus.success && state.profile != null) {
            context.read<AuthBloc>().add(AuthProfileChanged(state.profile!));
          } else if (state.status == LoadStatus.failure) {
            showError(context, state.error!);
          }
        },
        builder: (context, state) => SafeArea(
          child: Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(l.completeProfileTitle, style: theme.textTheme.headlineMedium),
                const SizedBox(height: 12),
                Text(l.completeProfileSubtitle, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 28),
                NameFields(first: _first, last: _last),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: l.completeProfileButton,
                  loading: state.status == LoadStatus.loading,
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      context.read<ProfileFormCubit>().save(firstName: _first.text, lastName: _last.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
