# Testing

## Backend (Go)

```bash
cd ../carpool-backend
go vet ./...
go test ./...            # unit tests; integration tests skip without a database
make test-integration    # real PostgreSQL, database carpool_test (create it once, see below)
```

Create the disposable database once:
`docker compose exec postgres psql -U carpool -c "CREATE DATABASE carpool_test"`.

| Suite | Covers |
| --- | --- |
| `internal/ride` | Segment load/free seats/full, booking and trip transitions, overlap with buffer, route and trip validation. |
| `internal/store` integration | Concurrent approvals (2+3 on 4 seats, 10 rounds; 12 parallel one-seat requests), disjoint and overlapping segments, invalid segments, cancellation restores exactly once under 5 parallel cancels, duplicate approval, driver/trip cancellation, 10 concurrent overlapping publications, exclusion constraint, contact and plate privacy, review eligibility and duplicates, search with welayat expansion and segment seats, lifecycle job, phone change with OTP. Final database state is asserted, not only results. |
| `internal/http` e2e | Real router + database: OTP login with dev code, profile completion gate, vehicle, trip, overlap 409, search, booking, privacy before/after approval, notifications without phone numbers, cancellation. |
| Existing suites | Auth, OTP, SMS queue, gateway, config, migrations (still pass). |

## App (Flutter)

```bash
flutter analyze
flutter test                                   # unit, bloc, widget
flutter test test/integration --dart-define=RUN_CONTRACT=true --dart-define=API_BASE_URL=http://127.0.0.1:8090
```

| Suite | Covers |
| --- | --- |
| `test/unit` | Phone normalization, enum wire names, segment seats, trip/booking JSON from the backend, draft and search serialization, error envelope mapping, error texts in all three languages. |
| `test/bloc` | AuthBloc (restore, profile gate, session expiry), phone/OTP cubits, search (results, empty, failure), booking form (segment and seat limits, seat conflict), publication (route validation, stop reordering, vehicle seat cap, overlap error), trip management (grouping, conflict reload). |
| `test/widget` | Trip card in tk/ru/en, Turkmen date symbols and date picker, plate privacy, request tile without/with phone, route timeline, amenities. |
| `test/integration` | Contract test: the real ApiClient, repositories and mappers against a running backend — the full driver/passenger flow including overlap, segment conflict, privacy, notifications, cancellation, editing. |

The contract test needs a backend with `DEV_MODE=true`, `OTP_TEST_PHONES=+99361000001,+99361000002,+99361000003,+99361000004`
and **its own database with no registered SMS gateway**, so that no SMS is ever sent:

```bash
PORT=8090 DEV_MODE=true MIGRATE_ON_START=true \
DATABASE_URL=postgres://carpool:carpool@localhost:5432/carpool_test?sslmode=disable \
OTP_TEST_PHONES=+99361000001,+99361000002,+99361000003,+99361000004 \
JWT_SECRET=... OTP_HMAC_SECRET=... ADMIN_TOKEN=... go run ./cmd/api
```

ARB parity (all languages have the same keys):

```bash
python -c "import json;k=lambda l:{x for x in json.load(open(f'lib/app/localization/arb/app_{l}.arb',encoding='utf-8')) if x[0]!='@'};print(k('en')^k('ru'), k('en')^k('tk'))"
```
