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
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/widgets/auth_widgets.dart';
import '../bloc/profile_cubits.dart';

/// A new number is confirmed with an OTP sent to it by the existing SMS gateway.
@RoutePage()
class ChangePhonePage extends StatelessWidget {
  const ChangePhonePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => ChangePhoneCubit(sl()), child: const _View());
}

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  final _phone = TextEditingController();
  final _code = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return BlocConsumer<ChangePhoneCubit, ChangePhoneState>(
      listener: (context, s) {
        if (s.status == LoadStatus.success && s.profile != null) {
          context.read<AuthBloc>().add(AuthProfileChanged(s.profile!));
          showMessage(context, l.changePhoneSuccess);
          context.router.maybePop();
        }
      },
      builder: (context, s) {
        final cubit = context.read<ChangePhoneCubit>();
        final error = s.status == LoadStatus.failure && s.error != null ? errorText(l, s.error!) : null;
        return Scaffold(
          appBar: AppBar(title: Text(l.changePhoneTitle)),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(l.changePhoneSubtitle, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 24),
              if (!s.codeSent) ...[
                PhoneField(controller: _phone, label: l.changePhoneNew, errorText: error),
                const SizedBox(height: 20),
                PrimaryButton(label: l.authSendCode, loading: s.status == LoadStatus.loading, onPressed: () => cubit.request(_phone.text)),
              ] else ...[
                Text(l.authCodeSentTo(Formatters.phone(s.phone!)), style: theme.textTheme.bodyMedium),
                const SizedBox(height: 16),
                CodeField(controller: _code, errorText: error, onCompleted: cubit.confirm),
                if (kDebugMode && s.devCode != null) Text('DEV: ${s.devCode}', textAlign: TextAlign.center, style: theme.textTheme.labelSmall),
                const SizedBox(height: 20),
                PrimaryButton(label: l.authVerify, loading: s.status == LoadStatus.loading, onPressed: () => cubit.confirm(_code.text)),
                TextButton(onPressed: cubit.changeNumber, child: Text(l.authChangeNumber)),
              ],
            ],
          ),
        );
      },
    );
  }
}
