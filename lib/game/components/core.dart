import 'dart:math' as math;
import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';

import '../puff_game.dart';
import '../tuning.dart';
import 'shape_body.dart';

/// The thing you protect (LoseRule.core). A kinematic sensor at the origin:
/// shapes that reach it are consumed and cost one hit point.
class Core extends BodyComponent<PuffGame> with ContactCallbacks {
  Core() : super(renderBody: false, priority: 5);

  double time = 0;
  double hitFlash = 0;

  final _ring = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.05;
  final _fill = Paint()..style = PaintingStyle.fill;
  final _segment = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.06
    ..strokeCap = StrokeCap.round;

  @override
  Body createBody() {
    final body = world.createBody(
      BodyDef(type: BodyType.kinematic, userData: this),
    );
    body.createShape(
      Circle(radius: Tuning.coreRadius),
      ShapeDef(isSensor: true, enableSensorEvents: true, userData: this),
    );
    return body;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is ShapeBody && !other.isRemoving) {
      hitFlash = 1;
      game.onCoreHit(other);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    time += dt;
    if (hitFlash > 0) {
      hitFlash = math.max(0, hitFlash - dt * 3);
    }
  }

  @override
  void render(Canvas canvas) {
    final palette = game.palette;
    final r = Tuning.coreRadius;
    final pulse = 0.5 + 0.5 * math.sin(time * 2.2);
    _fill.color = Color.lerp(palette.accent, palette.hazard, hitFlash)!
        .withValues(alpha: 0.08 + 0.08 * pulse + 0.4 * hitFlash);
    canvas.drawCircle(Offset.zero, r * (1.1 + 0.1 * pulse), _fill);
    _ring.color = Color.lerp(palette.accent, palette.hazard, hitFlash)!;
    canvas.drawCircle(Offset.zero, r * 0.35, _ring);

    // HP segments around the ring.
    final hp = game.coreHp;
    final max = Tuning.coreHp;
    final gap = 0.18;
    final span = (2 * math.pi - max * gap) / max;
    for (var i = 0; i < max; i++) {
      final start = -math.pi / 2 + i * (span + gap);
      _segment.color = i < hp
          ? palette.accent
          : palette.hazard.withValues(alpha: 0.25);
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: r),
        start,
        span,
        false,
        _segment,
      );
    }
  }
}
