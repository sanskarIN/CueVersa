# Android release signing

Never commit keystores, passwords, key aliases, Play service credentials, or
`key.properties`. Repository release builds currently fall back to debug signing
for local R8 validation only; that output is not a production artifact.

## Production process

1. Use Play App Signing and a separately protected upload key where applicable.
2. Store upload keystore/alias/password in an approved credential vault or
   protected CI environment with least privilege, approval, and audit.
3. Inject values only for the release job; prevent command/log/diagnostic echo.
4. Configure Gradle signing from environment or an ignored local properties
   file, fail closed when a production release requests missing values, and
   never silently publish a debug-signed artifact.
5. Build from a clean protected commit, verify certificate fingerprint, inspect
   bundle/manifest, install via bundletool/test track, hash and retain artifact,
   mapping/symbols/provenance, then remove ephemeral credentials.

Document secure recovery/rotation and at least two authorized maintainers where
project governance permits. A lost signing/upload key follows current Play
recovery procedures; never publish it in an issue.
