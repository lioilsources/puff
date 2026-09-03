import 'dart:math' as math;

import 'package:flame/components.dart';

import '../components/shape_body.dart';
import '../puff_game.dart';
import '../sim/fracture.dart';
import '../sim/fx_event.dart';
import '../tuning.dart';

Vector2 rotateVector(Vector2 v, double angle) {
  final c = math.cos(angle);
  final s = math.sin(angle);
  return Vector2(v.x * c - v.y * s, v.x * s + v.y * c);
}

/// Turns [ShapeBody.pendingFracture] marks into child bodies (or dust once
/// the body budget is spent). Runs after the physics step.
class FractureSystem extends Component with HasGameReference<PuffGame> {
  FractureSystem(this.random);

  final math.Random random;
  final rules = const FractureRules(
    maxDepth: Tuning.fractureMaxDepth,
    minFragmentSize: Tuning.minFragmentSize,
  );

  @override
  void update(double dt) {
    for (final shape in game.shapes.toList()) {
      final impulse = shape.pendingFracture;
      if (impulse == null) {
        continue;
      }
      shape.pendingFracture = null;
      if (shape.isRemoving || !shape.isLoaded || !shape.body.isValid) {
        continue;
      }
      split(shape, impulse);
    }
  }

  void split(ShapeBody shape, Vector2 worldImpulse) {
    final body = shape.body;
    final angle = body.angle;
    final localImpulse = rotateVector(worldImpulse, -angle);
    final result = rules.fracture(
      spec: shape.spec,
      generation: shape.generation,
      localImpulse: localImpulse,
    );
    if (result.isEmpty) {
      return;
    }
    final position = body.position.clone();
    final velocity = body.linearVelocity.clone();
    final angularVelocity = body.angularVelocity;
    shape.removeFromParent();
    game.score.onFracture();

    var budget = Tuning.maxBodies - game.shapes.length;
    final dust = <Vector2>[];
    for (final fragment in result.fragments) {
      final worldOffset = rotateVector(fragment.offset, angle);
      final childPosition = position + worldOffset;
      final outwardDir = worldOffset.length > 1e-6
          ? worldOffset.normalized()
          : Vector2(random.nextDouble() - 0.5, random.nextDouble() - 0.5).normalized();
      final outward =
          outwardDir * (Tuning.fractureOutwardSpeed * (0.5 + random.nextDouble()));
      // Velocity of the parent at the fragment's location: v + w x r.
      final atPoint =
          velocity +
          Vector2(-angularVelocity * worldOffset.y, angularVelocity * worldOffset.x);
      if (budget <= 0) {
        dust.add(childPosition);
        continue;
      }
      budget--;
      game.world.add(
        ShapeBody(
          spec: fragment.spec,
          position: childPosition,
          velocity: atPoint + outward,
          angle: angle,
          angularVelocity:
              angularVelocity + (random.nextDouble() - 0.5) * Tuning.fractureSpin,
          generation: shape.generation + 1,
        ),
      );
    }
    for (final d in result.dust) {
      dust.add(position + rotateVector(d, angle));
    }
    game.emitFracture(
      FractureEvent(
        position: position,
        kind: shape.spec.kind,
        material: shape.spec.material,
        fragmentCount: result.fragments.length,
        dust: dust,
        velocity: velocity,
      ),
    );
  }
}
