import 'dart:math' as math;

import 'package:flame/components.dart';

import '../puff_game.dart';
import '../sim/explosion_event.dart';
import '../sim/fx_event.dart';
import '../sim/modifier.dart';
import '../sim/shapes.dart';
import '../tuning.dart';

class _Delayed {
  _Delayed(this.remaining, this.action);
  double remaining;
  final void Function() action;
}

/// Applies the selected modifier on release and runs its per-frame force
/// fields (gravity wells). Lives as a game-level component so its update
/// happens after the physics step.
class ModifierSystem extends Component with HasGameReference<PuffGame> {
  ModifierSystem(this.random);

  final math.Random random;
  ModifierSpec spec = ModifierSpec.pressure;
  final List<GravityWell> wells = [];
  final List<_Delayed> _scheduled = [];

  void schedule(double delay, void Function() action) {
    _scheduled.add(_Delayed(delay, action));
  }

  void reset() {
    wells.clear();
    _scheduled.clear();
  }

  ExplosionEvent release(Vector2 position, double energy, {required bool fizzle}) {
    if (fizzle) {
      return game.detonateAt(position, energy, ExplosionKind.fizzle);
    }
    switch (spec.kind) {
      case ModifierKind.pressure:
        return game.detonateAt(position, energy, ExplosionKind.pressure);
      case ModifierKind.implosion:
        final event = game.detonateAt(
          position,
          energy,
          ExplosionKind.implosion,
          directionSign: -1,
          impulseMultiplier: Tuning.implosionPullMultiplier,
        );
        final origin = position.clone();
        schedule(Tuning.implosionPopDelay, () {
          game.detonateAt(
            origin,
            energy * Tuning.implosionPopFraction,
            ExplosionKind.pressure,
          );
        });
        return event;
      case ModifierKind.magnet:
        return game.detonateAt(
          position,
          energy,
          ExplosionKind.magnet,
          impulseMultiplier: Tuning.magnetMultiplier,
          filter: (shape) => shape.spec.material == ShapeMaterial.metal,
        );
      case ModifierKind.gravityWell:
        final event = game.detonateAt(
          position,
          energy * Tuning.wellPopFraction,
          ExplosionKind.gravityWell,
        );
        wells.add(
          GravityWell(
            position: position.clone(),
            strength: Tuning.wellStrength * (0.4 + energy),
            radius: Tuning.blast.radiusOfEffect(energy) * 0.9,
            duration: Tuning.wellDurationMin + Tuning.wellDurationPerEnergy * energy,
          ),
        );
        return event;
      case ModifierKind.chainSpark:
        final event = game.detonateAt(
          position,
          energy * Tuning.chainBlastFraction,
          ExplosionKind.chainSpark,
        );
        _chain(position, energy);
        return event;
    }
  }

  void _chain(Vector2 origin, double energy) {
    final shapes = game.liveShapes.toList();
    if (shapes.isEmpty) {
      return;
    }
    final points = shapes.map((s) => s.body.position).toList(growable: false);
    final count = (Tuning.chainMinTargets + energy * Tuning.chainTargetsPerEnergy).round();
    final order = chainOrder(origin, points, count);
    final path = [origin.clone()];
    var previous = origin;
    for (final index in order) {
      final shape = shapes[index];
      final p = shape.body.position;
      final dist = p.distanceTo(previous);
      if (dist > Tuning.chainMaxHop) {
        break;
      }
      final dir = dist > 1e-6 ? (p - previous) / dist : Vector2(0, -1);
      final magnitude =
          energy * Tuning.blast.impulseScale * Tuning.chainImpulseFraction;
      final impulse = dir * magnitude;
      shape.applyBlastImpulse(impulse, (random.nextBool() ? 1 : -1) * 0.3 * energy);
      shape.hitFlash = 1;
      game.score.onImpulse(magnitude);
      if (magnitude > shape.spec.breakThreshold && shape.spec.canFracture) {
        shape.pendingFracture = impulse;
      }
      path.add(p.clone());
      previous = p;
    }
    if (path.length > 1) {
      game.emitArc(ArcEvent(points: path, energy: energy));
    }
  }

  @override
  void update(double dt) {
    if (_scheduled.isNotEmpty) {
      final due = <_Delayed>[];
      for (final d in _scheduled) {
        d.remaining -= dt;
        if (d.remaining <= 0) {
          due.add(d);
        }
      }
      _scheduled.removeWhere(due.contains);
      for (final d in due) {
        d.action();
      }
    }
    if (wells.isNotEmpty) {
      final shapes = game.liveShapes;
      for (final well in wells) {
        well.age += dt;
        if (well.expired) {
          continue;
        }
        for (final shape in shapes) {
          final a = well.accelerationAt(shape.body.position);
          if (a.x != 0 || a.y != 0) {
            shape.body.applyForce(a * shape.body.mass);
          }
        }
      }
      wells.removeWhere((w) => w.expired);
    }
  }
}
