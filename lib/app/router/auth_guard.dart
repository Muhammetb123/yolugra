import 'package:auto_route/auto_route.dart';

import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import 'app_router.dart';

/// Protected routes need a signed-in user with a complete profile.
class AuthGuard extends AutoRouteGuard {
  AuthGuard(this._auth);

  final AuthBloc _auth;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    switch (_auth.state) {
      case AuthAuthenticated(needsProfile: false):
        resolver.next();
      case AuthAuthenticated():
        resolver.redirectUntil(const CompleteProfileRoute(), replace: true);
      case AuthUnknown() || AuthRestoreFailed():
        resolver.redirectUntil(const SplashRoute(), replace: true);
      case AuthUnauthenticated():
        resolver.redirectUntil(const PhoneRoute(), replace: true);
    }
  }
}
