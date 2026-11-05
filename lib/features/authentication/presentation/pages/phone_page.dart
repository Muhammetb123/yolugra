import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/config/server_address.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_text.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../init/dependency_injection.dart';
import '../../../settings/presentation/widgets/language_switcher.dart';
import '../../../settings/presentation/widgets/server_address_dialog.dart';
import '../bloc/login_cubits.dart';
import '../widgets/auth_widgets.dart';

@RoutePage()
class PhonePage extends StatelessWidget {
  const PhonePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => PhoneCubit(sl()), child: const _PhoneView());
}

class _PhoneView extends StatefulWidget {
  const _PhoneView();

  @override
  State<_PhoneView> createState() => _PhoneViewState();
}

class _PhoneViewState extends State<_PhoneView> {
  final _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  void _submit() => context.read<PhoneCubit>().submit(_phone.text);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(actions: [
        if (ServerAddress.editable)
          IconButton(
            tooltip: l.serverTitle,
            onPressed: () => showServerAddressDialog(context),
            icon: const Icon(Icons.dns_outlined),
          ),
        const LanguageSwitcher(),
        const SizedBox(width: 8),
      ]),
      body: BlocConsumer<PhoneCubit, PhoneState>(
        listener: (context, state) {
          if (state.status == LoadStatus.success && state.phone != null) {
            context.router.push(OtpRoute(phone: state.phone!, devCode: state.devCode));
            context.read<PhoneCubit>().reset();
          }
        },
        builder: (context, state) {
          final error = state.status == LoadStatus.failure ? state.error : null;
          final fieldError = error is AppException && error.code == 'INVALID_PHONE' ? l.validationPhone : null;
          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              children: [
                const Align(alignment: AlignmentDirectional.centerStart, child: AppLogo()),
                const SizedBox(height: 28),
                Text(l.authWelcomeTitle, style: theme.textTheme.headlineMedium),
                const SizedBox(height: 12),
                Text(l.authWelcomeSubtitle, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 32),
                PhoneField(controller: _phone, errorText: fieldError, onSubmitted: (_) => _submit()),
                if (error != null && fieldError == null) ...[
                  const SizedBox(height: 12),
                  Text(errorText(l, error), style: TextStyle(color: theme.colorScheme.error)),
                ],
                const SizedBox(height: 20),
                PrimaryButton(label: l.authSendCode, loading: state.status == LoadStatus.loading, onPressed: _submit),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lock_outline_rounded, size: 18, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(child: Text(l.authSmsNote, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
