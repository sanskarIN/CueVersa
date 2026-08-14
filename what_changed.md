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

## 2026-08-14 — Localized offline application experience

- Replaced the generated counter app with a responsive Material 3 CueVerse
  shell, original programmatic logo, one-frame non-delaying splash, progress
  hero, mode selection, support promotion, and navigation to challenges,
  achievements, statistics, tutorial, rules, cosmetics, Settings, Support, and
  About/Open Source screens.
- Built the playable CustomPainter table, accessible table semantics, drag aim,
  adjustable power, two-axis spin control, haptics, portrait/landscape control
  layouts, practice, vs deterministic AI, and local two-player flows.
- Connected real physics events to 8-ball/9-ball turn resolution, scratches,
  ball-in-hand reset, win dialogs, shot statistics, XP, and match records.
- Added deterministic geometry-based AI with legal-target filtering, clear-path
  checks, pocket candidates, scratch-risk scoring, six planning/execution
  difficulty profiles, and normal shot-parameter output through the shared
  physics engine.
- Added local-first persistent settings and progress for theme, locale,
  accessibility, controls, audio/haptics, performance, developer unlock, XP,
  matches, wins, streak, shots, pots, and accuracy. All destructive local-data
  actions require confirmation.
- Expanded polished English/Hindi localization, runtime locale switching,
  pluralized table semantics, system/light/dark themes, high contrast, reduced
  motion, left-handed controls, minimum touch sizing, and screen-reader labels.
- Added grouped deep Settings sections, seven-tap developer unlock, safe local
  diagnostics controls, privacy/security disclosures, and prominent BMC cards
  that never appear during a match.
- Static-analysis errors found and fixed: five `num`/`double` assignments,
  one missing icon constant, one missing localization getter, one unused local,
  and the obsolete generated widget test. Static analysis then reported no
  issues.
- Widget-test issue found and fixed: lazy sliver content meant the BMC card and
  creator watermark were initially offstage. The tests now scroll the actual
  home view before verifying them.
- Checks passed: `dart format lib test`; `flutter analyze --fatal-infos` with no
  issues; full suite initially passed 43 tests; focused updated widget suite
  passed 3 tests including localized practice-table navigation.
- Known failing tests: none after the focused repair. A final complete-suite run
  remains scheduled after documentation and Android hardening.
- Exact next task: add all required open-source, architecture, privacy, legal,
  monetization, UI/UX, testing, release, roadmap, and GitHub workflow files.

## 2026-08-14 — Public repository and release documentation

- Added changelog, public roadmap, NOTICE/third-party inventory, contribution
  guide, code of conduct, security policy, privacy template, and terms template.
- Added issue forms for bugs/features/physics, PR template, funding link,
  Dependabot, Flutter Android CI, and Java/Kotlin CodeQL workflow.
- Documented technology decision, layered architecture, local data model,
  future server authority, every major language/framework/plugin, brand/assets,
  BMC behavior, design system, navigation, accessibility, responsive layout,
  animation, haptics, contrast, typography, and screen status.
- Added privacy data map/retention/permissions, threat model, secure development,
  licensing and legal/privacy review checklists.
- Added ethical revenue/fairness/store/ads/BMC/premium policies; no ads, billing,
  wagering, loot boxes, paid ranked advantage, or donation gating was added.
- Added gameplay rules/controls/AI/progression/offline-mode docs, feature status,
  upcoming roadmap/status/premium files, suggestion process, test strategy,
  release matrix, Android manual matrix, signing, Play checklist, release-note
  template, developer setup, and commit/continuation guidance.
- Verified the required documentation and GitHub file inventory with `rg --files`.
- Exact next task: finish Android icon/splash/signing hardening and validate APK/AAB.

## 2026-08-14 — Android resource and build hardening

- Replaced five Flutter scaffold launcher PNGs with original CueVerse legacy
  vector, round, and Android adaptive icon resources; added original native
  splash vector and Android 12 splash theme with no artificial delay.
- Changed release signing to load ignored `key.properties` only when supplied;
  production artifacts no longer silently use the debug key. Added original
  round icon manifest metadata.
- First debug APK build exposed Kotlin incremental-cache failures because pub
  plugin sources were on `C:` and the workspace on `E:`. Stopped the attempt,
  disabled cross-drive Kotlin incremental state, selected in-process compilation,
  ran `flutter clean`, restored locked dependencies, stopped stale Gradle daemon,
  and rebuilt.
- Checks passed: clean `flutter build apk --debug` in 1081.8 seconds. Artifact:
  `build/app/outputs/flutter-apk/app-debug.apk`, 150,954,913 bytes, SHA-256
  `16863665dfceb5218b6f8b3272f97309b95051ece96b8b2d90789d5a40a8c8b7`.
- Nonfatal environment warnings: Flutter `Zone.Identifier`; Android installed
  SDK command-line tooling understands XML through version 3 but encountered 4.
- Exact next task: run unsigned release AAB/R8 validation, then final format,
  analyzer, complete tests, repository audit, commits, and GitHub push.
