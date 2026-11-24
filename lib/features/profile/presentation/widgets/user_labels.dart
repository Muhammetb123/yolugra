import '../../../../app/localization/l10n.dart';
import '../../domain/profile.dart';

extension UserLabels on AppLocalizations {
  /// The name to show for [user]. A deleted account has no name left, so past trips,
  /// bookings and reviews show a placeholder instead.
  String userName(UserSummary user) => user.deleted ? userDeleted : user.fullName;
}
