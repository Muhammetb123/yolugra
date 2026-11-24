import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/paged_cubit.dart';
import '../../../profile/domain/profile.dart';
import '../../domain/moderation.dart';

class UserBlockState extends Equatable {
  const UserBlockState({this.blocked = false, this.busy = false});

  final bool blocked;
  final bool busy;

  @override
  List<Object?> get props => [blocked, busy];
}

/// Whether the signed-in user blocked one other user, and the switch for it.
class UserBlockCubit extends Cubit<UserBlockState> {
  UserBlockCubit(this._repo, this.userId) : super(const UserBlockState());

  final ModerationRepository _repo;
  final String userId;

  /// A failed load leaves "not blocked": blocking a blocked user again changes nothing.
  Future<void> load() async {
    try {
      final blocked = await _repo.blocked();
      if (!isClosed) emit(UserBlockState(blocked: blocked.any((u) => u.id == userId)));
    } catch (_) {}
  }

  /// Returns the error, if any, so the page can explain it.
  Future<Object?> setBlocked(bool blocked) async {
    emit(UserBlockState(blocked: state.blocked, busy: true));
    try {
      await (blocked ? _repo.block(userId) : _repo.unblock(userId));
      if (!isClosed) emit(UserBlockState(blocked: blocked));
      return null;
    } catch (e) {
      if (!isClosed) emit(UserBlockState(blocked: state.blocked));
      return e;
    }
  }
}

class BlockedUsersState extends Equatable {
  const BlockedUsersState({this.status = LoadStatus.initial, this.items = const [], this.busyId, this.error});

  final LoadStatus status;
  final List<UserSummary> items;

  /// The user an unblock is running for.
  final String? busyId;
  final Object? error;

  @override
  List<Object?> get props => [status, items, busyId, error];
}

/// The list of users the signed-in user blocked.
class BlockedUsersCubit extends Cubit<BlockedUsersState> {
  BlockedUsersCubit(this._repo) : super(const BlockedUsersState());

  final ModerationRepository _repo;

  Future<void> load() async {
    emit(BlockedUsersState(status: LoadStatus.loading, items: state.items));
    try {
      final items = await _repo.blocked();
      if (!isClosed) emit(BlockedUsersState(status: LoadStatus.success, items: items));
    } catch (e) {
      if (!isClosed) emit(BlockedUsersState(status: LoadStatus.failure, items: state.items, error: e));
    }
  }

  /// Returns the error, if any, so the page can explain it.
  Future<Object?> unblock(String userId) async {
    emit(BlockedUsersState(status: state.status, items: state.items, busyId: userId));
    try {
      await _repo.unblock(userId);
      if (!isClosed) emit(BlockedUsersState(status: LoadStatus.success, items: state.items.where((u) => u.id != userId).toList()));
      return null;
    } catch (e) {
      if (!isClosed) emit(BlockedUsersState(status: state.status, items: state.items));
      return e;
    }
  }
}

class ReportState extends Equatable {
  const ReportState({this.reason, this.details = '', this.status = LoadStatus.initial, this.error});

  final ReportReason? reason;
  final String details;
  final LoadStatus status;
  final Object? error;

  /// "Something else" says nothing by itself, so it needs a description.
  bool get detailsRequired => reason == ReportReason.other;

  bool get canSubmit => reason != null && (!detailsRequired || details.trim().isNotEmpty);

  @override
  List<Object?> get props => [reason, details, status, error];
}

/// The report form about one user, optionally tied to the trip it was opened from.
class ReportCubit extends Cubit<ReportState> {
  ReportCubit(this._repo, this.userId, {this.tripId}) : super(const ReportState());

  final ModerationRepository _repo;
  final String userId;
  final String? tripId;

  void setReason(ReportReason reason) => emit(ReportState(reason: reason, details: state.details));

  void setDetails(String details) => emit(ReportState(reason: state.reason, details: details));

  Future<void> submit() async {
    final reason = state.reason;
    if (reason == null || !state.canSubmit || state.status == LoadStatus.loading) return;
    emit(ReportState(reason: reason, details: state.details, status: LoadStatus.loading));
    try {
      await _repo.report(userId: userId, reason: reason, tripId: tripId, details: state.details.trim());
      if (!isClosed) emit(ReportState(reason: reason, details: state.details, status: LoadStatus.success));
    } catch (e) {
      if (!isClosed) emit(ReportState(reason: reason, details: state.details, status: LoadStatus.failure, error: e));
    }
  }
}
