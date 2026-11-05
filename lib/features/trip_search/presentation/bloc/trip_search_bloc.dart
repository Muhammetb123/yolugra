import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/bloc/paged_cubit.dart';
import '../../../trips/domain/trip.dart';

sealed class TripSearchEvent extends Equatable {
  const TripSearchEvent();
  @override
  List<Object?> get props => [];
}

/// Runs a new search, replacing the results.
final class TripSearchRequested extends TripSearchEvent {
  const TripSearchRequested(this.query);
  final SearchQuery query;
  @override
  List<Object?> get props => [query];
}

final class TripSearchNextPage extends TripSearchEvent {
  const TripSearchNextPage();
}

final class TripSearchRefreshed extends TripSearchEvent {
  const TripSearchRefreshed();
}

class TripSearchState extends Equatable {
  const TripSearchState({
    required this.query,
    this.status = LoadStatus.initial,
    this.trips = const [],
    this.hasMore = false,
    this.page = 0,
    this.loadingMore = false,
    this.error,
  });

  final SearchQuery query;
  final LoadStatus status;
  final List<Trip> trips;
  final bool hasMore;
  final int page;
  final bool loadingMore;
  final Object? error;

  bool get isEmpty => status == LoadStatus.success && trips.isEmpty;

  @override
  List<Object?> get props => [query, status, trips, hasMore, page, loadingMore, error];
}

class TripSearchBloc extends Bloc<TripSearchEvent, TripSearchState> {
  TripSearchBloc(this._repo, SearchQuery initial) : super(TripSearchState(query: initial)) {
    on<TripSearchRequested>(_onRequested);
    on<TripSearchRefreshed>((_, emit) => _onRequested(TripSearchRequested(state.query), emit));
    on<TripSearchNextPage>(_onNextPage);
  }

  final TripsRepository _repo;

  /// A newer search wins: results of an older one still in flight are dropped.
  int _seq = 0;

  Future<void> _onRequested(TripSearchRequested e, Emitter<TripSearchState> emit) async {
    final seq = ++_seq;
    emit(TripSearchState(query: e.query, status: LoadStatus.loading));
    try {
      final page = await _repo.search(e.query);
      if (seq != _seq) return;
      emit(TripSearchState(query: e.query, status: LoadStatus.success, trips: page.items, hasMore: page.hasMore, page: 1));
    } catch (err) {
      if (seq != _seq) return;
      emit(TripSearchState(query: e.query, status: LoadStatus.failure, error: err));
    }
  }

  Future<void> _onNextPage(TripSearchNextPage e, Emitter<TripSearchState> emit) async {
    if (!state.hasMore || state.loadingMore) return;
    final s = state;
    final seq = _seq;
    emit(TripSearchState(query: s.query, status: s.status, trips: s.trips, hasMore: s.hasMore, page: s.page, loadingMore: true));
    try {
      final next = await _repo.search(s.query, page: s.page + 1);
      if (seq != _seq) return;
      emit(TripSearchState(query: s.query, status: LoadStatus.success, trips: [...s.trips, ...next.items], hasMore: next.hasMore, page: s.page + 1));
    } catch (err) {
      emit(TripSearchState(query: s.query, status: s.status, trips: s.trips, hasMore: s.hasMore, page: s.page, error: err));
    }
  }
}
