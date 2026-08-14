# Threat model

- Version: 1
- Scope: offline Flutter client and public source repository
- Last reviewed: 2026-08-14

## Assets and trust boundaries

Assets: deterministic match integrity, local progress/settings, source/release
integrity, creator/support destinations, future rankings/entitlements, and user
trust. Current boundaries are touch input → Flutter UI → typed shot/settings
input → pure domain/persistence; app → Android external URI handler; contributor
→ GitHub/CI; release maintainer → external signing store.

## Current threats and controls

| Threat | Current control | Residual risk/action |
|---|---|---|
| Malformed control values | Clamp power, tip offset, sensitivity; typed rules | Add fuzz/property tests |
| Local preference tampering | Values treated as non-authoritative; fallback/clamp | Progress can be edited on rooted devices; acceptable offline |
| Malicious dynamic URL | All URIs compile-time controlled HTTPS/mailto | Add host allowlist before remote config |
| Cleartext interception | Android cleartext disabled | No current networking |
| Secret/signing leak | Git ignores key material; docs require external injection | Add secret scanning/protected environments |
| Dependency compromise | Lockfile, Dependabot, CodeQL, notice review | Add release SBOM/license audit |
| Copied/unlicensed assets | Original programmatic art and asset register | Review every future contribution |
| Client cheats in future online play | No online/ranked claim; authority design documented | Server simulation mandatory |
| Data exposure through backup | Preferences/databases excluded | Verify merged manifest/device behavior |
| Diagnostic secret exposure | Current diagnostics local and contain no secrets | Keep production logs redacted |

## Future online STRIDE priorities

- Spoofing: authenticated short-lived sessions and room membership checks.
- Tampering: server-authoritative shots, versioned canonical serialization,
  signatures/sequence numbers, idempotency, purchase verification.
- Repudiation: bounded privacy-reviewed event audit with clock/identity integrity.
- Information disclosure: TLS/WSS, minimal payloads, log redaction, access control,
  encryption/key management appropriate to service data.
- Denial of service: per-IP/account/room rate limits, quotas, timeouts, backpressure,
  circuit breakers, capacity testing.
- Elevation of privilege: deny-by-default roles, isolated admin tooling, MFA,
  change audit, least privilege, environment separation.

## Review triggers

Re-review for authentication, networking, imports, purchases, ads/analytics,
notifications, cloud save, leaderboards, new permissions, native code, remote
configuration, signing changes, or a high-severity dependency advisory.
