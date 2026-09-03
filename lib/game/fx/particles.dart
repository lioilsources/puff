import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';

import '../palette.dart';
import '../puff_game.dart';

/// Lightweight debris/spark particles rendered with a single
/// [Canvas.drawVertices] call. No per-particle components.
class ParticleSystem extends Component with HasGameReference<PuffGame> {
  ParticleSystem(this.random, {this.capacity = 1500}) : super(priority: 8);

  final math.Random random;
  final int capacity;

  // Struct-of-arrays storage.
  late final Float32List _x = Float32List(capacity);
  late final Float32List _y = Float32List(capacity);
  late final Float32List _vx = Float32List(capacity);
  late final Float32List _vy = Float32List(capacity);
  late final Float32List _life = Float32List(capacity);
  late final Float32List _maxLife = Float32List(capacity);
  late final Float32List _size = Float32List(capacity);
  late final Uint8List _role = Uint8List(capacity);
  int count = 0;

  // Vertex buffers: 6 vertices (2 triangles) per particle.
  late final Float32List _positions = Float32List(capacity * 12);
  late final Int32List _colors = Int32List(capacity * 6);

  final _paint = Paint()..blendMode = BlendMode.plus;

  static const roles = [
    PaletteRole.primary,
    PaletteRole.secondary,
    PaletteRole.accent,
    PaletteRole.glow,
    PaletteRole.hazard,
  ];

  /// Linear damping applied to particle velocity per second.
  double damping = 1.2;

  void clear() => count = 0;

  void emit({
    required Vector2 position,
    Vector2? velocity,
    int count = 8,
    double speed = 2,
    double spread = math.pi * 2,
    double? direction,
    double life = 0.6,
    double size = 0.06,
    PaletteRole role = PaletteRole.glow,
    double jitter = 0.05,
  }) {
    final baseAngle = direction ?? 0;
    final roleIndex = roles.indexOf(role).clamp(0, roles.length - 1);
    for (var i = 0; i < count; i++) {
      if (this.count >= capacity) {
        // Recycle the oldest slot.
        _kill(random.nextInt(capacity));
      }
      final slot = this.count++;
      final angle = baseAngle + (random.nextDouble() - 0.5) * spread;
      final s = speed * (0.4 + random.nextDouble() * 0.8);
      _x[slot] = position.x + (random.nextDouble() - 0.5) * jitter;
      _y[slot] = position.y + (random.nextDouble() - 0.5) * jitter;
      _vx[slot] = (velocity?.x ?? 0) + math.cos(angle) * s;
      _vy[slot] = (velocity?.y ?? 0) + math.sin(angle) * s;
      final l = life * (0.6 + random.nextDouble() * 0.8);
      _life[slot] = l;
      _maxLife[slot] = l;
      _size[slot] = size * (0.6 + random.nextDouble() * 0.8);
      _role[slot] = roleIndex;
    }
  }

  void _kill(int i) {
    final last = count - 1;
    if (i != last) {
      _x[i] = _x[last];
      _y[i] = _y[last];
      _vx[i] = _vx[last];
      _vy[i] = _vy[last];
      _life[i] = _life[last];
      _maxLife[i] = _maxLife[last];
      _size[i] = _size[last];
      _role[i] = _role[last];
    }
    count = last;
  }

  @override
  void update(double dt) {
    final k = math.max(0.0, 1 - damping * dt);
    final g = game.environment.gravityY * 0.5 * dt;
    var i = 0;
    while (i < count) {
      _life[i] -= dt;
      if (_life[i] <= 0) {
        _kill(i);
        continue;
      }
      _vx[i] *= k;
      _vy[i] = _vy[i] * k + g;
      _x[i] += _vx[i] * dt;
      _y[i] += _vy[i] * dt;
      i++;
    }
  }

  @override
  void render(Canvas canvas) {
    if (count == 0) {
      return;
    }
    final palette = game.palette;
    final roleColors = List<int>.generate(
      roles.length,
      (i) => palette.byRole(roles[i]).toARGB32(),
    );
    var p = 0;
    var c = 0;
    for (var i = 0; i < count; i++) {
      final t = (_life[i] / _maxLife[i]).clamp(0.0, 1.0);
      final h = _size[i] * (0.5 + 0.5 * t);
      final x = _x[i];
      final y = _y[i];
      // Stretch along velocity for a spark look.
      final vx = _vx[i];
      final vy = _vy[i];
      final speed = math.sqrt(vx * vx + vy * vy);
      final stretch = 1 + math.min(speed * 0.25, 2.5);
      final ux = speed > 1e-4 ? vx / speed : 1.0;
      final uy = speed > 1e-4 ? vy / speed : 0.0;
      final ax = ux * h * stretch;
      final ay = uy * h * stretch;
      final bx = -uy * h;
      final by = ux * h;
      final x0 = x - ax - bx, y0 = y - ay - by;
      final x1 = x + ax - bx, y1 = y + ay - by;
      final x2 = x + ax + bx, y2 = y + ay + by;
      final x3 = x - ax + bx, y3 = y - ay + by;
      _positions[p++] = x0;
      _positions[p++] = y0;
      _positions[p++] = x1;
      _positions[p++] = y1;
      _positions[p++] = x2;
      _positions[p++] = y2;
      _positions[p++] = x0;
      _positions[p++] = y0;
      _positions[p++] = x2;
      _positions[p++] = y2;
      _positions[p++] = x3;
      _positions[p++] = y3;
      final base = roleColors[_role[i]];
      final alpha = (255 * t * t).round();
      final color = (alpha << 24) | (base & 0x00FFFFFF);
      for (var k = 0; k < 6; k++) {
        _colors[c++] = color;
      }
    }
    final vertices = Vertices.raw(
      VertexMode.triangles,
      Float32List.sublistView(_positions, 0, p),
      colors: Int32List.sublistView(_colors, 0, c),
    );
    canvas.drawVertices(vertices, BlendMode.srcOver, _paint);
    vertices.dispose();
  }
}
