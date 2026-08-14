# Application architecture

## Layers

```text
Flutter screens/widgets
        ↓
AppSettings / AppProgress controllers
        ↓
Game orchestration (shot event aggregation, turns, AI inputs)
        ↓
Pure Dart rules + physics + AI geometry
```

`lib/features/game/domain/` owns table-space vectors, balls, rack creation,
fixed-step simulation, rule state machines, game modes, and AI planning. It has
no Flutter dependency. `presentation/` converts pointer/control input into
validated `ShotParameters`, advances the world through a ticker, consumes
events, and paints immutable observations.

`AppSettings` and `AppProgress` are ChangeNotifiers backed by
SharedPreferences. They expose typed mutations, clamp invalid values, and keep
preference keys private. Screens receive controller instances explicitly; no
global service locator is used.

## State and lifecycle

- Preferences load before `runApp`, avoiding visible default-to-saved flicker.
- The game world advances at fixed 240 Hz from elapsed ticker time capped by the
  physics accumulator. Render frequency never becomes the physics step.
- No game state advances while the app has no ticker callbacks; a large resume
  gap is capped at 250 ms.
- Each shot resets an event accumulator. Only cue contact, rail, pocket, scratch,
  and stopped events are converted into a rule `ShotReport`.
- AI outputs the same `ShotParameters` type as a human. It cannot write final
  ball positions or bypass the physics engine.

## Navigation

Material routes are created from explicit user actions. Splash replacement has
zero transition delay. No support card or external-link prompt appears during
gameplay. External HTTPS/mail links require a tap and handle launch failure.

## Extension rules

New stored state needs schema/migration tests. Network code must live behind a
typed repository/service interface and update privacy/security docs. New game
modes should compose the existing world/event model instead of forking physics.
