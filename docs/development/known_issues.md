# Known issues

## Open

1. Free ball-in-hand placement and explicit called-pocket selection are not yet
   integrated into the interactive match UI; current scratch reset and automatic
   8-ball call behavior are documented beta limitations.
2. Stored aim sensitivity is range-validated and persistent but not yet applied
   to a separate fine-aim control path.
3. Challenges, missions, achievements, and cosmetics are foundation screens;
   persistent unlock/content models are not implemented.
4. Online rooms, matchmaking, ranked play, store, ads, purchases, cloud save,
   straight pool, trick shots, time attack, target challenge, and shot review
   are future work, not shipped features.
5. Store publishing requires external release credentials and a signed AAB
   smoke test; no credential is present in the repository.
6. Android SDK tooling reported that one installed command-line component only
   understands SDK XML through version 3 while encountering version 4. The
   debug build still completed; align Android Studio/command-line tools.
7. The Flutter launcher prints a Windows `Zone.Identifier` cleanup warning in
   this development environment; Flutter continues normally.
8. After the successful debug build, the execution approval service reported a
   usage limit until 2026-08-20 15:01 local time. This currently blocks the
   release AAB, post-hardening Flutter test rerun, and GitHub push from this
   environment; prior full tests and the latest Dart analyzer/project validator
   results remain recorded separately.

## Resolved

- 2026-08-14: Replaced Flutter scaffold launcher PNGs with original legacy
  vector and adaptive Android icons plus an original native splash mark.
- 2026-08-14: Repaired cross-drive Kotlin incremental-cache failures by using
  the in-process non-incremental compiler for this Windows workspace. A clean
  debug APK then built successfully.
- 2026-08-14: Corrected “shot accuracy” to successful potting shots divided by
  total shots; total potted balls remains a separate statistic.

Issues are never removed from this file without a resolution entry and date.
