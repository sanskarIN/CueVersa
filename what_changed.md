# CueVerse work log

This append-only log records implementation batches and verified command
results. “Passed” is used only for commands actually executed.

## 2026-08-14 — Repository bootstrap

- Read and accepted the complete master development prompt.
- Cloned `https://github.com/sanskarIN/CueVersa` at `5c92ca1`.
- Configured repository-local Git author as `Sanskar
  <sanskarin@outlook.in>`; no global Git configuration was changed.
- Selected Flutter/Dart with an Android-first target. The installed toolchain
  reports Flutter 3.44.7 and Dart 3.12.2.
- Generated the Flutter Android scaffold with application ID
  `io.github.sanskarin.cueversa` and minimum Android SDK 23.
- Added strict analyzer settings, localization generation, local preferences,
  safe external-link support, secure Android network defaults, backup
  exclusions, and R8 configuration.
- Added the initial public README and required continuation documents.
- Command note: `flutter --version` emitted a harmless Windows
  `Unblock-File ... Zone.Identifier` warning before reporting the version.
- Checks passed: repository clone and Flutter scaffold generation.
- Added original light/dark BMC support-card SVG artwork with accessible SVG
  metadata; no protected BMC logo artwork is bundled.
- Added English and Hindi ARB catalogs and generated Dart localization classes.
- Checks passed: `flutter pub get` and `flutter gen-l10n` after the localization
  catalogs were added. Dependency resolution reports six newer versions that
  are outside current compatible constraints, not resolution failures.
- Checks pending: formatting, analyzer, tests, and Android build.
- Exact next task: implement vector math, deterministic table simulation, ball
  collision/cushion/pocket behavior, and physics regression tests.

## 2026-08-14 — Deterministic physics and rules engine

- Implemented metre-based vector math, ball state, table geometry, 8-ball and
  9-ball rack builders, fixed 240 Hz time stepping, fixed-step render-time
  accumulation, rolling resistance, sliding-to-rolling coupling, top/back
  spin, side-spin rail deflection, ball impulses, cushions, pocket capture,
  pocket-jaw rejection, scratch events, and deterministic event streams.
- Implemented configurable WPA-inspired/casual 8-ball state transitions,
  group assignment, legal first contact, rail/pocket requirements, scratches,
  ball in hand, called/early 8-ball outcomes, and break handling.
- Implemented 9-ball lowest-ball contact, continuing turns, fouls, ball in
  hand, legal 9-ball wins, and foul respotting.
- Added regression coverage for head-on, 30°/60° cut, cushion, two-rail bank,
  draw, follow, side English, jaw rejection, scratch, break spread,
  deterministic replay, and frame-chunk independence.
- Error found: the initial draw-spin coupling left the cue ball moving forward
  after impact. Increased physically motivated sliding coupling; the focused
  draw regression then passed.
- Environment issue: the first sandboxed test attempt could not update Flutter's
  telemetry-session file. Re-ran the same tests with the required environment
  permission. A focused test invoked through `cmd.exe` with a quoted test name
  triggered Flutter's Windows “Illegal character in path” crash; the generated
  crash log was removed and the same test passed through PowerShell.
- Checks passed: `dart format lib/features/game/domain test/core`; focused draw
  regression; complete `flutter test test/core -r expanded` with 33 tests.
- Known failing tests: none in `test/core`.
- Exact next task: replace the generated counter application with the localized
  CueVerse application shell, accessible navigation, settings state, and the
  interactive offline table.
