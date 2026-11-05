import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/authentication/presentation/pages/complete_profile_page.dart';
import '../../features/authentication/presentation/pages/otp_page.dart';
import '../../features/authentication/presentation/pages/phone_page.dart';
import '../../features/authentication/presentation/pages/splash_page.dart';
import '../../features/bookings/presentation/pages/booking_details_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/main_shell_page.dart';
import '../../features/my_trips/presentation/pages/edit_trip_page.dart';
import '../../features/my_trips/presentation/pages/my_trips_page.dart';
import '../../features/my_trips/presentation/pages/trip_manage_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/change_phone_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/public_profile_page.dart';
import '../../features/reviews/presentation/pages/leave_review_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/trip_details/presentation/pages/trip_details_page.dart';
import '../../features/trip_publication/presentation/pages/publish_trip_page.dart';
import '../../features/trip_search/presentation/pages/search_page.dart';
import '../../features/trip_search/presentation/pages/search_results_page.dart';
import '../../features/trips/domain/trip.dart';
import '../../features/vehicle/domain/vehicle.dart';
import '../../features/vehicle/presentation/pages/vehicle_form_page.dart';
import '../../features/vehicle/presentation/pages/vehicles_page.dart';
import 'auth_guard.dart';

part 'app_router.gr.dart';

/// Typed routes. Detail screens have path parameters so notifications and deep links
/// can open them directly (/trips/:tripId, /bookings/:bookingId, /users/:userId).
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter({required this.authGuard});

  final AuthGuard authGuard;

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: '/splash', initial: true),
        AutoRoute(page: PhoneRoute.page, path: '/login'),
        AutoRoute(page: OtpRoute.page, path: '/login/code'),
        AutoRoute(page: CompleteProfileRoute.page, path: '/welcome'),
        AutoRoute(
          page: MainShellRoute.page,
          path: '/',
          guards: [authGuard],
          children: [
            AutoRoute(page: HomeRoute.page, path: 'home', initial: true),
            AutoRoute(page: SearchRoute.page, path: 'search'),
            AutoRoute(page: PublishTripRoute.page, path: 'publish'),
            AutoRoute(page: MyTripsRoute.page, path: 'my-trips'),
            AutoRoute(page: ProfileRoute.page, path: 'profile'),
          ],
        ),
        AutoRoute(page: SearchResultsRoute.page, path: '/results', guards: [authGuard]),
        AutoRoute(page: TripDetailsRoute.page, path: '/trips/:tripId', guards: [authGuard]),
        AutoRoute(page: TripManageRoute.page, path: '/my-trips/:tripId', guards: [authGuard]),
        AutoRoute(page: EditTripRoute.page, path: '/my-trips/:tripId/edit', guards: [authGuard]),
        AutoRoute(page: BookingDetailsRoute.page, path: '/bookings/:bookingId', guards: [authGuard]),
        AutoRoute(page: LeaveReviewRoute.page, path: '/bookings/:bookingId/review', guards: [authGuard]),
        AutoRoute(page: VehiclesRoute.page, path: '/vehicles', guards: [authGuard]),
        AutoRoute(page: VehicleFormRoute.page, path: '/vehicles/edit', guards: [authGuard]),
        AutoRoute(page: EditProfileRoute.page, path: '/profile/edit', guards: [authGuard]),
        AutoRoute(page: ChangePhoneRoute.page, path: '/profile/phone', guards: [authGuard]),
        AutoRoute(page: PublicProfileRoute.page, path: '/users/:userId', guards: [authGuard]),
        AutoRoute(page: NotificationsRoute.page, path: '/notifications', guards: [authGuard]),
        AutoRoute(page: SettingsRoute.page, path: '/settings', guards: [authGuard]),
        RedirectRoute(path: '*', redirectTo: '/'),
      ];
}
