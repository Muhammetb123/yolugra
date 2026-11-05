# Development setup

Tested with Flutter 3.35.4 (Dart 3.9), Go 1.23+ (built with 1.26), Docker Desktop, PostgreSQL 16 (compose).

## 1. Backend

```bash
cd ../carpool-backend
cp .env.example .env            # set secrets; PORT=8081 for the phone setup below
docker compose up -d postgres
MIGRATE_ON_START=true go run ./cmd/api
```

Migrations 000005 and 000006 add the product schema; `btree_gist` must be available (it is in the
official postgres image). With `DEV_MODE=true` the OTP is also returned in the API response and the
debug app shows it under the code field; never enable DEV_MODE in production.

## 2. SMS gateway

The Android app in `../sms/delivery_sms_sender` polls `/gateway/v1/*` with a key from
`POST /admin/v1/gateways` (see the backend README). Nothing in the gateway changed.

## 3. Phone over USB

```bash
adb reverse tcp:8081 tcp:8081   # 127.0.0.1:8081 on the phone reaches the computer
```

Debug and profile builds allow plain HTTP for this (`android/app/src/debug|profile/AndroidManifest.xml`).
Release builds require HTTPS.

## 4. App

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # routes (app_router.gr.dart)
flutter run
# another backend:
flutter run --dart-define=API_BASE_URL=https://api.example.tm
```

Configuration (`lib/core/config/app_config.dart`): `API_BASE_URL` (default `http://127.0.0.1:8081`),
timeouts, notification polling interval.

## 5. After editing

- ARB files → `flutter gen-l10n` (or any build).
- `@RoutePage` pages or routes → run build_runner again.
- `flutter analyze` must stay clean.
