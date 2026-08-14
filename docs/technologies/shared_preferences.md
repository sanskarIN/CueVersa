# shared_preferences

Purpose: persist small, non-secret typed settings and aggregate local progress.
It is not a database, transaction engine, secure keystore, or entitlement
authority.

Preference keys are private to typed controllers. Defaults and range fallback
are tested. Destructive clearing is confirmed in UI. Android backup excludes
preferences in this build.

Do not store passwords, tokens, receipts, personal messages, or server
authority here. Migrate to a versioned local database only when structured
history/relationships justify it.

License: BSD 3-Clause. Resolved platform implementations are locked in
`pubspec.lock`.
