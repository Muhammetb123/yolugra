import '../../../core/network/api_client.dart';
import '../../../core/utils/wire.dart';
import '../../profile/data/profile_repository_impl.dart';
import '../../profile/domain/profile.dart';
import '../domain/moderation.dart';

/// Uses POST|DELETE /v1/users/{id}/block, GET /v1/me/blocks and POST /v1/reports.
class ModerationRepositoryImpl implements ModerationRepository {
  ModerationRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<void> block(String userId) => _api.post('/v1/users/$userId/block');

  @override
  Future<void> unblock(String userId) => _api.delete('/v1/users/$userId/block');

  @override
  Future<List<UserSummary>> blocked() async {
    final res = await _api.get('/v1/me/blocks');
    return (res['items'] as List? ?? const []).cast<Map<String, dynamic>>().map(userSummaryFromJson).toList();
  }

  @override
  Future<void> report({required String userId, required ReportReason reason, String? tripId, String details = ''}) =>
      _api.post('/v1/reports', body: reportToJson(userId: userId, reason: reason, tripId: tripId, details: details));
}

/// The POST /v1/reports body. Empty optional fields are left out.
Map<String, dynamic> reportToJson({required String userId, required ReportReason reason, String? tripId, String details = ''}) => {
      'reported_user_id': userId,
      'reason': wire(reason),
      if (tripId != null && tripId.isNotEmpty) 'trip_id': tripId,
      if (details.trim().isNotEmpty) 'details': details.trim(),
    };
