import 'dart:math' as math;

import 'package:flame_forge2d/flame_forge2d.dart' show Aabb, Vector2;

import '../components/shape_body.dart';
import '../puff_game.dart';
import '../sim/blast.dart';
import '../sim/explosion_event.dart';
import '../tuning.dart';

/// Applies a detonation to every dynamic body in range and reports what
/// happened as an [ExplosionEvent].
class Detonator {
  Detonator(this.game, this.random);

  final PuffGame game;
  final math.Random random;

  /// Every live [ShapeBody] whose body center lies within [radius] of [center].
  List<ShapeBody> bodiesWithin(Vector2 center, double radius) {
    final aabb = Aabb(
      Vector2(center.x - radius, center.y - radius),
      Vector2(center.x + radius, center.y + radius),
    );
    final result = <ShapeBody>[];
    for (final shape in game.world.overlapAabb(aabb)) {
      final data = shape.body.userData;
      if (data is ShapeBody && !data.isRemoving && !result.contains(data)) {
        if (data.body.position.distanceTo(center) <= radius) {
          result.add(data);
        }
      }
    }
    return result;
  }

  ExplosionEvent detonate({
    required Vector2 position,
    required double energy,
    required ExplosionKind kind,
    double directionSign = 1,
    double? radiusOverride,
    double impulseMultiplier = 1,
    bool Function(ShapeBody)? filter,
  }) {
    final radius = radiusOverride ?? Tuning.blast.radiusOfEffect(energy);
    final env = game.environment;
    var hit = 0;
    var total = 0.0;
    for (final target in bodiesWithin(position, radius)) {
      if (filter != null && !filter(target)) {
        continue;
      }
      final result = computeBlast(
        params: Tuning.blast,
        origin: position,
        bodyPos: target.blastPosition,
        energy: energy,
        blastMultiplier: env.blastMultiplier * impulseMultiplier,
        randomSign: random.nextBool() ? 1 : -1,
        radiusOverride: radius,
        directionSign: directionSign,
      );
      if (result == null) {
        continue;
      }
      target.applyBlastImpulse(result.impulse, result.angularImpulse);
      game.score.onImpulse(result.magnitude);
      if (result.magnitude > target.spec.breakThreshold && target.spec.canFracture) {
        target.pendingFracture = result.impulse;
      }
      hit++;
      total += result.magnitude;
    }
    game.score.onBlast();
    return ExplosionEvent(
      position: position.clone(),
      energy: energy,
      kind: kind,
      radius: radius,
      bodiesHit: hit,
      totalImpulse: total,
    );
  }
}
