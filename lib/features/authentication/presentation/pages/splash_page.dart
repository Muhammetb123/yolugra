import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/errors/error_text.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_widgets.dart';

/// Shown while the stored session is checked. Navigation away is driven by AuthBloc.
@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // When the session was resolved before this page appeared, route from here.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final router = context.router;
      switch (context.read<AuthBloc>().state) {
        case AuthAuthenticated(needsProfile: true):
          router.replaceAll([const CompleteProfileRoute()]);
        case AuthAuthenticated():
          router.replaceAll([const MainShellRoute()]);
        case AuthUnauthenticated():
          router.replaceAll([const PhoneRoute()]);
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLogo(size: 88),
              const SizedBox(height: 20),
              Text(l.appName, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(l.appTagline, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 32),
              if (state is AuthRestoreFailed) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(errorText(l, state.error), textAlign: TextAlign.center),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => context.read<AuthBloc>().add(const AuthStarted()),
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l.commonRetry),
                ),
              ] else
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
