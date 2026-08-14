# Development test matrix

| Area | Automated coverage | Manual coverage | Current status |
|---|---|---|---|
| Vector math and fixed-step simulation | Planned unit tests | N/A | Pending |
| Ball collisions and cushions | Planned deterministic tests | Visual table check | Pending |
| Pockets, jaws, scratch, break | Planned regression tests | Shot scenarios | Pending |
| 8-ball / 9-ball rules | Planned state-machine tests | Full matches | Pending |
| Save/load and migrations | Planned unit tests | Upgrade smoke test | Pending |
| Localization | Key-completeness/widget tests | English/Hindi review | Pending |
| Accessibility | Semantics/widget tests | TalkBack and large text | Pending |
| Android lifecycle/orientation | Widget/integration tests | Emulator/device matrix | Pending |
| Performance | Determinism/timing checks | Profile-mode trace | Pending |
| Release | Analyze/test/build CI | Signed AAB smoke test | Pending |

Executed results are recorded in `what_changed.md`; this table never implies a
test passed solely because it is planned.
