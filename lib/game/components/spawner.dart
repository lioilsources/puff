import 'dart:math' as math;

import 'package:flame/components.dart';

import '../puff_game.dart';
import '../sim/heat.dart';
import '../sim/shapes.dart';
import '../tuning.dart';
import 'shape_body.dart';

/// Emits shapes from just outside the screen edges, aimed roughly at the
/// center. Spawn rate ramps up with elapsed time; what is spawned grows with
/// the run's heat: bigger and faster shapes, then a Kolos now and again, then
/// volleys from one edge.
class Spawner extends Component with HasGameReference<PuffGame> {
  Spawner(this.random);

  final math.Random random;
  double _elapsed = 0;
  double _cooldown = 0.2;
  int _burstLeft = Tuning.spawnInitialBurst;

  /// Seconds until the next Kolos, counted only while it is hot enough.
  double kolosIn = 0;
  double _volleyIn = Tuning.volleyInterval / 3;
  int _volleyLeft = 0;
  int _volleyEdge = 0;
  double _volleyGap = 0;

  void reset() {
    _elapsed = 0;
    _cooldown = 0.2;
    _burstLeft = Tuning.spawnInitialBurst;
    kolosIn = 0;
    _volleyIn = Tuning.volleyInterval / 3;
    _volleyLeft = 0;
  }

  double get interval {
    final heat = game.heat;
    if (heat > 1) {
      return heatLerp(heat, 0, Tuning.spawnIntervalMin, Tuning.spawnIntervalOver);
    }
    final t = (_elapsed / Tuning.spawnRampSeconds).clamp(0.0, 1.0);
    return Tuning.spawnIntervalStart +
        (Tuning.spawnIntervalMin - Tuning.spawnIntervalStart) * t;
  }

  /// Room for a Kolos' fragments or a volley on top of what is alive.
  bool get _hasReserve =>
      game.shapes.length < Tuning.maxBodies - Tuning.heatBodyReserve;

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
    final heat = game.heat;
    if (heat >= Tuning.kolosFromHeat) {
      kolosIn -= dt;
      if (kolosIn <= 0 && _hasReserve) {
        spawnKolos();
        kolosIn = heatLerp(
          heat,
          Tuning.kolosInterval,
          Tuning.kolosInterval,
          Tuning.kolosIntervalOver,
        );
      }
    }
    if (game.tier >= 3) {
      _volleyIn -= dt;
      if (_volleyIn <= 0 && _hasReserve) {
        _volleyLeft =
            Tuning.volleyMin +
            random.nextInt(Tuning.volleyMax - Tuning.volleyMin + 1);
        _volleyEdge = random.nextInt(4);
        _volleyGap = 0;
        _volleyIn = heatLerp(
          heat,
          Tuning.volleyInterval,
          Tuning.volleyInterval,
          Tuning.volleyIntervalOver,
        );
      }
    }
    if (_volleyLeft > 0) {
      _volleyGap -= dt;
      if (_volleyGap <= 0) {
        spawnOne(edge: _volleyEdge);
        _volleyLeft--;
        _volleyGap = Tuning.volleyGap;
      }
    }
  }

  /// A point just outside [edge] (0 top, 1 right, 2 bottom, 3 left).
  Vector2 _edgePoint(int edge, double margin) {
    final half = game.worldSize / 2;
    final t = random.nextDouble() * 2 - 1;
    return switch (edge) {
      0 => Vector2(t * half.x, -half.y - margin),
      1 => Vector2(half.x + margin, t * half.y),
      2 => Vector2(t * half.x, half.y + margin),
      _ => Vector2(-half.x - margin, t * half.y),
    };
  }

  Vector2 _towardCenter(Vector2 position, double jitter, double speed) {
    final toCenter = -position;
    final angle =
        math.atan2(toCenter.y, toCenter.x) +
        (random.nextDouble() * 2 - 1) * jitter;
    return Vector2(math.cos(angle), math.sin(angle)) * speed;
  }

  void spawnOne({int? edge}) {
    if (game.shapes.length >= Tuning.maxBodies) {
      return;
    }
    final heat = game.heat;
    final position = _edgePoint(edge ?? random.nextInt(4), Tuning.spawnMargin);
    final speedMax = heatLerp(
      heat,
      Tuning.spawnSpeedMax,
      Tuning.spawnSpeedMaxHot,
      Tuning.spawnSpeedMaxOver,
    );
    final speed =
        Tuning.spawnSpeedMin +
        random.nextDouble() * (speedMax - Tuning.spawnSpeedMin);
    final spec = game.shapeFactory.next(
      minSize: heatLerp(
        heat,
        Tuning.shapeMinSize,
        Tuning.shapeMinSizeHot,
        Tuning.shapeMinSizeOver,
      ),
      maxSize: heatLerp(
        heat,
        Tuning.shapeMaxSize,
        Tuning.shapeMaxSizeHot,
        Tuning.shapeMaxSizeOver,
      ),
      metalChance: heatLerp(
        heat,
        Tuning.metalChance,
        Tuning.metalChanceHot,
        Tuning.metalChanceOver,
      ),
    );
    game.world.add(
      ShapeBody(
        spec: spec,
        position: position,
        velocity: _towardCenter(position, Tuning.spawnAngleJitter, speed),
        angle: random.nextDouble() * math.pi * 2,
        angularVelocity: (random.nextDouble() * 2 - 1) * 1.5,
      ),
    );
  }

  /// One huge polygon, slow and far too heavy to push away: it has to be
  /// cracked, and its pieces crack once more than anything else does.
  void spawnKolos() {
    final heat = game.heat;
    final env = game.environment;
    final size =
        Tuning.kolosSizeMin +
        random.nextDouble() *
            (heatLerp(heat, Tuning.kolosSizeMax, Tuning.kolosSizeMax, Tuning.kolosSizeOver) -
                Tuning.kolosSizeMin);
    // As far out as a shape may be without being despawned on arrival.
    final margin = math.min(size + 0.2, Tuning.despawnMargin - 0.1);
    final position = _edgePoint(random.nextInt(4), margin);
    // A damped body coasts speed / damping meters: without a push that
    // carries it well inside, it would come to rest outside the screen.
    final speed = math.max(
      Tuning.kolosSpeedMin +
          random.nextDouble() * (Tuning.kolosSpeedMax - Tuning.kolosSpeedMin),
      (margin + Tuning.kolosReach) * env.linearDamping,
    );
    game.world.add(
      ShapeBody(
        spec: ShapeSpec(
          kind: ShapeKind.poly,
          size: size,
          sides: 7 + random.nextInt(2),
          breakThreshold: Tuning.kolosBreak * env.blastMultiplier,
        ),
        position: position,
        velocity: _towardCenter(position, Tuning.spawnAngleJitter * 0.3, speed),
        angle: random.nextDouble() * math.pi * 2,
        angularVelocity: (random.nextDouble() * 2 - 1) * 0.4,
        fractureDepth: Tuning.kolosFractureDepth,
      ),
    );
  }
}
