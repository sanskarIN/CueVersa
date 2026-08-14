# ADR-001: Flutter and Dart for CueVerse

- Status: accepted
- Date: 2026-08-14
- Decision owners: CueVerse maintainers

## Context

CueVerse requires an Android-first, original 2D cue-sports experience with
custom rendering, deterministic physics, localization, accessibility,
responsive UI, strong automated testing, and potential future platform reach.

## Decision

Use Flutter stable and Dart for the client. Use a custom fixed-step Dart physics
domain rather than delegating core outcomes to widget animations or a generic
3D engine. Keep future online authority behind a separate versioned service
boundary; no backend is included now.

## Why

- CustomPainter provides precise 2D table/ball rendering without a large engine
  runtime or proprietary editor assets.
- Dart supports a portable, testable deterministic core and mature Flutter
  tooling for analyzer, formatter, unit/widget tests, localization, and Android.
- Material semantics, focus, text scale, localization delegates, theming, and
  adaptive layouts make accessibility an architectural concern from day one.
- Flutter produces Android APK/AAB artifacts and supports future desktop/web/iOS
  evaluation without changing the domain API.

## Alternatives

- Godot: excellent game-loop/2D tooling, but Flutter better fits the unusually
  deep settings, content, accessibility, localization, and app-style UI surface.
- Unity: strong 3D ecosystem but unnecessary runtime/editor/licensing weight for
  this 2D scope.
- Kotlin/Compose: excellent Android integration, but less convenient for a
  shared deterministic core and future platform expansion.
- A third-party physics engine: could accelerate general collision work but
  makes pool-specific spin/pocket determinism, calibration, and replay versioning
  harder to own and test.

## Consequences

Maintainers must calibrate and version the custom physics model. Cross-runtime
determinism must be verified before online ranked claims. Flutter upgrades are
batched, analyzed, fully tested, Android-built, and documented. Cue elevation
remains rejected until a valid 3D/masse model exists.
