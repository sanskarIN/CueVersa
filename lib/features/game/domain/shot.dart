import 'vector2.dart';

final class ShotParameters {
  ShotParameters({
    required Vector2 direction,
    required double power,
    this.tipOffset = const Vector2.zero(),
    this.elevationDegrees = 0,
  }) : direction = direction.normalized,
       power = power.clamp(0, 1),
       assert(direction.lengthSquared > 0, 'Shot direction must be non-zero.'),
       assert(
         elevationDegrees == 0,
         'Elevated cues are disabled until masse physics is implemented.',
       );

  final Vector2 direction;
  final double power;

  /// x = side spin; y = top spin. Both components are clamped at strike time.
  final Vector2 tipOffset;
  final double elevationDegrees;

  double get speedMetresPerSecond => 0.18 + (power * 6.6);
}
