# CueVerse physics model

CueVerse uses a custom deterministic 2D simulation in metres. Physics advances
at 240 fixed ticks per second; render-frame durations only feed an accumulator.
The table is 2.54 m × 1.27 m by default, with 57.15 mm balls.

## Implemented model

- Equal-mass impulse-based ball collisions with measured-style restitution.
- Penetration correction and a bounded tangential throw approximation.
- Rolling deceleration and surface-slip coupling.
- Top spin, back spin/draw, follow, and axial side spin.
- Restituting rail contacts with bounded side-spin deflection.
- Six pocket throats with inward-motion capture and grazing rejection.
- Scratch, object-pocket, cushion, contact, and all-stopped events.
- Ordered 8-ball and 9-ball racks with deterministic placement.

The simulation does not currently model cue elevation, swerve, masse, cloth
nap, ball deformation, or a complete 3D pocket shelf. Cue elevation is rejected
at the shot-input boundary instead of pretending to simulate it.

## Determinism and online authority

Matching engine versions, rack inputs, and shot parameters reproduce matching
states in the regression suite. This is an engineering property, not an
anti-cheat guarantee. A future competitive service must accept validated shot
parameters, run or verify the authoritative simulation, rate-limit clients, and
never trust a client-submitted final table state.

## Regression scenarios

The executable suite covers head-on and cut collisions, one- and two-rail
responses, draw/follow/side spin, pocket-jaw rejection, scratch, break spread,
fixed-step frame independence, and exact repeated-world comparison. Tolerances
are scenario-specific and must be revisited only with documented calibration.
