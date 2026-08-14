# Test strategy

CueVerse verification combines deterministic unit/regression tests, state-rule
tests, persistence tests, widget/semantics/navigation tests, Android builds, and
manual device/accessibility/performance checks. Automated success never implies
an unexecuted manual gate passed.

## Local automated gate

```shell
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test -r expanded
flutter build apk --debug
```

CI additionally generates localization code and captures coverage/machine test
results. Release validation adds R8 AAB, merged-manifest, signing, install/
upgrade, emulator/device, profile, policy, license, secret, and artifact checks.
