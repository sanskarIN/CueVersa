# Manual Android matrix

Test at least one representative physical low/mid device and current emulator,
plus available high-density/tablet/foldable coverage.

- Android API 23 minimum install/start where supported by the toolchain.
- Current target API emulator and current Play-relevant Android release.
- arm64 release artifact; debug emulator architecture as appropriate.
- Cold/warm start, process death, background/resume during aim/rolling/dialog,
  incoming interruption, screen lock, orientation, split screen, and low memory.
- Light/dark/system/high contrast, English/Hindi, 100/150/200% text, display size,
  TalkBack, Switch Access, reduced motion, haptics/sounds off, left-handed layout.
- Every mode/route/dialog/external link, offline link failure, destructive data
  confirmation, developer unlock/reset, and BMC absence during gameplay.
- Profile-mode frame/timeline, jank, CPU, memory, thermal, and battery notes.
- R8 AAB installed through bundle tooling, upgrade from prior build, clear data,
  backup exclusion, merged permissions, and Play pre-launch report.

Record device model, Android/API, build SHA/version, artifact hash, date, tester,
result, evidence, defect links, and retest.
