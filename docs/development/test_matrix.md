# Development test matrix

| Area | Automated coverage | Manual coverage | Current status |
|---|---|---|---|
| Vector math and fixed-step simulation | Unit tests passing | N/A | Automated passed |
| Ball collisions and cushions | Deterministic tests passing | Visual table check | Automated passed |
| Pockets, jaws, scratch, break | Regression tests passing | Shot scenarios | Automated passed |
| 8-ball / 9-ball rules | State-machine tests passing | Full matches | Automated passed |
| Save/load and migrations | Preferences/progress tests passing | Upgrade smoke test | Automated passed |
| Localization | English/Hindi runtime widget test passing | Human translation review | Automated passed; review pending |
| Accessibility | BMC/table semantics widget tests passing | TalkBack and large text | Automated passed; manual pending |
| Android lifecycle/orientation | Widget/integration tests | Emulator/device matrix | Pending |
| Performance | Determinism/timing checks | Profile-mode trace | Pending |
| Release | Dart analyze/validator/debug APK passed locally; CI defined | Flutter delta tests and signed AAB smoke | Blocked by execution quota |

Executed results are recorded in `what_changed.md`; this table never implies a
test passed solely because it is planned.
