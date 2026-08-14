# Physics regression governance

Regression inputs use metres, ordered balls, fixed 240 Hz ticks, explicit shot
direction/power/tip offset, and bounded scenario time. Determinism tests compare
two worlds exactly within one runtime; physical calibration tests use documented
tolerances appropriate to measured uncertainty.

Do not loosen a tolerance or delete/skip a scenario merely to make CI green.
Any accepted physics change must include cause, before/after trace, visual/game
impact, rules/AI/replay effects, calibrated evidence, old replay strategy, and a
version decision for future online protocols.

Add scenarios for multi-ball clusters, simultaneous contacts, long banks,
pocket shelf speed/angle, rail spin transfer, stun, combinations, frozen balls,
ball-in-hand placement overlap, and randomized property invariants before beta.
