import 'dart:math' as math;

import 'package:flame/components.dart';

import '../palette.dart';
import '../puff_game.dart';
import '../sim/environment.dart';
import '../sim/explosion_event.dart';
import '../sim/fx_event.dart';
import '../sim/shapes.dart';
import '../tuning.dart';
import 'arcs.dart';
import 'particles.dart';
import 'screen_shake.dart';

/// Routes gameplay events to particles, arcs, shockwaves, shake and flashes.
class FxSystem extends Component with HasGameReference<PuffGame> {
  FxSystem(this.random)
    : particles = ParticleSystem(random),
      arcs = ArcLayer(random),
      shake = ScreenShake(random);

  final math.Random random;
  final ParticleSystem particles;
  final ArcLayer arcs;
  final ScreenShake shake;

  @override
  Future<void> onLoad() async {
    await game.world.addAll([particles, arcs]);
    game.explosionListeners.add(onExplosion);
    game.fractureListeners.add(onFracture);
    game.arcListeners.add(onArc);
  }

  @override
  void onRemove() {
    game.explosionListeners.remove(onExplosion);
    game.fractureListeners.remove(onFracture);
    game.arcListeners.remove(onArc);
    super.onRemove();
  }

  void reset() {
    particles.clear();
    arcs.clear();
    shake.trauma = 0;
    game.postProcess?.shockwaves.clear();
  }

  PaletteRole _roleFor(ExplosionKind kind) => switch (kind) {
    ExplosionKind.pressure => PaletteRole.glow,
    ExplosionKind.fizzle => PaletteRole.hazard,
    ExplosionKind.implosion => PaletteRole.secondary,
    ExplosionKind.magnet => PaletteRole.accent,
    ExplosionKind.gravityWell => PaletteRole.secondary,
    ExplosionKind.chainSpark => PaletteRole.accent,
  };

  PaletteRole _roleForShape(ShapeKind kind) => switch (kind) {
    ShapeKind.tri => PaletteRole.primary,
    ShapeKind.square => PaletteRole.secondary,
    ShapeKind.poly => PaletteRole.accent,
    ShapeKind.circle => PaletteRole.glow,
  };

  void onExplosion(ExplosionEvent e) {
    final energy = e.energy;
    final fizzle = e.kind == ExplosionKind.fizzle;
    final role = _roleFor(e.kind);
    particles.emit(
      position: e.position,
      count: fizzle ? 14 : (18 + 70 * energy).round(),
      speed: fizzle ? 1.5 : 2.5 + 7 * energy,
      life: fizzle ? 0.5 : 0.45 + 0.6 * energy,
      size: 0.05 + 0.05 * energy,
      role: role,
      jitter: 0.2 + 0.5 * energy,
    );
    if (e.kind == ExplosionKind.implosion) {
      // Ring of particles that get sucked in: emit outward with low life.
      particles.emit(
        position: e.position,
        count: (30 * energy).round() + 8,
        speed: -3 - 4 * energy,
        life: 0.35,
        size: 0.04,
        role: PaletteRole.glow,
        jitter: e.radius * 1.4,
      );
    }
    shake.addTrauma(fizzle ? 0.15 : 0.22 + 0.55 * energy);
    if (!fizzle && energy > 0.55) {
      shake.addZoomPulse(0.025 + 0.07 * (energy - 0.55));
    }
    final post = game.postProcess;
    if (post != null && !fizzle && energy > 0.12) {
      post.addShockwave(e.position, energy);
      post.addFlash(0.05 + 0.18 * energy, role);
    }
  }

  void onFracture(FractureEvent f) {
    final role = _roleForShape(f.kind);
    particles.emit(
      position: f.position,
      velocity: f.velocity * 0.5,
      count: 6 + 2 * f.fragmentCount,
      speed: 1.8,
      life: 0.5,
      size: 0.045,
      role: role,
      jitter: 0.15,
    );
    for (final d in f.dust) {
      particles.emit(
        position: d,
        velocity: f.velocity * 0.7,
        count: 5,
        speed: 1.2,
        life: 0.7,
        size: 0.05,
        role: role,
        jitter: 0.05,
      );
    }
    shake.addTrauma(0.06);
  }

  void onArc(ArcEvent a) {
    arcs.addArc(a.points, a.energy);
    for (final p in a.points.skip(1)) {
      particles.emit(
        position: p,
        count: 6,
        speed: 1.5,
        life: 0.35,
        size: 0.035,
        role: PaletteRole.accent,
        jitter: 0.1,
      );
    }
    shake.addTrauma(0.08 + 0.1 * a.energy);
    if (game.environment.kind == EnvironmentKind.plasma) {
      game.background?.flash = math.max(game.background!.flash, 0.6 + 0.4 * a.energy);
    }
  }

  int _trailCursor = 0;

  @override
  void update(double dt) {
    shake.update(dt);
    // Spark trails on fast bodies; round-robin so cost stays bounded.
    final list = game.liveShapes;
    if (list.isNotEmpty) {
      final budget = math.min(list.length, 24);
      for (var i = 0; i < budget; i++) {
        final shape = list[(_trailCursor + i) % list.length];
        final v = shape.body.linearVelocity;
        final speed = v.length;
        if (speed > Tuning.sparkTrailSpeed) {
          particles.emit(
            position: shape.body.position,
            velocity: v * 0.15,
            count: 1,
            speed: 0.4,
            life: 0.25 + 0.05 * speed,
            size: 0.03 + 0.004 * speed,
            role: shape.role,
            jitter: shape.spec.size * 0.8,
          );
        }
      }
      _trailCursor = (_trailCursor + budget) % list.length;
    }
  }
}
