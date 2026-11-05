import '../../app/localization/l10n.dart';
import 'app_exception.dart';

/// Maps any error to a localized, user-friendly message. Backend messages are never
/// shown directly: the stable code decides the text in the selected language.
String errorText(AppLocalizations l, Object error) {
  if (error is! AppException) return l.errorUnknown;
  return switch (error.code) {
    AppException.network => l.errorNetwork,
    AppException.timeout => l.errorTimeout,
    'VALIDATION_ERROR' => l.errorValidation,
    'NOT_FOUND' => l.errorNotFound,
    'FORBIDDEN' => l.errorForbidden,
    'UNAUTHORIZED' => l.errorUnauthorized,
    'USER_BLOCKED' => l.errorUserBlocked,
    'PROFILE_INCOMPLETE' => l.errorProfileIncomplete,
    'TRIP_OVERLAP' => l.errorTripOverlap,
    'INSUFFICIENT_SEATS' => l.errorInsufficientSeats,
    'TRIP_NOT_ACTIVE' => l.errorTripNotActive,
    'TRIP_ALREADY_STARTED' => l.errorTripStarted,
    'TRIP_NOT_STARTED' => l.errorTripNotStarted,
    'BOOKING_NOT_PENDING' => l.errorBookingNotPending,
    'INVALID_SEGMENT' => l.errorInvalidSegment,
    'BOOKING_EXISTS' => l.errorBookingExists,
    'OWN_TRIP' => l.errorOwnTrip,
    'INVALID_TRANSITION' => l.errorInvalidTransition,
    'REVIEW_NOT_ALLOWED' => l.errorReviewNotAllowed,
    'REVIEW_EXISTS' => l.errorReviewExists,
    'SEATS_BELOW_BOOKED' => l.errorSeatsBelowBooked,
    'TRIP_HAS_BOOKINGS' => l.errorTripHasBookings,
    'PHONE_TAKEN' => l.errorPhoneTaken,
    'LOCATION_INACTIVE' => l.errorLocationInactive,
    'CONTACT_UNAVAILABLE' => l.errorContactUnavailable,
    'USER_UNAVAILABLE' => l.errorUserUnavailable,
    'FILE_TOO_LARGE' => l.errorFileTooLarge,
    'UNSUPPORTED_MEDIA' => l.errorUnsupportedMedia,
    'RATE_LIMITED' => l.errorRateLimited,
    'INVALID_PHONE' => l.errorInvalidPhone,
    'INVALID_CODE' => l.errorInvalidCode,
    'INTERNAL' => l.errorServer,
    _ => l.errorUnknown,
  };
}
