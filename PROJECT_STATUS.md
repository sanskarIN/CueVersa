# Project status

- Product: CueVerse
- Version: `0.1.0+1`
- Phase: 3 — main UI and offline gameplay
- Release maturity: pre-alpha
- Canonical repository: `https://github.com/sanskarIN/CueVersa`
- Android application ID: `io.github.sanskarin.cueversa`
- Toolchain: Flutter 3.44.7 / Dart 3.12.2 / Kotlin / Gradle

## Current verified state

The repository has a playable localized Android application, deterministic
cue physics, 8-ball and 9-ball rules, offline practice, rules-respecting AI,
local two-player, persistent progress/settings, accessibility controls, and a
large automated suite. Documentation and Android release hardening are active.
No release candidate claim is made.

## Active release gates

| Gate | Status |
|---|---|
| Android project generated | Passed |
| Deterministic physics tests | Passed (16 core/vector + physics tests) |
| 8-ball rules tests | Passed (11 tests) |
| 9-ball rules tests | Passed (6 tests) |
| Offline practice and vs AI | Implemented; widget/AI tests pass |
| Local two-player | Implemented; full manual match pending |
| English and Hindi localization | Implemented; review status tracked |
| Analyzer has zero errors | Passed after UI batch |
| Tests have zero known failures | Previous full suite passed; post-hardening rerun blocked by tool execution quota |
| Android debug APK builds | Passed; SHA recorded in work log |
| Android release AAB configuration | Configured; build request blocked by tool execution quota |
| License and notices reviewed | Initial inventory complete; release review pending |

See `docs/development/phase_status.md` and
`docs/development/continuation_ledger.md` for the exact continuation point.
