import '../../../core/network/api_client.dart';
import '../../../core/utils/wire.dart';
import '../../profile/data/profile_repository_impl.dart';
import '../domain/review.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  ReviewsRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<void> submit({required String bookingId, required int rating, String comment = ''}) =>
      _api.post('/v1/bookings/$bookingId/review', body: {'rating': rating, 'comment': comment});

  @override
  Future<PageResult<Review>> forUser(String userId, {int page = 1}) async {
    final res = await _api.get('/v1/users/$userId/reviews', query: {'page': page});
    final items = (res['items'] as List).cast<Map<String, dynamic>>().map((j) => Review(
          id: j['id'] as String,
          bookingId: j['booking_id'] as String,
          author: userSummaryFromJson(j['author'] as Map<String, dynamic>),
          authorRole: fromWire(ReviewerRole.values, j['author_role'], ReviewerRole.passenger),
          rating: j['rating'] as int,
          comment: j['comment'] as String?,
          createdAt: DateTime.parse(j['created_at'] as String),
        ));
    return PageResult(items.toList(), res['has_more'] as bool? ?? false);
  }
}
