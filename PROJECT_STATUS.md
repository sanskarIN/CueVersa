# Project status

- Product: CueVerse
- Version: `1.0.0+1`
- Phase: 3 — main UI and offline gameplay
- Release maturity: pre-alpha
- Canonical repository: `https://github.com/sanskarIN/CueVersa`
- Android application ID: `io.github.sanskarin.cueversa`
- Toolchain: Flutter 3.44.7 / Dart 3.12.2 / Kotlin / Gradle

## Current verified state

The repository has a generated Android Flutter scaffold, security-conscious
Android defaults, a deterministic cue-physics engine, 8-ball rules, 9-ball
rules, and 33 passing core regressions. The interactive application shell is
the active batch. No release candidate claim is made.

## Active release gates

| Gate | Status |
|---|---|
| Android project generated | Passed |
| Deterministic physics tests | Passed (16 core/vector + physics tests) |
| 8-ball rules tests | Passed (11 tests) |
| 9-ball rules tests | Passed (6 tests) |
| Offline practice and vs AI | Pending |
| Local two-player | Pending |
| English and Hindi localization | Pending |
| Analyzer has zero errors | Pending |
| Tests have zero known failures | Pending |
| Android debug APK builds | Pending |
| Android release AAB configuration | In progress |
| License and notices reviewed | In progress |

See `docs/development/phase_status.md` and
`docs/development/continuation_ledger.md` for the exact continuation point.
