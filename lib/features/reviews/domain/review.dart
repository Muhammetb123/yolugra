import 'package:equatable/equatable.dart';

import '../../../core/utils/wire.dart';
import '../../profile/domain/profile.dart';

enum ReviewerRole { passenger, driver }

class Review extends Equatable {
  const Review({
    required this.id,
    required this.bookingId,
    required this.author,
    required this.authorRole,
    required this.rating,
    required this.createdAt,
    this.comment,
  });

  final String id;
  final String bookingId;
  final UserSummary author;
  final ReviewerRole authorRole;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, bookingId, author, authorRole, rating, comment, createdAt];
}

abstract interface class ReviewsRepository {
  /// Rates the other participant of a completed booking. The backend checks eligibility.
  Future<void> submit({required String bookingId, required int rating, String comment = ''});
  Future<PageResult<Review>> forUser(String userId, {int page = 1});
}
