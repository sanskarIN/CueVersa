# Continuation ledger

## Resume contract

Never recreate the repository or discard existing work. At every continuation:

1. Read `what_changed.md`, `PROJECT_STATUS.md`, this ledger, phase status,
   known issues, and `git status`.
2. Preserve uncommitted user changes.
3. Resume the first unchecked task below.
4. Run relevant format/analyze/test/build checks.
5. Update all continuity files before stopping.

## Current cursor

- Phase: 3 of 15
- Batch: localized application shell and offline table
- Last completed file: `test/core/nine_ball_rules_test.dart`
- Exact next file: `lib/app/app_settings.dart`
- Next check: focused settings persistence tests
- Blocking issue: none

## Ordered continuation queue

- [x] Deterministic physics primitives and table simulator
- [x] Physics regression tests
- [x] 8-ball and 9-ball rule state machines and tests
- [ ] Application shell, navigation, design system, and localization
- [ ] Interactive practice, vs AI, and local two-player table
- [ ] Persistence, progression, achievements, missions, and statistics
- [ ] Settings, accessibility, support, About, and developer options
- [ ] Documentation, legal templates, CI, assets, Android hardening
- [ ] Full release-gate verification and GitHub push
