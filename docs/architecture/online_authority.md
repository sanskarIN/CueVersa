# Future online authority

No online service is shipped. This document is a required boundary for future
work, not a claim that multiplayer exists.

## Trust model

The client may submit room identity, authenticated player identity, engine
protocol version, ordered shot number, aim direction, normalized power, tip
offset, and an idempotency token. It must never be trusted to submit a final
table state, winner, currency, ranking, entitlement, or authoritative timer.

The service validates turn ownership, input ranges, rate limits, monotonic shot
ordering, rack/rule version, and entitlement-independent ranked physics. It then
runs the canonical simulation or verifies a deterministic trace, signs the
result, persists it transactionally, and broadcasts the accepted event.

## Required controls

- TLS/WSS, short-lived authenticated sessions, replay protection, rate limits,
  payload size/schema validation, and safe logs.
- Match reconnect snapshots with signed sequence/version, not client authority.
- Equal aim assistance and normalized cue statistics in ranked play.
- Abuse reporting, moderation, operational alerts, backups, incident response,
  data deletion/retention workflows, and region/privacy review.
- Compatibility tests across every supported client/server runtime before an
  engine version enters ranked rotation.

Private rooms should precede casual matchmaking; ranked play is last and stays
disabled until security, fairness, load, and deterministic gates pass.
