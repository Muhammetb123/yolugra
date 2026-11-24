import '../../profile/domain/profile.dart';

/// Why a user is reported. The wire names are the backend's `reason` values.
enum ReportReason { spam, fraud, abuse, noShow, unsafe, fakeProfile, inappropriateContent, other }

/// The backend's limit for the free text of a report.
const maxReportDetails = 1000;

/// Blocks between users and reports to the Ýolugra team.
abstract interface class ModerationRepository {
  /// Hides both users' trips from each other and refuses bookings between them.
  /// Blocking an already blocked user changes nothing.
  Future<void> block(String userId);

  Future<void> unblock(String userId);

  /// The users the signed-in user blocked, newest first.
  Future<List<UserSummary>> blocked();

  /// Sends a report to the admin queue. [details] is required for [ReportReason.other];
  /// [tripId] tells the team which trip the report is about.
  Future<void> report({required String userId, required ReportReason reason, String? tripId, String details = ''});
}
