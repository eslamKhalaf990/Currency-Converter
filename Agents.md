# CLAUDE.md — Flutter Assessment Rules (EFG Currency Converter)

Senior-pair-programmer ruleset for building a single feature end-to-end with Clean Architecture,
feature-first structure, and `flutter_bloc`. Trimmed for a timed, single-feature build — no
multi-flavor setup, no full production security hardening, just the practices a reviewer will
actually grade you on. Adapted from a generic fintech-assessment ruleset for EFG Holding's
Currency Converter task specifically: no auth/transfers/balances in scope, but local persistence
and responsive layout *are* explicitly required by the brief.

---

## 1. Core Principles

1. **Clean Architecture**, strict inward dependencies: `presentation → domain ← data`. Domain is
   pure Dart — no Flutter/Dio imports.
2. **Feature-first** folder structure (see §2).
3. **Event-driven state** via `flutter_bloc`. UI dispatches Events, Bloc emits States. No
   business logic in widgets.
4. **Functional error handling** — `Either<Failure, T>` from `dartz` at every
   repository/use-case boundary. No exceptions thrown across layers.
5. **Immutability** — entities, states, events, failures all extend `Equatable`. State base classes must be `sealed` to enforce compile-time exhaustiveness.
6. **Never use `double` for money.** Represent all monetary amounts as integer minor units
   (cents) or a `Decimal` type — end to end, domain through presentation. Floating point
   introduces real rounding errors on balances/fees/FX, and a fintech reviewer will notice a
   `double amount` field immediately.

---

## 2. Package Stack

| Concern | Package |
|---|---|
| State management | `flutter_bloc` |
| Functional error handling | `dartz` (`Either<Failure, Success>`) |
| Value equality | `equatable` |
| JSON codegen | `json_serializable` |
| DI | `get_it` (+ `injectable` if time allows; manual registration is fine for a timed task) |
| Networking | `dio` |
| Concurrency control | `bloc_concurrency` (`droppable()` transformer — prevents duplicate rapid-tap submissions on the converter form) |
| Formatting | `intl` (`NumberFormat.currency` for locale-aware money/number display — see §8) |
| Local persistence | `hive` (or `sqflite` if you prefer relational queries) — **required**: the brief mandates history persists across restarts |
| Testing | `bloc_test`, `mocktail`, `flutter_test` |

Skip unless explicitly asked: `freezed`, `go_router`, multi-flavor entry points, `envied`/env
config, biometrics, certificate pinning, root/jailbreak detection, session-timeout managers,
auth/token interceptors. These are real production concerns (see the full production
`CLAUDE.md`) but out of scope here — this task has no login or transfer flow, and no
API key auth to manage on the suggested (frankfurter.app) provider.

---

## 3. Folder Structure (Feature-First)

```text
lib/
├── main.dart
├── core/
│   ├── di/                      # get_it setup
│   ├── error/
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   └── interceptors/
│   ├── repository/              
│   │   └── base_repository.dart # (Generic Base Repository)
│   ├── theme/
│   │   └── dimens.dart          # spacing/radii constants
│   └── utils/
│       └── json_parser.dart     # compute()-based parsing helpers
└── features/
    └── currency_converter/
        ├── data/
        │   ├── datasources/       # remote (rates API) + local (Hive box, conversion history)
        │   ├── models/
        │   └── repositories/
        ├── domain/
        │   ├── entities/          # ExchangeRate, ConversionRecord
        │   ├── repositories/
        │   └── usecases/          # GetExchangeRate, SaveConversion, GetHistory, DeleteHistoryEntry
        └── presentation/
            ├── bloc/              # one Cubit/Bloc per screen, or split converter/history sub-blocs
            ├── pages/             # converter_page.dart, history_page.dart
            └── widgets/
```

Converter and History are two screens of one feature sharing the same domain/data layers —
no need to split them into separate top-level features.

---

## 4. Layer Rules

### Domain
- Entities extend `Equatable`, no JSON/Flutter imports.
- Repository contracts are abstract, return `Future<Either<Failure, T>>`.
- Use cases are single-responsibility callables (`UseCase<Type, Params>`).

