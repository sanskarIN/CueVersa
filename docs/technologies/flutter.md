# Flutter

Selected version: stable 3.44.7 during bootstrap. Flutter owns rendering,
Material widgets, semantics, localization delegates, lifecycle integration,
widget testing, and Android packaging.

Setup and diagnostics:

```shell
flutter doctor -v
flutter pub get
flutter gen-l10n
flutter analyze --fatal-infos
flutter test
flutter run
```

Use profile mode for frame/timeline analysis; debug timing is not release
performance evidence. Upgrades require reading Flutter breaking changes,
updating the CI pin, regenerating platform files only through a reviewed diff,
and passing format/analyze/test/APK/AAB gates.

License: BSD 3-Clause; retain Flutter/Dart notices in distributed attribution.
