import 'dart:ui';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/router/app_router.dart';
import '../app/router/auth_guard.dart';
import '../core/config/app_config.dart';
import '../core/config/server_address.dart';
import '../core/network/api_client.dart';
import '../core/storage/session_storage.dart';
import '../features/authentication/data/auth_repository_impl.dart';
import '../features/authentication/domain/auth_repository.dart';
import '../features/authentication/presentation/bloc/auth_bloc.dart';
import '../features/bookings/data/bookings_repository_impl.dart';
import '../features/bookings/domain/booking.dart';
import '../features/locations/data/locations_repository_impl.dart';
import '../features/locations/domain/location.dart';
import '../features/locations/presentation/bloc/locations_cubit.dart';
import '../features/notifications/data/notifications_repository_impl.dart';
import '../features/notifications/domain/app_notification.dart';
import '../features/notifications/presentation/bloc/notifications_cubits.dart';
import '../features/profile/data/profile_repository_impl.dart';
import '../features/profile/domain/profile.dart';
import '../features/reviews/data/reviews_repository_impl.dart';
import '../features/reviews/domain/review.dart';
import '../features/settings/data/settings_repository_impl.dart';
import '../features/settings/domain/settings_repository.dart';
import '../features/settings/presentation/bloc/settings_cubit.dart';
import '../features/trips/data/trips_repository_impl.dart';
import '../features/trips/domain/trip.dart';
import '../features/vehicle/data/vehicle_repository_impl.dart';
import '../features/vehicle/domain/vehicle.dart';

final sl = GetIt.instance;

/// Registers the object graph. Repositories are bound to their domain interfaces, so
/// tests replace them without touching presentation code. Screen-level cubits are
/// created by their pages from these repositories.
Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  sl
    // First: it sets the backend address every later request uses.
    ..registerSingleton<ServerAddress>(ServerAddress(prefs))
    ..registerSingleton<SettingsRepository>(SettingsRepositoryImpl(prefs))
    ..registerSingleton<SettingsCubit>(SettingsCubit(sl(), device: PlatformDispatcher.instance.locale))
    ..registerSingleton<SessionStorage>(SessionStorage(const FlutterSecureStorage()))
    ..registerSingleton<ApiClient>(ApiClient(session: sl(), language: () => sl<SettingsCubit>().state.languageCode))
    ..registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl(), sl()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl(), sl()))
    ..registerLazySingleton<LocationsRepository>(() => LocationsRepositoryImpl(sl()))
    ..registerLazySingleton<VehicleRepository>(() => VehicleRepositoryImpl(sl()))
    ..registerLazySingleton<TripsRepository>(() => TripsRepositoryImpl(sl()))
    ..registerLazySingleton<BookingsRepository>(() => BookingsRepositoryImpl(sl()))
    ..registerLazySingleton<ReviewsRepository>(() => ReviewsRepositoryImpl(sl()))
    ..registerLazySingleton<NotificationsRepository>(() => NotificationsRepositoryImpl(sl()))
    ..registerSingleton<AuthBloc>(AuthBloc(sl()))
    ..registerSingleton<LocationsCubit>(LocationsCubit(sl()))
    ..registerSingleton<UnreadCubit>(UnreadCubit(sl(), interval: AppConfig.notificationPollInterval))
    ..registerSingleton<AppRouter>(AppRouter(authGuard: AuthGuard(sl())));
}
