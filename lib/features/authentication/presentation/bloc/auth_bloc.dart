import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../profile/domain/profile.dart';
import '../../domain/auth_repository.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// App start: restore a stored session.
final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthSignedIn extends AuthEvent {
  const AuthSignedIn(this.profile);
  final Profile profile;
  @override
  List<Object?> get props => [profile];
}

/// The signed-in profile changed (name, photo, phone).
final class AuthProfileChanged extends AuthEvent {
  const AuthProfileChanged(this.profile);
  final Profile profile;
  @override
  List<Object?> get props => [profile];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

final class _AuthSessionExpired extends AuthEvent {
  const _AuthSessionExpired();
}

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

final class AuthUnknown extends AuthState {
  const AuthUnknown();
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.expired = false});
  final bool expired;
  @override
  List<Object?> get props => [expired];
}

/// Signed in. [needsProfile] is true until first and last name are set.
final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.profile);
  final Profile profile;
  bool get needsProfile => !profile.profileComplete;
  @override
  List<Object?> get props => [profile];
}

/// The stored session could not be checked (for example, offline at start).
final class AuthRestoreFailed extends AuthState {
  const AuthRestoreFailed(this.error);
  final Object error;
  @override
  List<Object?> get props => [error];
}

/// The app-wide session state. Screens read the signed-in profile from here.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repo) : super(const AuthUnknown()) {
    on<AuthStarted>(_onStarted);
    on<AuthSignedIn>((e, emit) => emit(AuthAuthenticated(e.profile)));
    on<AuthProfileChanged>((e, emit) {
      if (state is AuthAuthenticated) emit(AuthAuthenticated(e.profile));
    });
    on<AuthLogoutRequested>(_onLogout);
    on<_AuthSessionExpired>((_, emit) {
      if (state is AuthAuthenticated) emit(const AuthUnauthenticated(expired: true));
    });
    _expired = _repo.sessionExpired.listen((_) => add(const _AuthSessionExpired()));
  }

  final AuthRepository _repo;
  late final StreamSubscription<void> _expired;

  Profile? get profile => switch (state) {
        AuthAuthenticated(:final profile) => profile,
        _ => null,
      };

  Future<void> _onStarted(AuthStarted e, Emitter<AuthState> emit) async {
    emit(const AuthUnknown());
    try {
      final profile = await _repo.restore();
      emit(profile == null ? const AuthUnauthenticated() : AuthAuthenticated(profile));
    } catch (err) {
      emit(AuthRestoreFailed(err));
    }
  }

  Future<void> _onLogout(AuthLogoutRequested e, Emitter<AuthState> emit) async {
    await _repo.logout();
    emit(const AuthUnauthenticated());
  }

  @override
  Future<void> close() {
    _expired.cancel();
    return super.close();
  }
}
