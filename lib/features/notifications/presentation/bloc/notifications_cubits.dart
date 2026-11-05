import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/utils/wire.dart';
import '../../domain/app_notification.dart';

/// The unread badge. It polls while the app is in the foreground; the delivery
/// channel (in-app inbox today, push later) stays behind [NotificationsRepository].
class UnreadCubit extends Cubit<int> {
  UnreadCubit(this._repo, {required this.interval}) : super(0);

  final NotificationsRepository _repo;
  final Duration interval;
  Timer? _timer;

  void start() {
    _timer?.cancel();
    unawaited(refresh());
    _timer = Timer.periodic(interval, (_) => refresh());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> refresh() async {
    try {
      final n = await _repo.unreadCount();
      if (!isClosed) emit(n);
    } catch (_) {
      // The badge is best-effort; the inbox screen shows real errors.
    }
  }

  void clear() => emit(0);

  @override
  Future<void> close() {
    stop();
    return super.close();
  }
}

/// The inbox list. Pages backwards in time by the oldest loaded notification.
class NotificationsCubit extends PagedCubit<AppNotification> {
  NotificationsCubit(this._repo) : super(_noop);

  final NotificationsRepository _repo;

  static Future<PageResult<AppNotification>> _noop(int _) async => const PageResult([], false);

  @override
  Future<void> refresh() async {
    emit(state.copyWith(status: state.items.isEmpty ? LoadStatus.loading : state.status));
    try {
      final page = await _repo.list();
      emit(PagedState(status: LoadStatus.success, items: page.items, hasMore: page.hasMore, page: 1));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e));
    }
  }

  @override
  Future<void> loadMore() async {
    if (!state.hasMore || state.loadingMore || state.items.isEmpty) return;
    emit(state.copyWith(loadingMore: true));
    try {
      final next = await _repo.list(before: state.items.last.createdAt);
      emit(state.copyWith(items: [...state.items, ...next.items], hasMore: next.hasMore, loadingMore: false));
    } catch (e) {
      emit(state.copyWith(loadingMore: false, error: e));
    }
  }

  Future<void> markAllRead() async {
    await _repo.markRead();
    emit(state.copyWith(items: state.items.map((n) => n.markRead()).toList()));
  }

  Future<void> markRead(AppNotification n) async {
    if (n.read) return;
    emit(state.copyWith(items: state.items.map((x) => x.id == n.id ? x.markRead() : x).toList()));
    try {
      await _repo.markRead(ids: [n.id]);
    } catch (_) {
      // Read state is cosmetic; the next refresh shows the server state.
    }
  }
}
