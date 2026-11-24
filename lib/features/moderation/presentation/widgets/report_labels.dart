import '../../../../app/localization/l10n.dart';
import '../../domain/moderation.dart';

extension ReportLabels on AppLocalizations {
  String reportReason(ReportReason reason) => switch (reason) {
        ReportReason.spam => reportReasonSpam,
        ReportReason.fraud => reportReasonFraud,
        ReportReason.abuse => reportReasonAbuse,
        ReportReason.noShow => reportReasonNoShow,
        ReportReason.unsafe => reportReasonUnsafe,
        ReportReason.fakeProfile => reportReasonFakeProfile,
        ReportReason.inappropriateContent => reportReasonInappropriateContent,
        ReportReason.other => reportReasonOther,
      };
}
