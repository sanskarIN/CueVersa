# CueVerse

**Aim. Spin. Own the table.**

CueVerse is an original, open-source cue-sports game built with Flutter for
Android. The project focuses on deterministic 2D physics, accessible controls,
offline play, fair competition, and a local-first data model. It does not copy
the identity, art, interface, progression, or proprietary assets of any
commercial pool title.

> Current release channel: early development (`1.0.0+1`). See
> [PROJECT_STATUS.md](PROJECT_STATUS.md) for verified capabilities and gates.

## Run locally

Requirements: Flutter stable 3.44 or newer, Dart 3.12 or newer, JDK 17, and an
Android SDK accepted by `flutter doctor`.

```shell
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter run
```

Android artifacts:

```shell
flutter build apk --debug
flutter build appbundle --release
```

Release signing credentials are never stored in this repository. Follow
[`docs/release/signing.md`](docs/release/signing.md) before publishing an AAB.

## Product principles

- Original cue-sports presentation and rules-aware gameplay.
- Deterministic, frame-rate-independent simulation.
- English and Hindi localization from the first release.
- Screen-reader semantics, scalable text, high contrast, reduced motion, and
  left/right-handed control options.
- No wagering, loot boxes, deceptive monetization, or paid ranked advantages.
- Local-first storage; network features must document transmitted data.

## Support the project

[Support this project — Buy Me a Coffee](https://buymeacoffee.com/sanskarIN)

Donations are optional, do not unlock core gameplay, and do not guarantee
features or support priority. Accessible label: “Support Sanskar on Buy Me a
Coffee”.

## Community and project links

- Creator: [Sanskar](https://www.github.com/sanskarIN)
- Repository: [github.com/sanskarIN/CueVersa](https://github.com/sanskarIN/CueVersa)
- Support: [supportramsandesh@gmail.com](mailto:supportramsandesh@gmail.com)
- Business: [sanskarin@outlook.in](mailto:sanskarin@outlook.in) and
  [sanskarin.business@gmail.com](mailto:sanskarin.business@gmail.com)
- Contributing: [CONTRIBUTING.md](CONTRIBUTING.md)
- Security reports: [SECURITY.md](SECURITY.md)
- Documentation: [docs/README.md](docs/README.md)

## License

Code is licensed under the [Apache License 2.0](LICENSE). Original bundled
assets are covered as described in [NOTICE](NOTICE) and
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

Made by the Sanskar.
