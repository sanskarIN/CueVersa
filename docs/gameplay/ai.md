# Offline AI

The AI receives the cue ball, visible non-pocketed balls, table geometry, and a
set of legal first-contact numbers from rule state. It constructs ghost-ball
pocket candidates, rejects blocked cue/object paths, scores distance, cut angle,
and approximate scratch risk, then emits ordinary direction/power/spin input.

Difficulty changes candidate breadth and bounded execution variance:

- Beginner: broader candidate choice, up to 6.5° aim error.
- Easy: up to 4°.
- Intermediate: up to 2.2°.
- Hard: up to 1.1°.
- Expert: up to 0.45°.
- Master: up to 0.15° plus modest follow where selected.

Seeded planning is deterministic and tested. AI never teleports balls, supplies
a final table state, ignores moving-state input rejection, or changes physics.
Current planner emphasizes direct pots; explicit safety, bank/kick, position
zones, run-out order, break choice, and deeper scratch prediction are roadmap
work.
