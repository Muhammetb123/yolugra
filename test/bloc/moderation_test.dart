import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yolugra/core/bloc/paged_cubit.dart';
import 'package:yolugra/core/errors/app_exception.dart';
import 'package:yolugra/features/authentication/domain/auth_repository.dart';
import 'package:yolugra/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:yolugra/features/moderation/data/moderation_repository_impl.dart';
import 'package:yolugra/features/moderation/domain/moderation.dart';
import 'package:yolugra/features/moderation/presentation/bloc/moderation_cubits.dart';
import 'package:yolugra/features/profile/data/profile_repository_impl.dart';
import 'package:yolugra/features/profile/domain/profile.dart';
import 'package:yolugra/features/profile/presentation/bloc/profile_cubits.dart';

class MockModeration extends Mock implements ModerationRepository {}

class MockAuth extends Mock implements AuthRepository {}

const ayna = UserSummary(id: 'u-a', firstName: 'Aýna', lastName: 'Orazowa');
const batyr = UserSummary(id: 'u-b', firstName: 'Batyr', lastName: 'Nazarow');

void main() {
  setUpAll(() => registerFallbackValue(ReportReason.spam));

  group('UserBlockCubit', () {
    late MockModeration repo;
    setUp(() => repo = MockModeration());

    test('knows whether the user is on the block list', () async {
      when(() => repo.blocked()).thenAnswer((_) async => [ayna]);
      final c = UserBlockCubit(repo, 'u-a');
      await c.load();
      expect(c.state.blocked, isTrue);
      final other = UserBlockCubit(repo, 'u-b');
      await other.load();
      expect(other.state.blocked, isFalse);
    });

    blocTest<UserBlockCubit, UserBlockState>('blocking shows progress, then the new state',
        build: () {
          when(() => repo.block('u-a')).thenAnswer((_) async {});
          return UserBlockCubit(repo, 'u-a');
        },
        act: (c) => c.setBlocked(true),
        expect: () => [const UserBlockState(busy: true), const UserBlockState(blocked: true)]);

    test('a failed block keeps the old state and returns the error', () async {
      when(() => repo.block('u-a')).thenThrow(const AppException(AppException.network));
      final c = UserBlockCubit(repo, 'u-a');
      final err = await c.setBlocked(true);
      expect((err as AppException).code, AppException.network);
      expect(c.state, const UserBlockState());
    });
  });

  group('BlockedUsersCubit', () {
    test('unblocking removes the user from the list', () async {
      final repo = MockModeration();
      when(() => repo.blocked()).thenAnswer((_) async => [ayna, batyr]);
      when(() => repo.unblock('u-a')).thenAnswer((_) async {});
      final c = BlockedUsersCubit(repo);
      await c.load();
      expect(await c.unblock('u-a'), isNull);
      expect(c.state.items, [batyr]);
      expect(c.state.busyId, isNull);
    });

    test('a failed unblock keeps the user', () async {
      final repo = MockModeration();
      when(() => repo.blocked()).thenAnswer((_) async => [ayna]);
      when(() => repo.unblock('u-a')).thenThrow(const AppException('INTERNAL'));
      final c = BlockedUsersCubit(repo);
      await c.load();
      expect(await c.unblock('u-a'), isNotNull);
      expect(c.state.items, [ayna]);
    });
  });

  group('ReportCubit', () {
    late MockModeration repo;
    setUp(() {
      repo = MockModeration();
      when(() => repo.report(
            userId: any(named: 'userId'),
            reason: any(named: 'reason'),
            tripId: any(named: 'tripId'),
            details: any(named: 'details'),
          )).thenAnswer((_) async {});
    });

    test('needs a reason, and a description for "something else"', () {
      final c = ReportCubit(repo, 'u-a');
      expect(c.state.canSubmit, isFalse);
      c.setReason(ReportReason.noShow);
      expect(c.state.canSubmit, isTrue);
      c.setReason(ReportReason.other);
      expect(c.state.canSubmit, isFalse);
      c.setDetails('   ');
      expect(c.state.canSubmit, isFalse);
      c.setDetails('Asked for money before the trip');
      expect(c.state.canSubmit, isTrue);
    });

    test('an incomplete form never reaches the backend', () async {
      final c = ReportCubit(repo, 'u-a')..setReason(ReportReason.other);
      await c.submit();
      verifyNever(() => repo.report(userId: any(named: 'userId'), reason: any(named: 'reason'), tripId: any(named: 'tripId'), details: any(named: 'details')));
    });

    test('sends the trip it was opened from and trimmed details', () async {
      final c = ReportCubit(repo, 'u-a', tripId: 't-1')
        ..setReason(ReportReason.fraud)
        ..setDetails('  prepayment  ');
      await c.submit();
      expect(c.state.status, LoadStatus.success);
      verify(() => repo.report(userId: 'u-a', reason: ReportReason.fraud, tripId: 't-1', details: 'prepayment')).called(1);
    });
  });

  group('account deletion', () {
    test('DeleteAccountCubit reports TRIP_IN_PROGRESS and can retry', () async {
      final auth = MockAuth();
      when(() => auth.deleteAccount()).thenThrow(const AppException('TRIP_IN_PROGRESS'));
      final c = DeleteAccountCubit(auth);
      await c.submit();
      expect((c.state.error as AppException).code, 'TRIP_IN_PROGRESS');
      when(() => auth.deleteAccount()).thenAnswer((_) async {});
      await c.submit();
      expect(c.state.status, LoadStatus.success);
      await c.submit();
      verify(() => auth.deleteAccount()).called(2);
    });

    blocTest<AuthBloc, AuthState>('a deleted account signs out without a logout call',
        build: () {
          final auth = MockAuth();
          when(() => auth.sessionExpired).thenAnswer((_) => const Stream.empty());
          return AuthBloc(auth);
        },
        seed: () => AuthAuthenticated(Profile(id: 'u-1', firstName: 'A', lastName: 'B', memberSince: DateTime(2026), profileComplete: true)),
        act: (b) => b.add(const AuthAccountDeleted()),
        expect: () => [const AuthUnauthenticated()]);
  });

  group('wire format', () {
    test('reports use the backend reason names and drop empty fields', () {
      expect(reportToJson(userId: 'u-a', reason: ReportReason.inappropriateContent), {
        'reported_user_id': 'u-a',
        'reason': 'inappropriate_content',
      });
      expect(reportToJson(userId: 'u-a', reason: ReportReason.noShow, tripId: 't-1', details: ' late '), {
        'reported_user_id': 'u-a',
        'reason': 'no_show',
        'trip_id': 't-1',
        'details': 'late',
      });
    });

    test('a deleted user in a trip or booking is marked', () {
      final u = userSummaryFromJson({'id': 'u-x', 'first_name': '', 'last_name': '', 'deleted': true});
      expect(u.deleted, isTrue);
      expect(userSummaryFromJson({'id': 'u-y', 'first_name': 'A', 'last_name': 'B'}).deleted, isFalse);
    });
  });
}
