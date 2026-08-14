# Dart

Dart 3.12.2 powers application and pure-domain code. The domain uses explicit
typed state, sealed-enum-style exhaustive switches, immutable vectors, bounded
inputs, and fixed-step arithmetic.

`dart format` is authoritative formatting. `flutter analyze --fatal-infos`
uses `flutter_lints` plus project rules for declared returns, directive order,
resource cleanup, and unawaited futures. `flutter_test` covers pure unit and
widget behavior.

For deterministic code, avoid wall-clock reads, unordered external inputs,
randomness without an explicit seed, and frame-dependent integration. Dart/SDK
upgrades require replay regression comparison, not only compilation.

License: BSD 3-Clause.