### Data
- Models carry `fromJson`/`toJson`; map to/from domain entities.
- **Generic Base Repository Pattern**: Repository implementations must catch all data-source exceptions and convert them to Failure via Either[cite: 1]. Achieve this by extending a core BaseRepository that uses Higher-Order Functions. Pass your data source methods (RemoteCall, CacheSave, CacheFetch) and a mapper function as closures.
- **No raw try-catch blocks**: Feature repositories must only define what to fetch. The core BaseRepository must handle all try-catch blocks, network checking, and offline fallbacks. Nothing throws upward past the repository.
- **State Exhaustiveness (Dart 3):** Base state classes must be `sealed`. Inside `BlocBuilder` or `BlocConsumer`, use Dart 3 `switch` expressions instead of consecutive `if` statements. This enforces compile-time safety (the compiler will flag missing states) and allows clean object destructuring (e.g., `MyLoadedState(:final data) => ...`) to avoid repetitive `state.variable` calls.
- **List JSON parsing uses `compute()`** — never `jsonDecode` directly in a Bloc, widget, or on
  the UI thread for list/array responses.

### Presentation
- Bloc depends only on use cases, never repositories/data sources directly.
- Events/States are `Equatable`.
- **Never dispatch a Bloc event inside `build()`.** If a screen needs data on first render,
  trigger the event in `initState()` (via a wrapping `StatefulWidget`) or `BlocProvider`'s
  `create` callback — not in `build()`, which re-runs on every rebuild and can cause infinite
  loops or duplicate network calls.
- **Side-effects belong in `BlocListener`**, never inside the Bloc itself. The Bloc must never
  hold a `BuildContext`, navigate, or show a Snackbar/dialog directly.
- **Local UI state boundary.** Not everything needs a Bloc event. Purely ephemeral, non-business
  widget state — a password-visibility toggle, a `TextEditingController`'s raw text, an
  expanded/collapsed card, scroll position — stays as plain `setState`/local `ValueNotifier`.
  Routing trivial UI toggles through Bloc events under time pressure reads as over-engineering,
  not rigor. Anything that affects business logic or is needed on submit (the form's validated
  values) still flows through the Bloc.
- **Scope rebuilds with `BlocSelector`/`context.select`.** For any live-updating value (balance,
  price, quote), select just that field rather than rebuilding the whole screen on every Bloc
  emission. This is a concrete, easily-gradable performance signal alongside the `const`
  constructor rule in §8.

---

## 5. Failure Hierarchy

```dart
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure { const ServerFailure(super.message); }
class CacheFailure extends Failure { const CacheFailure(super.message); }
class NetworkFailure extends Failure { const NetworkFailure(super.message); }
class AuthFailure extends Failure { const AuthFailure(super.message); }
class ValidationFailure extends Failure { const ValidationFailure(super.message); }
```

Never surface raw `toString()` of an exception to the UI. Map each `Failure` to a readable
message in one central mapper.

---

## 6. Networking (Dio)

Minimum viable interceptor chain for the assessment:

1. **ErrorMappingInterceptor** — converts `DioException` → typed exceptions
   (`ServerException`, `NoInternetException`, `TimeoutException`).
2. **LoggingInterceptor** — request/response logging, dev-only.

No `AuthInterceptor` — frankfurter.app requires no API key. If you pick a key-based provider
instead (exchangerate-api.com), add the key via `--dart-define` or a gitignored `.env`, never
hardcoded — that's the assessment's one explicit secrets requirement.

```dart
Dio buildDioClient() {
  final dio = Dio(BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));
  dio.interceptors.addAll([
    ErrorMappingInterceptor(),
    LoggingInterceptor(),
  ]);
  return dio;
}
```

(Certificate pinning, token-refresh, and auth interceptors are real fintech requirements but
irrelevant here — this task has no login/session to protect.)

**No live/stable API fallback:** if the assessment's backend is flaky, mocked-but-undocumented,
or simply absent, stub a `LocalDataSource` (or a fixture-backed `RemoteDataSource`) that returns
canned JSON behind the *same* repository contract. The rest of Clean Architecture — domain,
Bloc, presentation, tests — demos unaffected. Swapping the DI registration back to the real
`dio`-based source later is a one-line change. Don't burn time debugging someone else's API
instead of building.

---

## 7. JSON Parsing — `compute()`

