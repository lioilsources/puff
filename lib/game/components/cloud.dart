import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart' show Aabb;

import '../fx/shaders.dart';
import '../puff_game.dart';
import '../sim/energy.dart';
import '../tuning.dart';
import 'shape_body.dart';

/// The charging pressure cloud under the player's finger.
///
/// Not a physics body: it queries the world each frame for bodies inside its
/// radius (drain + "what's inside") which is cheaper and simpler than
/// recreating a sensor shape every time the radius changes.
class Cloud extends PositionComponent with HasGameReference<PuffGame> {
  Cloud({required Vector2 position, required this.random})
    : target = position.clone(),
      charge = Charge(
        curve: Tuning.energyCurve,
        tOverpressure: Tuning.tOverpressure,
        overpressurePenalty: Tuning.overpressurePenalty,
        drainRate: Tuning.drainRate,
      ),
      super(position: position, anchor: Anchor.center, priority: 10);

  final math.Random random;
  final Charge charge;

  /// Where the finger is; the cloud lerps toward it with radius-based lag.
  final Vector2 target;

  double radius = Tuning.cloudRMin;
  double time = 0;

  /// Bodies currently inside the cloud (refreshed every frame).
  final List<ShapeBody> inside = [];

  final _jitter = Vector2.zero();
  bool _detonated = false;

  final _rim = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.05;
  final _fill = Paint()..style = PaintingStyle.fill;
  final _tmpLower = Vector2.zero();
  final _tmpUpper = Vector2.zero();
  final _shaderPaint = Paint();
  FragmentShader? _shader;

  double get energy => charge.energy;

  @override
  void onMount() {
    super.onMount();
    _shader = game.shaders?.cloud.fragmentShader();
  }

  @override
  void update(double dt) {
    if (_detonated) {
      return;
    }
    time += dt;
    _refreshInside();
    charge.tick(dt, drainingBodies: inside.length);
    radius = Tuning.cloudRMin + (Tuning.cloudRMax - Tuning.cloudRMin) * energy;

    final lag = Tuning.lagBase + Tuning.lagPerRadius * radius;
    final k = 1 - math.exp(-dt / lag);
    position.x += (target.x - position.x) * k;
    position.y += (target.y - position.y) * k;

    if (charge.drainedThisTick) {
      final amp = 0.03 + 0.02 * inside.length;
      _jitter.setValues(
        (random.nextDouble() * 2 - 1) * amp,
        (random.nextDouble() * 2 - 1) * amp,
      );
    } else {
      _jitter.scale(0.6);
    }

    if (charge.overpressured) {
      _detonated = true;
      game.onOverpressure(this);
    }
  }

  void _refreshInside() {
    inside.clear();
    _tmpLower.setValues(position.x - radius, position.y - radius);
    _tmpUpper.setValues(position.x + radius, position.y + radius);
    final shapes = game.world.overlapAabb(Aabb(_tmpLower, _tmpUpper));
    for (final shape in shapes) {
      final data = shape.body.userData;
      if (data is ShapeBody && !inside.contains(data)) {
        final d = data.body.position.distanceTo(position);
        if (d < radius + data.spec.size * 0.6) {
          inside.add(data);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Local origin is the cloud center (anchor center, zero size).
    final palette = game.palette;
    final e = energy;
    final op = charge.overpressureProgress;
    final center = Offset(_jitter.x, _jitter.y);
    final shader = _shader;
    if (shader != null) {
      UniformWriter(shader)
        ..v2(_jitter.x, _jitter.y)
        ..f(radius)
        ..f(e)
        ..f(time)
        ..f(op)
        ..f(charge.drainedThisTick ? 1 : 0)
        ..color(palette.primary)
        ..color(palette.glow)
        ..color(palette.hazard);
      _shaderPaint.shader = shader;
      canvas.drawRect(
        Rect.fromCircle(center: center, radius: radius * 1.15),
        _shaderPaint,
      );
      return;
    }
    final pulse = 0.5 + 0.5 * math.sin(time * (4 + 10 * e));
    final near = op > 0.8 ? (random.nextDouble() < op ? 1.0 : 0.3) : 1.0;

    _fill.color = palette.primary.withValues(alpha: 0.10 + 0.20 * e);
    canvas.drawCircle(center, radius, _fill);
    _fill.color = palette.glow.withValues(alpha: 0.12 + 0.25 * e * pulse);
    canvas.drawCircle(center, radius * 0.55, _fill);

    _rim.color = Color.lerp(
      palette.primary,
      palette.hazard,
      op > 0.6 ? (op - 0.6) / 0.4 : 0,
    )!.withValues(alpha: (0.5 + 0.5 * pulse) * near);
    _rim.strokeWidth = 0.03 + 0.05 * e;
    canvas.drawCircle(center, radius, _rim);
  }
}
