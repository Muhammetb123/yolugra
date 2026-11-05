import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../profile/domain/profile.dart';
import '../../domain/auth_repository.dart';

class PhoneState extends Equatable {
  const PhoneState({this.status = LoadStatus.initial, this.phone, this.devCode, this.error});

  final LoadStatus status;
  final String? phone;
  final String? devCode;
  final Object? error;

  @override
  List<Object?> get props => [status, phone, devCode, error];
}

/// Step 1: the phone number. The backend generates the code and queues the SMS.
class PhoneCubit extends Cubit<PhoneState> {
  PhoneCubit(this._repo) : super(const PhoneState());

  final AuthRepository _repo;

  Future<void> submit(String raw) async {
    final phone = normalizePhone(raw);
    if (phone == null) {
      emit(const PhoneState(status: LoadStatus.failure, error: AppException('INVALID_PHONE')));
      return;
    }
    emit(const PhoneState(status: LoadStatus.loading));
    try {
      final dev = await _repo.requestCode(phone);
      emit(PhoneState(status: LoadStatus.success, phone: phone, devCode: dev));
    } catch (e) {
      emit(PhoneState(status: LoadStatus.failure, error: e));
    }
  }

  void reset() => emit(const PhoneState());
}

class OtpState extends Equatable {
  const OtpState({
    this.status = LoadStatus.initial,
    this.resendIn = 60,
    this.resending = false,
    this.resent = false,
    this.devCode,
    this.profile,
    this.error,
  });

  final LoadStatus status;
  final int resendIn;
  final bool resending;
  final bool resent;
  final String? devCode;
  final Profile? profile;
  final Object? error;

  OtpState copyWith({LoadStatus? status, int? resendIn, bool? resending, bool? resent, String? devCode, Profile? profile, Object? error}) =>
      OtpState(
        status: status ?? this.status,
        resendIn: resendIn ?? this.resendIn,
        resending: resending ?? this.resending,
        resent: resent ?? this.resent,
        devCode: devCode ?? this.devCode,
        profile: profile ?? this.profile,
        error: error,
      );

  @override
  List<Object?> get props => [status, resendIn, resending, resent, devCode, profile, error];
}

/// Step 2: the code. Resend follows the backend's one-SMS-per-minute limit.
class OtpCubit extends Cubit<OtpState> {
  OtpCubit(this._repo, this.phone, {String? devCode, Duration resendDelay = const Duration(seconds: 60)})
      : _delay = resendDelay,
        super(OtpState(devCode: devCode, resendIn: resendDelay.inSeconds)) {
    _startTimer(resendDelay);
  }

  final AuthRepository _repo;
  final String phone;
  final Duration _delay;
  Timer? _timer;

  void _startTimer(Duration d) {
    _timer?.cancel();
    emit(state.copyWith(resendIn: d.inSeconds));
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final left = state.resendIn - 1;
      emit(state.copyWith(resendIn: left < 0 ? 0 : left, error: state.error));
      if (left <= 0) t.cancel();
    });
  }

  Future<void> verify(String code) async {
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      emit(state.copyWith(status: LoadStatus.failure, error: const AppException('INVALID_CODE')));
      return;
    }
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      final profile = await _repo.verifyCode(phone, code);
      _timer?.cancel();
      emit(state.copyWith(status: LoadStatus.success, profile: profile));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure, error: e));
    }
  }

  Future<void> resend() async {
    if (state.resendIn > 0 || state.resending) return;
    emit(state.copyWith(resending: true, resent: false));
    try {
      final dev = await _repo.requestCode(phone);
      emit(state.copyWith(resending: false, resent: true, devCode: dev));
      _startTimer(_delay);
    } on AppException catch (e) {
      emit(state.copyWith(resending: false, status: LoadStatus.failure, error: e));
      if (e.retryAfter != null) _startTimer(e.retryAfter!);
    } catch (e) {
      emit(state.copyWith(resending: false, status: LoadStatus.failure, error: e));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
