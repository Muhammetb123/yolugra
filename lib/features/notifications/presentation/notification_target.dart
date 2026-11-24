import 'package:auto_route/auto_route.dart';

import '../../../app/router/app_router.dart';
import '../domain/app_notification.dart';

/// Opens the screen a notification is about. The inbox and tapped pushes share it.
void openNotificationTarget(StackRouter router, NotificationType type, {String? tripId, String? bookingId}) {
  switch (type) {
    case NotificationType.bookingRequested:
    case NotificationType.bookingCancelledByPassenger:
      if (tripId != null) router.push(TripManageRoute(tripId: tripId));
    case NotificationType.reviewReceived:
      router.push(const ProfileRoute());
    case NotificationType.tripCompleted:
    case NotificationType.tripReminder:
      if (bookingId != null) {
        router.push(BookingDetailsRoute(bookingId: bookingId));
      } else if (tripId != null) {
        router.push(TripManageRoute(tripId: tripId));
      }
    default:
      if (bookingId != null) {
        router.push(BookingDetailsRoute(bookingId: bookingId));
      } else if (tripId != null) {
        router.push(TripDetailsRoute(tripId: tripId));
      } else {
        router.push(const NotificationsRoute());
      }
  }
}
