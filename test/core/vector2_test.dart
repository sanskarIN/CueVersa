import 'dart:math' as math;

import 'package:cue_versa/features/game/domain/vector2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Vector2', () {
    test('normalization and products are stable', () {
      const vector = Vector2(3, 4);

      expect(vector.length, 5);
      expect(
        vector.normalized.approximatelyEquals(const Vector2(.6, .8)),
        isTrue,
      );
      expect(vector.dot(const Vector2(-4, 3)), 0);
      expect(vector.cross(const Vector2(-4, 3)), 25);
    });

    test('rotation preserves length', () {
      const vector = Vector2(2.5, -7);
      final rotated = vector.rotate(math.pi / 3);

      expect(rotated.length, closeTo(vector.length, 1e-12));
    });

    test('zero normalization remains finite', () {
      expect(const Vector2.zero().normalized, const Vector2.zero());
    });
  });
}
