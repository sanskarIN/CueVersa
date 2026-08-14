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

- Phase: 12 of 15
- Batch: documentation, CI, legal, and Android release hardening
- Last completed file: `docs/development/known_issues.md`
- Exact next task: rerun `flutter test` and `flutter build appbundle --release`
- Next check: full Flutter test suite followed by unsigned release AAB/R8
- Blocking issue: the execution approval service reported its usage limit until
  2026-08-20 15:01 local time; Flutter commands requiring access outside the
  workspace and GitHub push cannot currently be approved

## Pending remote synchronization

Local `main` contains eight implementation commits beyond `origin/main` at the
time of the push attempt. A sandboxed push could not connect to GitHub port 443;
the required escalated push was then rejected by the approval usage limit. Do
not recreate or squash the work. After approval is available, verify `git
status`, run the pending gates, append their results, commit the ledger, then
execute `git push origin main`.

## Ordered continuation queue

- [x] Deterministic physics primitives and table simulator
- [x] Physics regression tests
- [x] 8-ball and 9-ball rule state machines and tests
- [x] Application shell, navigation, design system, and localization
- [x] Interactive practice, vs AI, and local two-player table
- [x] Persistence, progression, achievements, missions, and statistics foundation
- [x] Settings, accessibility, support, About, and developer options
- [ ] Documentation, legal templates, CI, assets, Android hardening
- [ ] Full release-gate verification and GitHub push
