import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/errors/error_text.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../init/dependency_injection.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/login_cubits.dart';
import '../widgets/auth_widgets.dart';

@RoutePage()
class OtpPage extends StatelessWidget {
  const OtpPage({super.key, required this.phone, this.devCode});

  final String phone;

  /// Returned by the backend only with DEV_MODE=true; shown only in debug builds.
  final String? devCode;

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (_) => OtpCubit(sl(), phone, devCode: devCode), child: _OtpView(phone: phone));
}

class _OtpView extends StatefulWidget {
  const _OtpView({required this.phone});
  final String phone;

  @override
  State<_OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<_OtpView> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<OtpCubit, OtpState>(
        listenWhen: (a, b) => a.status != b.status || a.resent != b.resent,
        listener: (context, state) {
          if (state.status == LoadStatus.success && state.profile != null) {
            context.read<AuthBloc>().add(AuthSignedIn(state.profile!));
          }
          if (state.resent) showMessage(context, l.authCodeResent);
        },
        builder: (context, state) {
          final cubit = context.read<OtpCubit>();
          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              children: [
                Text(l.authCodeTitle, style: theme.textTheme.headlineMedium),
                const SizedBox(height: 12),
                Text(l.authCodeSentTo(Formatters.phone(widget.phone)),
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 32),
                CodeField(
                  controller: _code,
                  errorText: state.status == LoadStatus.failure && state.error != null ? errorText(l, state.error!) : null,
                  onCompleted: cubit.verify,
                ),
                if (kDebugMode && state.devCode != null) ...[
                  const SizedBox(height: 8),
                  Text('DEV: ${state.devCode}', textAlign: TextAlign.center, style: theme.textTheme.labelSmall),
                ],
                const SizedBox(height: 20),
                PrimaryButton(
                  label: l.authVerify,
                  loading: state.status == LoadStatus.loading,
                  onPressed: () => cubit.verify(_code.text),
                ),
                const SizedBox(height: 12),
                Center(
                  child: state.resendIn > 0
                      ? Text(l.authResendIn(state.resendIn), style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))
                      : TextButton(onPressed: state.resending ? null : cubit.resend, child: Text(l.authResend)),
                ),
                Center(child: TextButton(onPressed: () => context.router.maybePop(), child: Text(l.authChangeNumber))),
              ],
            ),
          );
        },
      ),
    );
  }
}
