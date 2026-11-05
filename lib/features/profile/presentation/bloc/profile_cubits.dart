import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../authentication/domain/auth_repository.dart';
import '../../../reviews/domain/review.dart';
import '../../domain/profile.dart';

class ProfileFormState extends Equatable {
  const ProfileFormState({this.status = LoadStatus.initial, this.photoBusy = false, this.profile, this.error});

  final LoadStatus status;
  final bool photoBusy;
  final Profile? profile;
  final Object? error;

  @override
  List<Object?> get props => [status, photoBusy, profile, error];
}

/// Saves the name, bio and photo. Used by profile completion and profile editing.
class ProfileFormCubit extends Cubit<ProfileFormState> {
  ProfileFormCubit(this._repo) : super(const ProfileFormState());

  final ProfileRepository _repo;

  Future<void> save({required String firstName, required String lastName, String? bio}) async {
    emit(const ProfileFormState(status: LoadStatus.loading));
    try {
      final p = await _repo.update(firstName: firstName.trim(), lastName: lastName.trim(), bio: bio?.trim());
      emit(ProfileFormState(status: LoadStatus.success, profile: p));
    } catch (e) {
      emit(ProfileFormState(status: LoadStatus.failure, error: e));
    }
  }

  Future<Profile?> setPhoto(String path) => _photo(() => _repo.uploadPhoto(path));

  Future<Profile?> removePhoto() => _photo(_repo.removePhoto);

  Future<Profile?> _photo(Future<Profile> Function() call) async {
    emit(ProfileFormState(status: state.status, photoBusy: true));
    try {
      final p = await call();
      emit(ProfileFormState(status: state.status, profile: p));
      return p;
    } catch (e) {
      emit(ProfileFormState(status: state.status, error: e));
      return null;
    }
  }
}

class ChangePhoneState extends Equatable {
  const ChangePhoneState({this.status = LoadStatus.initial, this.phone, this.codeSent = false, this.devCode, this.profile, this.error});

  final LoadStatus status;
  final String? phone;
  final bool codeSent;
  final String? devCode;
  final Profile? profile;
  final Object? error;

  @override
  List<Object?> get props => [status, phone, codeSent, devCode, profile, error];
}

/// Changing the number reuses the OTP system: a code is sent to the new number.
class ChangePhoneCubit extends Cubit<ChangePhoneState> {
  ChangePhoneCubit(this._repo) : super(const ChangePhoneState());

  final ProfileRepository _repo;

  Future<void> request(String raw) async {
    final phone = normalizePhone(raw);
    if (phone == null) {
      emit(const ChangePhoneState(status: LoadStatus.failure, error: AppException('INVALID_PHONE')));
      return;
    }
    emit(const ChangePhoneState(status: LoadStatus.loading));
    try {
      final dev = await _repo.requestPhoneChange(phone);
      emit(ChangePhoneState(phone: phone, codeSent: true, devCode: dev));
    } catch (e) {
      emit(ChangePhoneState(status: LoadStatus.failure, error: e));
    }
  }

  Future<void> confirm(String code) async {
    final phone = state.phone;
    if (phone == null) return;
    emit(ChangePhoneState(status: LoadStatus.loading, phone: phone, codeSent: true, devCode: state.devCode));
    try {
      final p = await _repo.confirmPhoneChange(phone, code.trim());
      emit(ChangePhoneState(status: LoadStatus.success, phone: phone, codeSent: true, profile: p));
    } catch (e) {
      emit(ChangePhoneState(status: LoadStatus.failure, phone: phone, codeSent: true, devCode: state.devCode, error: e));
    }
  }

  void changeNumber() => emit(const ChangePhoneState());
}

class PublicProfileState extends Equatable {
  const PublicProfileState({this.status = LoadStatus.initial, this.profile, this.error});

  final LoadStatus status;
  final Profile? profile;
  final Object? error;

  @override
  List<Object?> get props => [status, profile, error];
}

/// Another user's public profile. Reviews load through a [PagedCubit].
class PublicProfileCubit extends Cubit<PublicProfileState> {
  PublicProfileCubit(this._repo, this.userId) : super(const PublicProfileState());

  final ProfileRepository _repo;
  final String userId;

  Future<void> load() async {
    emit(const PublicProfileState(status: LoadStatus.loading));
    try {
      emit(PublicProfileState(status: LoadStatus.success, profile: await _repo.user(userId)));
    } catch (e) {
      emit(PublicProfileState(status: LoadStatus.failure, error: e));
    }
  }
}

PagedCubit<Review> reviewsCubit(ReviewsRepository repo, String userId) => PagedCubit((page) => repo.forUser(userId, page: page));
