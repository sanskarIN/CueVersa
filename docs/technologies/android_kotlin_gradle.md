# Android, Kotlin, Gradle, and JDK

Android is mandatory. The host uses a minimal Kotlin `MainActivity`, Gradle
Kotlin DSL, JDK 17 compatibility, Flutter-managed minimum/compile/target SDK,
64-bit Flutter ABIs, R8 resource/code shrinking for release, cleartext
network denial, and backup/data-transfer exclusions.

Debug APK:

```shell
flutter build apk --debug
```

Release AAB requires credentials injected outside Git; see
`docs/release/signing.md`. Debug signing in the current local release block is
for build validation only and must never sign a Play production artifact.

Upgrade Gradle, Android Gradle Plugin, Kotlin, compile SDK, and target SDK as a
reviewed batch. Run manifest merger inspection, lint/build, emulator smoke,
physical device, R8, install/upgrade, backup, and Play policy checks.

On Windows this repository can live on a different drive from the pub cache.
Kotlin incremental cache path relativization fails across drive roots, so the
project disables Kotlin incremental state and uses the in-process compiler.
Linux CI is unaffected functionally; revisit the workaround after verified
Kotlin/Gradle upgrades.
