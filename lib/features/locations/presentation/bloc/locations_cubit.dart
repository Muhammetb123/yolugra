import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/paged_cubit.dart';
import '../../domain/location.dart';

class LocationsState extends Equatable {
  const LocationsState({this.status = LoadStatus.initial, this.all = const [], this.error});

  final LoadStatus status;
  final List<Location> all;
  final Object? error;

  /// Welayats with their cities, then cities without a welayat (Ashgabat).
  List<Location> get welayats => all.where((l) => l.type == LocationType.welayat).toList();
  List<Location> childrenOf(String id) => all.where((l) => l.parentId == id).toList();
  List<Location> get topLevelCities => all.where((l) => l.type != LocationType.welayat && l.parentId == null).toList();

  @override
  List<Object?> get props => [status, all, error];
}

class LocationsCubit extends Cubit<LocationsState> {
  LocationsCubit(this._repo) : super(const LocationsState());

  final LocationsRepository _repo;

  Future<void> load({bool refresh = false}) async {
    if (state.status == LoadStatus.success && !refresh) return;
    emit(LocationsState(status: LoadStatus.loading, all: state.all));
    try {
      emit(LocationsState(status: LoadStatus.success, all: await _repo.all(refresh: refresh)));
    } catch (e) {
      emit(LocationsState(status: LoadStatus.failure, all: state.all, error: e));
    }
  }
}
