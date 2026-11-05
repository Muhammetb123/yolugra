import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/authentication/presentation/bloc/auth_bloc.dart';
import '../features/locations/presentation/bloc/locations_cubit.dart';
import '../features/notifications/presentation/bloc/notifications_cubits.dart';
import '../features/settings/presentation/bloc/settings_cubit.dart';
import '../init/dependency_injection.dart';
import 'localization/l10n.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class YolugraApp extends StatelessWidget {
  const YolugraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<AuthBloc>()),
        BlocProvider.value(value: sl<SettingsCubit>()),
        BlocProvider.value(value: sl<LocationsCubit>()),
        BlocProvider.value(value: sl<UnreadCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, Locale>(
        builder: (context, locale) => MaterialApp.router(
          onGenerateTitle: (c) => c.l10n.appName,
          debugShowCheckedModeBanner: false,
          locale: locale,
          supportedLocales: supportedLocales,
          localizationsDelegates: localizationsDelegates,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          routerConfig: sl<AppRouter>().config(),
          builder: (context, child) => _SessionNavigator(child: child ?? const SizedBox()),
        ),
      ),
    );
  }
}

/// Moves between the sign-in flow and the app when the session changes, and keeps the
/// notification badge polling only while a user is signed in and the app is visible.
class _SessionNavigator extends StatefulWidget {
  const _SessionNavigator({required this.child});
  final Widget child;

  @override
  State<_SessionNavigator> createState() => _SessionNavigatorState();
}

class _SessionNavigatorState extends State<_SessionNavigator> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final signedIn = context.read<AuthBloc>().state is AuthAuthenticated;
    if (state == AppLifecycleState.resumed && signedIn) {
      context.read<UnreadCubit>().start();
    } else if (state == AppLifecycleState.paused) {
      context.read<UnreadCubit>().stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (a, b) => a.runtimeType != b.runtimeType || (a is AuthAuthenticated && b is AuthAuthenticated && a.needsProfile != b.needsProfile),
      listener: (context, state) {
        final router = sl<AppRouter>();
        final unread = context.read<UnreadCubit>();
        switch (state) {
          case AuthAuthenticated(needsProfile: true):
            router.replaceAll([const CompleteProfileRoute()]);
          case AuthAuthenticated():
            unread.start();
            router.replaceAll([const MainShellRoute()]);
          case AuthUnauthenticated():
            unread
              ..stop()
              ..clear();
            router.replaceAll([const PhoneRoute()]);
          case AuthUnknown() || AuthRestoreFailed():
            break;
        }
      },
      child: widget.child,
    );
  }
}
