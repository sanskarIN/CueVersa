# Secure development lifecycle

1. Define assets/data/trust boundaries and abuse cases in design review.
2. Prefer no dependency; otherwise review maintenance, license, advisories,
   transitive graph, binary size, and update path.
3. Validate untrusted input at boundaries and preserve typed invariants inside.
4. Add negative, corruption, replay, authorization, and resource-limit tests.
5. Run analyzer/tests/build, dependency/secret/license scans, and review merged
   Android manifests/artifacts.
6. Sign from protected external credentials with least privilege and retained
   provenance; never from committed material.
7. Monitor published advisories and follow `SECURITY.md` disclosure handling.

Logs must never contain credentials, tokens, full imported user content,
payment receipts, or sensitive device identifiers. Debug tools stay hidden,
local, explicit, and incapable of granting real entitlements.
