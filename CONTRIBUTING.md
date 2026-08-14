# Contributing to CueVerse

Thank you for helping build an original, fair, accessible cue-sports game.

## Before starting

1. Read `CODE_OF_CONDUCT.md`, `SECURITY.md`, `PROJECT_STATUS.md`, and the
   relevant architecture/gameplay documentation.
2. Search existing issues and suggestions. Discuss large features before
   implementation so physics, rules, accessibility, and licensing remain
   coherent.
3. Never contribute copied branding, art, audio, UI layouts, progression
   systems, or proprietary behavior from commercial pool titles.

## Development setup

Use Flutter stable 3.44.7 or a documented compatible upgrade, Dart 3.12.2 or
newer in the supported range, JDK 17, and an Android SDK.

```shell
flutter pub get
flutter gen-l10n
dart format --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test
flutter build apk --debug
```

Do not claim a check passed unless you ran it. Document environment-limited
checks in `what_changed.md`.

## Change rules

- Keep deterministic engine code independent from Flutter UI.
- Add regression tests for physics/rules changes and explain tolerance changes.
- Put all user-facing text in both ARB catalogs; mark translation review status.
- Preserve 48 dp targets, semantics, keyboard/focus behavior, large text, high
  contrast, reduced motion, and color-independent meaning.
- Add no secret, key, signing file, paid asset source, or user data fixture.
- Validate imported/network data and use versioned serialization.
- Update documentation, status ledgers, notices, and changelog when applicable.

## Git and review

Use a focused branch and conventional commits. A pull request should explain
behavior, tests, accessibility, privacy/security, screenshots for UI changes,
and license provenance for assets/dependencies. Maintainers may ask for smaller
commits but will not accept meaningless commit spam.

By contributing, you agree that your contribution is licensed under Apache
License 2.0 unless clearly stated and accepted otherwise.
