import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/paged_cubit.dart';
import '../../domain/vehicle.dart';

class VehiclesState extends Equatable {
  const VehiclesState({this.status = LoadStatus.initial, this.items = const [], this.error});

  final LoadStatus status;
  final List<Vehicle> items;
  final Object? error;

  @override
  List<Object?> get props => [status, items, error];
}

class VehiclesCubit extends Cubit<VehiclesState> {
  VehiclesCubit(this._repo) : super(const VehiclesState());

  final VehicleRepository _repo;

  Future<void> load() async {
    emit(VehiclesState(status: LoadStatus.loading, items: state.items));
    try {
      emit(VehiclesState(status: LoadStatus.success, items: await _repo.list()));
    } catch (e) {
      emit(VehiclesState(status: LoadStatus.failure, items: state.items, error: e));
    }
  }

  /// Returns the error, if any, so the page can explain it.
  Future<Object?> delete(String id) async {
    try {
      await _repo.delete(id);
      emit(VehiclesState(status: LoadStatus.success, items: state.items.where((v) => v.id != id).toList()));
      return null;
    } catch (e) {
      return e;
    }
  }
}

class VehicleFormState extends Equatable {
  const VehicleFormState({this.status = LoadStatus.initial, this.saved, this.error});

  final LoadStatus status;
  final Vehicle? saved;
  final Object? error;

  @override
  List<Object?> get props => [status, saved, error];
}

class VehicleFormCubit extends Cubit<VehicleFormState> {
  VehicleFormCubit(this._repo) : super(const VehicleFormState());

  final VehicleRepository _repo;

  /// Saves the vehicle, then uploads [photoPath] if one was picked.
  Future<void> save(Vehicle v, {String? photoPath}) async {
    emit(const VehicleFormState(status: LoadStatus.loading));
    try {
      var saved = v.id == null ? await _repo.create(v) : await _repo.update(v);
      if (photoPath != null) saved = await _repo.uploadPhoto(saved.id!, photoPath);
      emit(VehicleFormState(status: LoadStatus.success, saved: saved));
    } catch (e) {
      emit(VehicleFormState(status: LoadStatus.failure, error: e));
    }
  }
}
