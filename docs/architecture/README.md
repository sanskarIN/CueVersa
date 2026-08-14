# Architecture index

CueVerse separates deterministic gameplay from platform and presentation code.

- `technology_decision.md`: Flutter/Dart selection and rejected alternatives.
- `app_architecture.md`: dependency boundaries, state ownership, and lifecycle.
- `data_model.md`: current preference/progress schema and migrations.
- `online_authority.md`: required future multiplayer trust boundary.

The rule is directional: presentation may call application/domain code; the
physics and rules domain must not import Flutter widgets, Android APIs,
preferences, URL launching, or network clients.
