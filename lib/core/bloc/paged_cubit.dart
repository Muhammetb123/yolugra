import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/wire.dart';

enum LoadStatus { initial, loading, success, failure }

class PagedState<T> extends Equatable {
  const PagedState({
    this.status = LoadStatus.initial,
    this.items = const [],
    this.hasMore = false,
    this.page = 0,
    this.loadingMore = false,
    this.error,
  });

  final LoadStatus status;
  final List<T> items;
  final bool hasMore;
  final int page;
  final bool loadingMore;
  final Object? error;

  bool get isEmpty => status == LoadStatus.success && items.isEmpty;

  PagedState<T> copyWith({LoadStatus? status, List<T>? items, bool? hasMore, int? page, bool? loadingMore, Object? error}) =>
      PagedState(
        status: status ?? this.status,
        items: items ?? this.items,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page,
        loadingMore: loadingMore ?? this.loadingMore,
        error: error,
      );

  @override
  List<Object?> get props => [status, items, hasMore, page, loadingMore, error];
}

/// Loads a paginated list with explicit loading, empty, error and "load more" states.
class PagedCubit<T> extends Cubit<PagedState<T>> {
  PagedCubit(this._load) : super(PagedState<T>());

  final Future<PageResult<T>> Function(int page) _load;

  Future<void> refresh() async {
    emit(state.copyWith(status: state.items.isEmpty ? LoadStatus.loading : state.status));
    try {
      final page = await _load(1);
      emit(PagedState(status: LoadStatus.success, items: page.items, hasMore: page.hasMore, page: 1));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.loadingMore) return;
    emit(state.copyWith(loadingMore: true));
    try {
      final next = await _load(state.page + 1);
      emit(state.copyWith(items: [...state.items, ...next.items], hasMore: next.hasMore, page: state.page + 1, loadingMore: false));
    } catch (e) {
      emit(state.copyWith(loadingMore: false, error: e));
    }
  }
}
