# Localization

Languages: **Turkmen (`tk`, primary)**, Russian (`ru`), English (`en`).

## App texts

- ARB files in `lib/app/localization/arb/` (`app_en.arb` is the template with placeholder
  metadata). `flutter gen-l10n` (run automatically by `flutter pub get`/build, configured in
  `l10n.yaml`) generates `lib/app/localization/generated/`.
- Widgets use `context.l10n.<key>`; no interface text is hard-coded. Enum labels (statuses,
  amenities, vehicle types) are mapped in one place per feature (`trip_labels.dart`,
  `vehicle_labels.dart`).
- All three files have the same keys; a parity check is part of the workflow (see TESTING.md).
- Plurals: Russian uses one/few/many forms; Turkmen nouns do not change after numbers, so Turkmen
  strings use a single form.

## Language choice

The language follows the device on first start (falling back to Turkmen), can be changed in
Settings or on the sign-in screen, and is saved in `shared_preferences`. It is sent to the backend
as `Accept-Language` on every request (so the OTP SMS and backend messages use the same language).
A change made in Settings is also saved to the account (`PATCH /v1/me {locale}`).

## Turkmen in Flutter

Flutter's Material/Cupertino translations and intl's date data do not include Turkmen. The app adds:

- `registerTurkmenDateSymbols()` — Turkmen month and weekday names and date patterns, registered
  with `initializeDateFormattingCustom`, the same mechanism Flutter uses for its own locales.
  `DateFormat(..., 'tk')` then works everywhere.
- `TkMaterialLocalizations`, `TkCupertinoLocalizations`, `TkWidgetsLocalizations` — Turkmen
  strings for pickers, dialogs and text selection. Keyboard key names (never shown on a phone)
  stay as in the English base classes.

## Dates, numbers, currency

Formatting goes through `core/utils/formatters.dart`: server UTC times are shown in device local
time; "Today"/"Tomorrow" are localized; prices use the localized pattern (`150 manat`, `150 ман.`,
`150 TMT`). Search dates are calendar days in Turkmenistan time on the server.

## Backend errors and locations

Clients switch on the error `code` and show their own localized text (`core/errors/error_text.dart`).
The backend also localizes `message` (tk/ru/en) for other clients. Location names come from the
database in all three languages; the picker searches all three, so "Мары" and "Mary" both find Mary.
