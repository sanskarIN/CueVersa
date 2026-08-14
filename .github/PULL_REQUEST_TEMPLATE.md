## Summary

Describe the user-facing and technical change.

## Verification

- [ ] `dart format --output=none --set-exit-if-changed lib test`
- [ ] `flutter analyze --fatal-infos`
- [ ] `flutter test`
- [ ] Relevant Android build/smoke check

List exact commands and results; do not claim checks that were not run.

## Review areas

- [ ] Physics/rules determinism and regression tolerance impact documented
- [ ] English/Hindi keys added; no new hardcoded user-facing strings
- [ ] Semantics, touch targets, high contrast, text scale, and reduced motion reviewed
- [ ] Privacy/security/data-map impact reviewed
- [ ] Monetization remains optional, fair, and non-deceptive
- [ ] New asset/dependency license and provenance documented
- [ ] No secret, signing material, paid source asset, or personal data committed

## Visuals / migration

Add screenshots for UI work and versioned migration notes for stored-data changes.