```dart
// core/utils/json_parser.dart
List<AccountModel> parseAccountsList(String responseBody) {
  final decoded = jsonDecode(responseBody) as List<dynamic>;
  return decoded
      .map((json) => AccountModel.fromJson(json as Map<String, dynamic>))
      .toList();
}

// in the remote data source
final accounts = await compute(parseAccountsList, response.data);
```

Top-level or static functions only — isolate entry points can't close over instance state.

---

## 8. Widget Hygiene & Performance

- **Responsive layout is a stated requirement, not a nice-to-have.** The brief requires the app
  to function correctly on phone *and* tablet. Use `LayoutBuilder`/`MediaQuery` breakpoints in
  shared widgets — at minimum, constrain the converter form's max-width on wide screens instead
  of letting it stretch edge-to-edge. Don't hardcode phone-only dimensions.
- **Dark mode (optional) belongs in the theme, not scattered widgets.** If you build it, define
  both `ThemeData` variants off the same `ColorScheme`/`Dimens` tokens from §1's design-system
  requirement — never branch on `Theme.of(context).brightness` inside individual widgets.
- **`build()` reads like a table of contents.** Extract complex UI into private helper widgets
  (`_buildBalanceCard()`) or separate widget classes/files — never one long nested `build()`.
- **No magic numbers/strings.** Spacing/radii via `Dimens.spacingX`; colors and text styles via
  `Theme.of(context).colorScheme` / `.textTheme`. Use `EdgeInsetsDirectional` (start/end) for
  RTL readiness, not `EdgeInsets` (left/right).
- **`final` everywhere a variable isn't reassigned; `const` constructors wherever possible** —
  this is a real performance signal graders look for (fewer rebuilds, cheaper widget trees).
- **Every screen handles `Loading`/`Error`/`Success` explicitly** — never a blank screen while
  waiting or on failure.
- **Error feedback is a reusable widget**, not inline `showDialog`/`ScaffoldMessenger` calls
  scattered around. Build one custom Snackbar or dialog helper (e.g. `AppSnackbar.showError(context, message)`)
  and call it from a `BlocListener` when a `Failure`-derived state is emitted.
- **Money/number display goes through `intl`'s `NumberFormat.currency`** (or equivalent), never
  hand-rolled string interpolation — correct decimal places, thousands separators, and
  locale-aware symbol placement for EGP/USD. Pairs with the `EdgeInsetsDirectional`/RTL rule
  above: formatting and layout direction are both locale concerns, handle them the same way.
- **`flutter analyze` and `dart format .` clean before calling anything done.** Run both before
  your final commit — reviewers often check this mechanically, and warnings left in place read
  as carelessness regardless of how correct the underlying logic is.

---

## 9. Documentation & Comments

- `///` Dart doc comments on all public models, repositories, use cases, and public methods —
  explain *what it does*, not a restatement of the signature.
- Inline `//` comments inside non-obvious business logic (rounding, retry logic, race-condition
  guards) explaining *why*, not what.
- Generated files (`*.g.dart`) are exempt.

---

## 10. Testing — Differentiator, Not a Hard Requirement

Unlike a full fintech eval, this brief lists tests as optional and the time budget is only
4–6 hours. Treat testing as a differentiator once the core converter + history flow, local
persistence, and design system are solid — don't let it eat the budget for the required
features. If you do have time left, follow §10.8's priority order rather than trying to cover
every layer.

### 10.1 Unit tests — Domain (use cases)
- `mocktail` to mock the repository contract.
- For every use case, assert **both** branches: `Right(success)` and `Left(Failure)`.
- Verify the use case calls the repository with the exact expected params (`verify(() =>
  repo.getRate(any(that: equals(baseCurrency)), any(that: equals(targetCurrency))))`).

### 10.2 Unit tests — Data (repository + models)
- Repository impl tests: mock the remote/local data sources, assert exceptions are correctly
  mapped to the right `Failure` subtype (`ServerException` → `ServerFailure`,
  `CacheException` → `CacheFailure`, etc.) — this mapping is a common bug source and an
  easy place to show rigor.
- Model tests: `fromJson`/`toJson` round-trip, **plus malformed/missing-field JSON** (null
  optional fields, unexpected types) to prove the model doesn't crash on real-world API noise.
