import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/authentication/presentation/bloc/auth_bloc.dart';
import '../features/locations/presentation/bloc/locations_cubit.dart';
import '../features/notifications/data/push_service.dart';
import '../features/notifications/domain/app_notification.dart';
import '../features/notifications/presentation/bloc/notifications_cubits.dart';
import '../features/notifications/presentation/notification_target.dart';
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

/// Moves between the sign-in flow and the app when the session changes, keeps the
/// notification badge polling only while a user is signed in and the app is visible,
/// and receives pushes for the signed-in user.
class _SessionNavigator extends StatefulWidget {
  const _SessionNavigator({required this.child});
  final Widget child;

  @override
  State<_SessionNavigator> createState() => _SessionNavigatorState();
}

class _SessionNavigatorState extends State<_SessionNavigator> with WidgetsBindingObserver {
  final _push = sl<PushService>();
  late final List<StreamSubscription<PushPayload>> _pushSubs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pushSubs = [_push.received.listen(_onPushReceived), _push.opened.listen(_openPush)];
  }

  @override
  void dispose() {
    for (final s in _pushSubs) {
      s.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool get _inApp => switch (context.read<AuthBloc>().state) {
        AuthAuthenticated(needsProfile: false) => true,
        _ => false,
      };

  /// PushService already showed the system banner; only the badge needs updating.
  void _onPushReceived(PushPayload p) {
    if (!mounted) return;
    context.read<UnreadCubit>().refresh();
  }

  void _openPush(PushPayload p) {
    if (!mounted || !_inApp) return;
    openNotificationTarget(sl<AppRouter>(), p.type, tripId: p.tripId, bookingId: p.bookingId);
    final id = p.notificationId;
    if (id == null) return;
    final unread = context.read<UnreadCubit>();
    sl<NotificationsRepository>().markRead(ids: [id]).then((_) => unread.refresh(), onError: (_) {});
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
            // After the shell is in place, so a push that launched the app opens on top of it.
            router.replaceAll([const MainShellRoute()]).then((_) => _push.enable());
          case AuthUnauthenticated():
            unread
              ..stop()
              ..clear();
            // A sign-out already did this; an expired session did not.
            _push.disable();
            router.replaceAll([const PhoneRoute()]);
          case AuthUnknown() || AuthRestoreFailed():
            break;
        }
      },
      child: widget.child,
    );
  }
}
