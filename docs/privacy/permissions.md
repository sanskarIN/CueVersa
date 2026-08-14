# Android permissions

The main manifest declares no dangerous Android runtime permission. External
HTTPS/mail actions use package-visibility `<queries>` entries, which allow
checking/launching handlers but do not grant access to browser or email data.

The current app does not request Internet, notifications, location, camera,
microphone, storage/media, contacts, Bluetooth, phone, SMS, calendar, health,
biometric, or advertising permissions. Flutter tooling/profile manifests may
add development-only capabilities; inspect the merged release manifest before
publication.

Future permission requests need a feature necessity analysis, least-privilege
scope, just-in-time explanation, denial/permanent-denial behavior, settings
recovery, platform policy review, privacy-policy/data-map update, and tests.
