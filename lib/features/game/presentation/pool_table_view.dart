import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../domain/ball.dart';
import '../domain/physics_world.dart';
import '../domain/vector2.dart';

class PoolTableView extends StatelessWidget {
  const PoolTableView({
    required this.world,
    required this.aimDirection,
    required this.showAimGuide,
    required this.semanticsLabel,
    required this.onAimChanged,
    super.key,
  });

  final PhysicsWorld world;
  final Vector2 aimDirection;
  final bool showAimGuide;
  final String semanticsLabel;
  final ValueChanged<Vector2> onAimChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      image: true,
      label: semanticsLabel,
      child: AspectRatio(
        aspectRatio: 2,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (details) => _updateAim(details.localPosition, size),
              onPanUpdate: (details) => _updateAim(details.localPosition, size),
              child: CustomPaint(
                painter: PoolTablePainter(
                  world: world,
                  aimDirection: aimDirection,
                  showAimGuide: showAimGuide,
                  highContrast: MediaQuery.highContrastOf(context),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _updateAim(Offset position, Size size) {
    if (world.cueBall.isPocketed) return;
    final tablePoint = Vector2(
      position.dx / size.width * world.table.width,
      position.dy / size.height * world.table.height,
    );
    final direction = tablePoint - world.cueBall.position;
    if (direction.length > world.table.ballRadius) {
      onAimChanged(direction.normalized);
    }
  }
}

final class PoolTablePainter extends CustomPainter {
  const PoolTablePainter({
    required this.world,
    required this.aimDirection,
    required this.showAimGuide,
    required this.highContrast,
  });

  final PhysicsWorld world;
  final Vector2 aimDirection;
  final bool showAimGuide;
  final bool highContrast;

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / world.table.width;
    final ballRadius = world.table.ballRadius * scaleX;
    final tableRect = Offset.zero & size;

    canvas.drawRRect(
      RRect.fromRectAndRadius(tableRect, Radius.circular(size.height * .055)),
      Paint()..color = const Color(0xFF5A3825),
    );
    final rail = math.max(10.0, size.height * .065);
    final feltRect = tableRect.deflate(rail);
    canvas.drawRRect(
      RRect.fromRectAndRadius(feltRect, Radius.circular(size.height * .035)),
      Paint()
        ..color = highContrast
            ? const Color(0xFF006047)
            : const Color(0xFF087A62),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(feltRect, Radius.circular(size.height * .035)),
      Paint()
        ..color = const Color(0xFF9FFFE4).withValues(alpha: .25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    for (final pocket in world.table.pockets) {
      final center = _toCanvas(pocket.center, size);
      canvas.drawCircle(
        center,
        pocket.radius * scaleX,
        Paint()..color = const Color(0xFF071016),
      );
    }

    if (showAimGuide && !world.cueBall.isPocketed && world.isAtRest) {
      final start = _toCanvas(world.cueBall.position, size);
      final end =
          start +
          Offset(aimDirection.x * size.width, aimDirection.y * size.width) *
              .42;
      canvas.drawLine(
        start,
        end,
        Paint()
          ..color = Colors.white.withValues(alpha: .76)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(end, 4, Paint()..color = const Color(0xFFF7C948));
    }

    for (final ball in world.balls) {
      if (ball.isPocketed) continue;
      _paintBall(canvas, ball, _toCanvas(ball.position, size), ballRadius);
    }
  }

  Offset _toCanvas(Vector2 point, Size size) {
    return Offset(
      point.x / world.table.width * size.width,
      point.y / world.table.height * size.height,
    );
  }

  void _paintBall(Canvas canvas, PoolBall ball, Offset center, double radius) {
    final color = _ballColor(ball.number);
    canvas.drawCircle(
      center + Offset(radius * .08, radius * .12),
      radius * 1.04,
      Paint()..color = Colors.black.withValues(alpha: .25),
    );
    canvas.drawCircle(center, radius, Paint()..color = color);
    if (ball.number > 8) {
      final stripe = Rect.fromCenter(
        center: center,
        width: radius * 2,
        height: radius * .85,
      );
      canvas.save();
      canvas.clipPath(
        Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
      );
      canvas.drawRect(stripe, Paint()..color = Colors.white);
      canvas.restore();
    }
    if (ball.number != 0) {
      canvas.drawCircle(center, radius * .47, Paint()..color = Colors.white);
      final painter = TextPainter(
        text: TextSpan(
          text: '${ball.number}',
          style: TextStyle(
            color: Colors.black,
            fontSize: radius * .7,
            fontWeight: FontWeight.w900,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        center - Offset(painter.width / 2, painter.height / 2),
      );
    } else {
      canvas.drawCircle(
        center - Offset(radius * .3, radius * .3),
        radius * .17,
        Paint()..color = Colors.white.withValues(alpha: .75),
      );
    }
  }

  Color _ballColor(int number) {
    return switch (number) {
      0 => const Color(0xFFF8F7EE),
      1 || 9 => const Color(0xFFF7C948),
      2 || 10 => const Color(0xFF2D6CDF),
      3 || 11 => const Color(0xFFD43D51),
      4 || 12 => const Color(0xFF7656B5),
      5 || 13 => const Color(0xFFF08A24),
      6 || 14 => const Color(0xFF15945F),
      7 || 15 => const Color(0xFF7D2638),
      8 => const Color(0xFF15191D),
      _ => Colors.grey,
    };
  }

  @override
  bool shouldRepaint(PoolTablePainter oldDelegate) => true;
}
