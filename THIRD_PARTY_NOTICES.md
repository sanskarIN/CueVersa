# Third-party notices

Last reviewed: 2026-08-14. This inventory must be regenerated and reviewed
before each public release.

## Runtime dependencies

| Component | Purpose | License | Source |
|---|---|---|---|
| Flutter SDK / framework | UI and Android runtime | BSD 3-Clause | `flutter.dev` |
| Dart SDK | Language and tooling | BSD 3-Clause | `dart.dev` |
| Cupertino Icons | Optional icon font | MIT | `pub.dev/packages/cupertino_icons` |
| intl | Plural, number, and locale formatting | BSD 3-Clause | `pub.dev/packages/intl` |
| shared_preferences | Local settings adapter | BSD 3-Clause | `pub.dev/packages/shared_preferences` |
| url_launcher | External HTTPS/mail link launching | BSD 3-Clause | `pub.dev/packages/url_launcher` |

Transitive platform packages are locked in `pubspec.lock`. Flutter exposes
their full license texts through its generated license registry when a license
page is presented. Distribution automation must archive `flutter pub deps` and
the resolved license inventory for the released commit.

## Development-only dependencies

`flutter_test`, `flutter_lints`, and their transitive packages are used to
build and verify CueVerse. They are not intentionally bundled as CueVerse-owned
code. Consult the matching SDK or pub.dev package license for each locked
version.

## Assets

All current CueVerse branding SVGs are original project assets. The repository
does not include paid stock assets, commercial pool-game assets, copied table
art, or Buy Me a Coffee logo artwork. Material Symbols rendered by Flutter are
covered by the Android Open Source Project / Material icon licensing terms.

## Release review

Before shipping, run the dependency inventory, inspect every newly resolved
package license, update this file, and block release for missing, incompatible,
or ambiguous terms. Apache-2.0 compatibility is a release gate, not an
assumption that future dependencies are automatically compatible.
