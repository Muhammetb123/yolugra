import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/paged_cubit.dart';
import '../../domain/review.dart';

class ReviewState extends Equatable {
  const ReviewState({this.rating = 0, this.comment = '', this.status = LoadStatus.initial, this.error});

  final int rating;
  final String comment;
  final LoadStatus status;
  final Object? error;

  @override
  List<Object?> get props => [rating, comment, status, error];
}

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit(this._repo, this.bookingId) : super(const ReviewState());

  final ReviewsRepository _repo;
  final String bookingId;

  void setRating(int r) => emit(ReviewState(rating: r, comment: state.comment));
  void setComment(String c) => emit(ReviewState(rating: state.rating, comment: c));

  Future<void> submit() async {
    if (state.rating < 1) return;
    emit(ReviewState(rating: state.rating, comment: state.comment, status: LoadStatus.loading));
    try {
      await _repo.submit(bookingId: bookingId, rating: state.rating, comment: state.comment.trim());
      emit(ReviewState(rating: state.rating, comment: state.comment, status: LoadStatus.success));
    } catch (e) {
      emit(ReviewState(rating: state.rating, comment: state.comment, status: LoadStatus.failure, error: e));
    }
  }
}
