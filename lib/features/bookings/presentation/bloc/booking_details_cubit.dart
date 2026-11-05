import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/paged_cubit.dart';
import '../../domain/booking.dart';

class BookingDetailsState extends Equatable {
  const BookingDetailsState({this.status = LoadStatus.initial, this.booking, this.cancelling = false, this.cancelled = false, this.error});

  final LoadStatus status;
  final Booking? booking;
  final bool cancelling;
  final bool cancelled;
  final Object? error;

  @override
  List<Object?> get props => [status, booking, cancelling, cancelled, error];
}

class BookingDetailsCubit extends Cubit<BookingDetailsState> {
  BookingDetailsCubit(this._repo, this.bookingId) : super(const BookingDetailsState());

  final BookingsRepository _repo;
  final String bookingId;

  Future<void> load() async {
    emit(BookingDetailsState(status: LoadStatus.loading, booking: state.booking));
    try {
      emit(BookingDetailsState(status: LoadStatus.success, booking: await _repo.booking(bookingId)));
    } catch (e) {
      emit(BookingDetailsState(status: LoadStatus.failure, booking: state.booking, error: e));
    }
  }

  Future<void> cancel() async {
    emit(BookingDetailsState(status: state.status, booking: state.booking, cancelling: true));
    try {
      final b = await _repo.cancel(bookingId);
      emit(BookingDetailsState(status: LoadStatus.success, booking: b, cancelled: true));
    } catch (e) {
      emit(BookingDetailsState(status: state.status, booking: state.booking, error: e));
    }
  }
}
