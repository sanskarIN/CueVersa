# Development test matrix

| Area | Automated coverage | Manual coverage | Current status |
|---|---|---|---|
| Vector math and fixed-step simulation | Unit tests passing | N/A | Automated passed |
| Ball collisions and cushions | Deterministic tests passing | Visual table check | Automated passed |
| Pockets, jaws, scratch, break | Regression tests passing | Shot scenarios | Automated passed |
| 8-ball / 9-ball rules | State-machine tests passing | Full matches | Automated passed |
| Save/load and migrations | Planned unit tests | Upgrade smoke test | Pending |
| Localization | Key-completeness/widget tests | English/Hindi review | Pending |
| Accessibility | Semantics/widget tests | TalkBack and large text | Pending |
| Android lifecycle/orientation | Widget/integration tests | Emulator/device matrix | Pending |
| Performance | Determinism/timing checks | Profile-mode trace | Pending |
| Release | Analyze/test/build CI | Signed AAB smoke test | Pending |

Executed results are recorded in `what_changed.md`; this table never implies a
test passed solely because it is planned.
