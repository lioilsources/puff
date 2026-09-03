import 'dart:math' as math;

import 'package:flame/components.dart';

import '../puff_game.dart';
import '../tuning.dart';
import 'shape_body.dart';

/// Emits shapes from just outside the screen edges, aimed roughly at the
/// center. Spawn rate ramps up with elapsed time.
class Spawner extends Component with HasGameReference<PuffGame> {
  Spawner(this.random);

  final math.Random random;
  double _elapsed = 0;
  double _cooldown = 0.2;
  int _burstLeft = Tuning.spawnInitialBurst;

  void reset() {
    _elapsed = 0;
    _cooldown = 0.2;
    _burstLeft = Tuning.spawnInitialBurst;
  }

  double get interval {
    final t = (_elapsed / Tuning.spawnRampSeconds).clamp(0.0, 1.0);
    return Tuning.spawnIntervalStart +
        (Tuning.spawnIntervalMin - Tuning.spawnIntervalStart) * t;
  }

  @override
  void update(double dt) {
    if (!game.isPlaying) {
      return;
    }
    _elapsed += dt;
    _cooldown -= dt;
    if (_cooldown <= 0) {
      spawnOne();
      _cooldown = _burstLeft > 0 ? 0.35 : interval;
      if (_burstLeft > 0) {
        _burstLeft--;
      }
    }
  }

  void spawnOne() {
    if (game.shapes.length >= Tuning.maxBodies) {
      return;
    }
    final half = game.worldSize / 2;
    final m = Tuning.spawnMargin;
    final edge = random.nextInt(4);
    final t = random.nextDouble() * 2 - 1;
    final position = switch (edge) {
      0 => Vector2(t * half.x, -half.y - m),
      1 => Vector2(half.x + m, t * half.y),
      2 => Vector2(t * half.x, half.y + m),
      _ => Vector2(-half.x - m, t * half.y),
    };
    final toCenter = -position;
    final baseAngle = math.atan2(toCenter.y, toCenter.x);
    final angle =
        baseAngle + (random.nextDouble() * 2 - 1) * Tuning.spawnAngleJitter;
    final speed =
        Tuning.spawnSpeedMin +
        random.nextDouble() * (Tuning.spawnSpeedMax - Tuning.spawnSpeedMin);
    final velocity = Vector2(math.cos(angle), math.sin(angle)) * speed;
    final spec = game.shapeFactory.next(
      minSize: Tuning.shapeMinSize,
      maxSize: Tuning.shapeMaxSize,
    );
    game.world.add(
      ShapeBody(
        spec: spec,
        position: position,
        velocity: velocity,
        angle: random.nextDouble() * math.pi * 2,
        angularVelocity: (random.nextDouble() * 2 - 1) * 1.5,
      ),
    );
  }
}
