# Developer setup

Requirements: Git, Flutter stable 3.44.7 compatible toolchain, Dart 3.12.2,
JDK 17, Android SDK/platform tools, and an emulator/device.

```shell
git clone https://github.com/sanskarIN/CueVersa.git
cd CueVersa
flutter doctor -v
flutter pub get
flutter gen-l10n
flutter analyze --fatal-infos
flutter test
flutter run
```

Repository-local commit identity:

```shell
git config user.name "Sanskar"
git config user.email "sanskarin@outlook.in"
```

Do not change global Git identity for this project. Never add release keys,
credentials, generated crash dumps, local IDE state, or private user data.

Windows environments may print a Flutter `Zone.Identifier` cleanup warning; it
is nonfatal here but should be fixed in the toolchain installation rather than
hidden in project tests.
