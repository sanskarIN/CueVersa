# Technology inventory

Every major technology is documented here with purpose, setup, debugging,
licensing, and upgrade policy.

- `flutter.md` — UI/runtime and Android artifact toolchain
- `dart.md` — domain language, analyzer, formatter, and tests
- `android_kotlin_gradle.md` — Android host, Kotlin activity, Gradle, JDK 17
- `shared_preferences.md` — local settings/progress adapter
- `url_launcher.md` — user-initiated external HTTPS/mail actions

Locked versions live in `pubspec.lock` and Android wrapper/plugin files. New
libraries require a maintenance, security, binary-size, necessity, and license
review before addition.
