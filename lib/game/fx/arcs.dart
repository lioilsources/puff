import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import '../puff_game.dart';

class _Arc {
  _Arc(this.points, this.energy, this.life) : maxLife = life;
  final List<Vector2> points;
  final double energy;
  double life;
  final double maxLife;
}

/// Short-lived jittering lightning polylines (chain spark, plasma arcs).
class ArcLayer extends Component with HasGameReference<PuffGame> {
  ArcLayer(this.random) : super(priority: 9);

  final math.Random random;
  final List<_Arc> _arcs = [];

  final _glow = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..blendMode = BlendMode.plus;
  final _core = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  final _path = Path();

  void addArc(List<Vector2> points, double energy, {double life = 0.28}) {
    _arcs.add(_Arc(points.map((p) => p.clone()).toList(), energy, life));
  }

  void clear() => _arcs.clear();

  @override
  void update(double dt) {
    for (final a in _arcs) {
      a.life -= dt;
    }
    _arcs.removeWhere((a) => a.life <= 0);
  }

  @override
  void render(Canvas canvas) {
    if (_arcs.isEmpty) {
      return;
    }
    final p = game.palette;
    for (final arc in _arcs) {
      final t = (arc.life / arc.maxLife).clamp(0.0, 1.0);
      _path.reset();
      var first = true;
      for (var i = 0; i < arc.points.length - 1; i++) {
        final a = arc.points[i];
        final b = arc.points[i + 1];
        final d = b - a;
        final len = d.length;
        if (len < 1e-6) {
          continue;
        }
        final nx = -d.y / len;
        final ny = d.x / len;
        final segments = math.max(3, (len * 3).round());
        if (first) {
          _path.moveTo(a.x, a.y);
          first = false;
        }
        for (var s = 1; s < segments; s++) {
          final f = s / segments;
          final amp = 0.12 * math.sin(f * math.pi) * (0.5 + arc.energy);
          final o = (random.nextDouble() * 2 - 1) * amp;
          _path.lineTo(a.x + d.x * f + nx * o, a.y + d.y * f + ny * o);
        }
        _path.lineTo(b.x, b.y);
      }
      _glow
        ..color = p.secondary.withValues(alpha: 0.35 * t)
        ..strokeWidth = 0.16 + 0.1 * arc.energy;
      canvas.drawPath(_path, _glow);
      _core
        ..color = p.glow.withValues(alpha: (0.6 + 0.4 * random.nextDouble()) * t)
        ..strokeWidth = 0.04 + 0.03 * arc.energy;
      canvas.drawPath(_path, _core);
    }
  }
}