- If parsing goes through `compute()`, test the top-level parse function directly (it's a plain
  function, no isolate needed in the test).

### 10.3 Bloc tests (`bloc_test`)
- One `blocTest` per event, asserting the exact `expect: [...]` state sequence.
- Cover: success path, failure path, loading state emitted first, and any
  `emit.isDone`/no-emission edge cases (e.g. a debounced search that's cancelled).
- Test `close()` cleans up any `StreamSubscription` if the Bloc holds one.
- Use `bloc_test`'s `seed:` and `act:` to test resuming from a specific prior state, not just
  from `Initial`.

### 10.4 Widget tests
- At minimum: the screen renders `Loading`, `Error`, and `Success` states correctly given a
  mocked Bloc (`bloc_test`'s `MockBloc` / a fake emitting fixed states via `whenListen`).
- Tap-through test for the primary user action (e.g. tapping "Retry" re-dispatches the load
  event; tapping "Convert" dispatches the conversion event with correct form params).
- Assert the error Snackbar/dialog actually appears when a `Failure` state is emitted (proves
  the `BlocListener` wiring works, not just the Bloc logic in isolation).

### 10.5 Golden tests (if time allows)
- One golden test for the primary screen's default state — cheap to add, signals attention to
  visual regression, not required for every state.

### 10.6 Converter-specific edge cases to explicitly test
These are the cases a reviewer will look for by name on this task:
- Zero-amount, negative-amount, and non-numeric inputs rejected before submission (form
  validation, not a failed API call).
- Rounding correctness on the converted result — assert exact values, not just "looks right
  printed."
- Same base/target currency selected — either a no-op result or a friendly message, not a
  silent 1:1 pass-through that looks like a bug.
- Malformed/unexpected API response shape → mapped to a `ServerFailure` with a readable
  message, not a raw parse exception surfaced to the UI.
- No network → `NetworkFailure`, with last-cached rate shown if you build the optional offline
  fallback.
- Duplicate submission guard: rapid double-tap on "Convert" doesn't fire the event (or the
  network call) twice — ties back to the `droppable()` Bloc transformer choice.
- History persists after an app restart (integration-level check, not just a unit test of the
  save call).

### 10.7 Test structure & naming
- Arrange–Act–Assert, with each section either commented or visually separated.
- Descriptive test names as sentences: `test('returns ServerFailure when API response is
  malformed', ...)`, not `test('test1', ...)`.
- Group related tests with `group('GetExchangeRate', () { ... })`.

### 10.8 If time is genuinely short — priority order
1. Bloc tests (state sequences) — highest signal-to-effort ratio.
2. Use case tests (`Left`/`Right` branches).
3. Repository exception→Failure mapping tests.
4. Widget test for the Loading/Error/Success states.
5. Golden test — last, purely nice-to-have.

---

## 11. AI Pair-Programming Rules (strict, for today's session)

- **No code dumps.** Never generate a full feature (domain + data + presentation) in one
  response. Wait for a specific ask (e.g. "generate the model").
- **One layer per request.** If asked for "the data layer," output only models, data sources,
  and the repository implementation — nothing else.
- **Targeted fixes only.** For a bug fix or widget tweak, output only the changed
  method/snippet, not the whole file, unless a full rewrite is explicitly requested.
- **Assume setup exists.** Don't regenerate DI/theme/routing boilerplate unless asked.

---

## 12. Ambiguity & Time Management

- **Don't stall on underspecified requirements.** Timed assessments almost always have a gap
  somewhere (exact validation rule, exact error copy, exact rounding mode). Make the most
  reasonable fintech-sensible choice, note it inline as a `// ASSUMPTION: ...` comment (or a
  one-line entry in an optional `ASSUMPTIONS.md`), and keep moving. Judgment under ambiguity is
  itself part of what's being graded.
- **Commit hygiene, if deliverable as a repo.** Small, atomic commits with descriptive messages
  (`feat: add GetAccountBalance use case`, not `wip` or one giant final commit). A clean history
  is free credibility with a reviewer and costs nothing extra.
- **Optional, time-permitting: a short `DECISIONS.md`.** A few bullets on architecture choices
  made, and what was deliberately skipped per §2's "skip unless asked" list and why (time-boxed,
  not unaware of it). Turns cut corners into visible decisions instead of silent omissions.
