# Local data model

Current persistence is a small version-zero preference schema. All values are
app-private and non-secret.

| Prefix | Examples | Owner |
|---|---|---|
| `settings.` | theme, locale, high contrast, reduced motion, audio, controls | `AppSettings` |
| `progress.` | XP, matches, wins, streak, shots, successful shots, pots | `AppProgress` |

Derived values such as level, XP-in-level, and shot accuracy are recalculated rather
than redundantly stored. Invalid aim sensitivity is clamped to `[0.5, 2.0]`;
unknown themes/locales fall back to system/English.

## Migration policy

Before adding structured saves, introduce a root integer schema version and a
transactional migration pipeline. Each migration must accept the previous
version, validate types/ranges, write new data before deleting old data, and be
idempotent. Corrupt imports are rejected without overwriting live state.

Export/import is not implemented. A future format requires canonical JSON,
maximum size/depth limits, version checks, checksums/integrity metadata, and
tests for truncation, tampering, unknown fields, downgrade, and rollback.
