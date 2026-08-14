# Security policy

## Supported versions

Until the first stable release, only the latest `main` commit and newest tagged
pre-release receive security fixes. Stable support policy will be documented at
1.0.

## Report privately

Do not open a public issue for a vulnerability. Email
`supportramsandesh@gmail.com` with:

- affected commit/version and Android version;
- reproduction steps or a minimal proof of concept;
- impact and required preconditions;
- whether user data, multiplayer integrity, or release signing is involved;
- a safe contact method and desired credit.

Never include real credentials or another person's private data. Expect an
initial acknowledgment target of seven calendar days, not a guaranteed bounty
or disclosure deadline.

## Current security boundary

The current app is offline-first. It has no backend, login, ads, billing,
analytics, cloud save, or remotely granted entitlement. Preferences are not a
secure vault and must not store secrets. Android cleartext traffic is disabled,
backups exclude local state, external links use explicit HTTPS/mail URIs, and
release secrets remain outside Git.

Future online or commerce code requires payload validation, TLS/WSS, rate
limits, authentication/authorization review, server authority, dependency
audit, safe logging, receipt validation, and a threat-model update before merge.
