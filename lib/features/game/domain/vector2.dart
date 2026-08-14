import 'dart:math' as math;

/// Lightweight immutable 2D vector used by the deterministic simulation.
///
/// Coordinates are metres in table space: +x points toward the foot rail and
/// +y points toward the lower long rail.
final class Vector2 {
  const Vector2(this.x, this.y);

  const Vector2.zero() : x = 0, y = 0;

  factory Vector2.fromAngle(double radians, [double magnitude = 1]) {
    return Vector2(
      math.cos(radians) * magnitude,
      math.sin(radians) * magnitude,
    );
  }

  final double x;
  final double y;

  double get lengthSquared => (x * x) + (y * y);
  double get length => math.sqrt(lengthSquared);

  Vector2 get normalized {
    final magnitude = length;
    return magnitude <= 1e-12 ? const Vector2.zero() : this / magnitude;
  }

  Vector2 get perpendicular => Vector2(-y, x);

  double dot(Vector2 other) => (x * other.x) + (y * other.y);

  double cross(Vector2 other) => (x * other.y) - (y * other.x);

  double distanceTo(Vector2 other) => (this - other).length;

  Vector2 rotate(double radians) {
    final cosine = math.cos(radians);
    final sine = math.sin(radians);
    return Vector2((x * cosine) - (y * sine), (x * sine) + (y * cosine));
  }

  Vector2 clampMagnitude(double maximum) {
    final magnitudeSquared = lengthSquared;
    if (magnitudeSquared <= maximum * maximum) {
      return this;
    }
    return normalized * maximum;
  }

  Vector2 withLength(double magnitude) => normalized * magnitude;

  Vector2 operator +(Vector2 other) => Vector2(x + other.x, y + other.y);

  Vector2 operator -(Vector2 other) => Vector2(x - other.x, y - other.y);

  Vector2 operator -() => Vector2(-x, -y);

  Vector2 operator *(double scalar) => Vector2(x * scalar, y * scalar);

  Vector2 operator /(double scalar) => Vector2(x / scalar, y / scalar);

  bool approximatelyEquals(Vector2 other, {double tolerance = 1e-9}) {
    return (x - other.x).abs() <= tolerance && (y - other.y).abs() <= tolerance;
  }

  @override
  bool operator ==(Object other) {
    return other is Vector2 && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() =>
      'Vector2(${x.toStringAsFixed(5)}, ${y.toStringAsFixed(5)})';
}

extension ScalarVectorMultiplication on num {
  Vector2 operator *(Vector2 vector) => vector * toDouble();
}
