# Release checklist

No version is a release candidate until every applicable item is checked with
recorded evidence.

## Source and product

- [ ] Version/build/change log/release notes/status agree.
- [ ] Canonical name/package/links/creator/support/BMC identity verified.
- [ ] No copied commercial identity/assets/UI/audio/progression.
- [ ] No TODO/omitted/fake result/secret/signing material/personal test data.
- [ ] Required screens/routes work; unsupported future features are not sold.

## Quality

- [ ] Formatter, localization generation, analyzer, complete tests pass.
- [ ] Physics/rules/AI regressions and full manual matches pass.
- [ ] No known compile/analyzer/non-quarantined test failure or critical defect.
- [ ] Accessibility/localization/responsive/device/performance matrices pass.
- [ ] Save/migration/background/resume/orientation/low-memory behavior passes.

## Android

- [ ] Original adaptive icon and native splash render at every density/theme.
- [ ] compile/target/min SDK and 64-bit policy current and documented.
- [ ] Merged release manifest has only necessary permissions/components.
- [ ] Cleartext/backup/data extraction policies verified on artifact/device.
- [ ] R8 release AAB builds, signs externally, installs, upgrades, and smoke-tests.
- [ ] Artifact SHA-256, mapping/symbol files, provenance, and rollback retained.
- [ ] Play pre-launch, content rating, data safety, families/accessibility, store
  listing, screenshots, support/privacy URLs, and staged rollout reviewed.

## Security, privacy, legal, and business

- [ ] Dependency/advisory/CodeQL/secret/SBOM/license/asset provenance review.
- [ ] Threat model, privacy data map/policy, terms, security policy, notices match
  actual build and received qualified review where required.
- [ ] No analytics/ads/billing/network claim absent from data/policy disclosure.
- [ ] Monetization is optional, honest, non-gambling, non-pay-to-win, restorable,
  family/platform compliant where applicable.
- [ ] BMC destination, label, failure, disclaimer, nontracking, placements tested.

## Release operations

- [ ] Clean checkout reproduces checks/artifact from locked inputs.
- [ ] Protected tag/release commit, release notes, known issues, support plan,
  staged rollout/monitoring/rollback owners ready.
- [ ] `what_changed.md`, status, continuation ledger, roadmap, notices updated.
