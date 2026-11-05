# Architecture

## System

```
Flutter app (yolugra) ──HTTPS/JSON──▶ Go API (carpool-backend) ──▶ PostgreSQL
                                            ▲
Android SMS gateway (delivery_sms_sender) ──┘ polls /gateway/v1, sends OTP SMS via SIM
```

The backend is the source of truth for every business rule: seat availability, booking
transitions, the driver schedule rule, contact privacy and review eligibility. The app validates
forms for convenience only and always shows what the backend decided.

## Backend layering (unchanged conventions)

`internal/http` (chi handlers, DTOs, error envelope) → `internal/service` (use cases, no HTTP
types) → `internal/store` (pgx, transactions). New pure domain rules live in `internal/ride`
(segment math, state machines, validation), tested without a database, in the style of the
existing `internal/smsqueue`. The existing auth, OTP and SMS gateway code was reused; the OTP
check was extracted (`consumeOTP`) so phone changes use the same logic as login.

## Flutter layering

```
lib/
  app/            app widget, router (auto_route), theme, localization (ARB + Turkmen delegates)
  core/           ApiClient, errors, session storage, formatters, shared widgets, PagedCubit
  features/<f>/
    domain/       entities + repository interfaces (pure Dart)
    data/         repository implementations + JSON mappers (ApiClient)
    presentation/ bloc/ (BLoC or Cubit), pages/, widgets/
  init/           initialization.dart (ordered start-up), dependency_injection.dart (get_it)
  main.dart
```

Features: authentication, profile, vehicle, locations, home, trip_search, trip_details,
trip_publication, my_trips, bookings, reviews, notifications, settings. `trips` holds the shared
trip domain, mappers and widgets used by search, details, publication and my_trips.

Decisions:

- **No use-case classes.** Repositories already express the use cases one-to-one; a pass-through
  layer would add files without behaviour. Logic that is real lives in cubits/blocs or the backend.
- **Hand-written mappers** instead of freezed/json_serializable: one mapper per entity, fewer
  generated files, entities stay plain Dart with Equatable.
- **BLoC vs Cubit.** `AuthBloc` (app session) and `TripSearchBloc` (search, refresh, pagination,
  latest-request-wins) use events. Form and screen states use Cubits. `PagedCubit<T>` serves every
  paginated list.
- **Errors.** `ApiClient` turns every failure into `AppException(code)` with the backend's stable
  code; `errorText()` maps codes to localized text. Backend messages are never shown raw.
- **Session.** Access token in memory, refresh token and device id in the platform keystore
  (flutter_secure_storage). On 401 the client refreshes once (shared future) and retries; a
  rejected refresh signs the user out through `AuthBloc`.
- **Navigation.** auto_route with typed routes, `AuthGuard` on everything after sign-in, nested
  tabs (`AutoTabsRouter`), and path parameters (`/trips/:tripId`, `/bookings/:bookingId`,
  `/users/:userId`) so notifications and future deep links open screens directly.
- **Notifications.** In-app inbox from the backend, unread badge polled every 45 s while the app
  is in the foreground. Text is rendered on the device from the event type, in the current
  language. Push (FCM) is not integrated: it needs a Firebase project and platform setup; the
  backend already stores events and has a `device_tokens` table, so FCM can be added as another
  delivery channel without changing screens.
- **No payments**, wallets or card storage anywhere. Price is a nullable number with a currency.

## Dependencies

flutter_bloc/bloc, equatable, auto_route (+ generator, build_runner), get_it, dio,
flutter_secure_storage, shared_preferences, url_launcher (phone dialer), image_picker (photos),
intl/flutter_localizations. Tests: bloc_test, mocktail. auto_route is on 10.x because the
generator for 11.x needs analyzer ≥ 8, which conflicts with bloc_test on Flutter 3.35.
