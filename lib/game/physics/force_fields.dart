import 'dart:math' as math;

import 'package:flame/components.dart';

import '../components/shape_body.dart';
import '../puff_game.dart';
import '../sim/fx_event.dart';
import '../tuning.dart';

/// Environment-driven per-frame forces: sinusoidal wind and the plasma
/// ambient arcs that periodically jolt a random pair of shapes.
class EnvironmentForces extends Component with HasGameReference<PuffGame> {
  EnvironmentForces(this.random);

  final math.Random random;
  double _time = 0;
  double _ambientCooldown = 2;

  void reset() {
    _time = 0;
    _ambientCooldown = 2;
  }

  @override
  void update(double dt) {
    _time += dt;
    final env = game.environment;
    final wind = env.wind(_time);
    if (wind.x != 0 || wind.y != 0) {
      for (final shape in game.liveShapes) {
        shape.body.applyForce(wind * shape.body.mass);
      }
    }
    final ambient = env.ambient;
    if (ambient != null && game.isPlaying) {
      _ambientCooldown -= dt;
      if (_ambientCooldown <= 0) {
        _ambientCooldown = ambient.interval * (0.7 + 0.6 * random.nextDouble());
        _arc(ambient.strength);
      }
    }
  }

  void _arc(double strength) {
    final shapes = game.liveShapes.toList();
    if (shapes.length < 2) {
      return;
    }
    final a = shapes[random.nextInt(shapes.length)];
    ShapeBody? b;
    var best = Tuning.plasmaArcRange;
    for (final s in shapes) {
      if (identical(s, a)) {
        continue;
      }
      final d = s.body.position.distanceTo(a.body.position);
      if (d < best) {
        best = d;
        b = s;
      }
    }
    if (b == null) {
      return;
    }
    final dir = (b.body.position - a.body.position).normalized();
    a.applyBlastImpulse(-dir * strength, (random.nextBool() ? 1 : -1) * 0.4);
    b.applyBlastImpulse(dir * strength, (random.nextBool() ? 1 : -1) * 0.4);
    a.hitFlash = 1;
    b.hitFlash = 1;
    game.emitArc(
      ArcEvent(
        points: [a.body.position.clone(), b.body.position.clone()],
        energy: 0.5,
      ),
    );
  }
}
