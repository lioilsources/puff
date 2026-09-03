import 'dart:math' as math;

import 'package:vector_math/vector_math.dart';

enum ShapeKind { tri, square, poly, circle }

enum ShapeMaterial { neon, metal }

/// Static description of a shape. `sides` only matters for [ShapeKind.poly].
class ShapeSpec {
  const ShapeSpec({
    required this.kind,
    required this.size,
    this.sides = 6,
    this.density = 1.0,
    this.restitution = 0.45,
    this.friction = 0.2,
    required this.breakThreshold,
    this.material = ShapeMaterial.neon,
    this.outline,
  }) : assert(kind != ShapeKind.poly || (sides >= 5 && sides <= 8));

  final ShapeKind kind;

  /// Circumradius in meters.
  final double size;
  final int sides;
  final double density;
  final double restitution;
  final double friction;

  /// Impulse magnitude (N*s) above which the shape fractures.
  final double breakThreshold;
  final ShapeMaterial material;

  /// Explicit local-space outline for fracture fragments. When set,
  /// [vertices] returns it verbatim and [size] is the circumradius.
  final List<Vector2>? outline;

  bool get canFracture => kind != ShapeKind.circle && breakThreshold.isFinite;

  int get vertexCount => outline?.length ?? _sideCount;

  /// Local-space outline, counter-clockwise, centered on the origin.
  /// Circles return an empty list; use [size] as the radius instead.
  List<Vector2> vertices() {
    final custom = outline;
    if (custom != null) {
      return custom;
    }
    final n = switch (kind) {
      ShapeKind.tri => 3,
      ShapeKind.square => 4,
      ShapeKind.poly => sides,
      ShapeKind.circle => 0,
    };
    if (n == 0) {
      return const [];
    }
    // Rotate so squares sit flat and triangles point up.
    final offset = switch (kind) {
      ShapeKind.square => math.pi / 4,
      ShapeKind.tri => -math.pi / 2,
      _ => -math.pi / 2,
    };
    return List.generate(n, (i) {
      final a = offset + i * 2 * math.pi / n;
      return Vector2(math.cos(a) * size, math.sin(a) * size);
    });
  }

  /// Approximate area in m^2, used for mass estimates without a physics body.
  double get area {
    if (kind == ShapeKind.circle) {
      return math.pi * size * size;
    }
    return polygonArea(vertices());
  }

  int get _sideCount => switch (kind) {
    ShapeKind.tri => 3,
    ShapeKind.square => 4,
    ShapeKind.poly => sides,
    ShapeKind.circle => 0,
  };

  ShapeSpec copyWith({
    ShapeKind? kind,
    double? size,
    int? sides,
    double? breakThreshold,
    ShapeMaterial? material,
    List<Vector2>? outline,
  }) => ShapeSpec(
    kind: kind ?? this.kind,
    size: size ?? this.size,
    sides: sides ?? this.sides,
    density: density,
    restitution: restitution,
    friction: friction,
    breakThreshold: breakThreshold ?? this.breakThreshold,
    material: material ?? this.material,
    outline: outline ?? this.outline,
  );
}

/// Shoelace area of a simple polygon (absolute value).
double polygonArea(List<Vector2> points) {
  var sum = 0.0;
  for (var i = 0; i < points.length; i++) {
    final a = points[i];
    final b = points[(i + 1) % points.length];
    sum += a.x * b.y - b.x * a.y;
  }
  return sum.abs() / 2;
}

/// Area-weighted centroid of a simple polygon.
Vector2 polygonCentroid(List<Vector2> points) {
  var area = 0.0;
  var cx = 0.0;
  var cy = 0.0;
  for (var i = 0; i < points.length; i++) {
    final a = points[i];
    final b = points[(i + 1) % points.length];
    final cross = a.x * b.y - b.x * a.y;
    area += cross;
    cx += (a.x + b.x) * cross;
    cy += (a.y + b.y) * cross;
  }
  if (area.abs() < 1e-12) {
    final sum = points.fold(Vector2.zero(), (acc, p) => acc + p);
    return sum / points.length.toDouble();
  }
  area *= 0.5;
  return Vector2(cx / (6 * area), cy / (6 * area));
}

/// Randomized spawn specs. Weights and ranges are gameplay knobs.
class ShapeFactory {
  ShapeFactory(this.random, {required this.baseBreakThreshold, required this.metalChance});

  final math.Random random;
  final double baseBreakThreshold;
  final double metalChance;

  ShapeSpec next({double minSize = 0.28, double maxSize = 0.5}) {
    final roll = random.nextDouble();
    final kind = roll < 0.32
        ? ShapeKind.tri
        : roll < 0.62
        ? ShapeKind.square
        : roll < 0.86
        ? ShapeKind.poly
        : ShapeKind.circle;
    final size = minSize + random.nextDouble() * (maxSize - minSize);
    final sides = 5 + random.nextInt(4);
    final material = random.nextDouble() < metalChance
        ? ShapeMaterial.metal
        : ShapeMaterial.neon;
    // Bigger and rounder shapes are tougher.
    final toughness = switch (kind) {
      ShapeKind.tri => 0.8,
      ShapeKind.square => 1.0,
      ShapeKind.poly => 1.2,
      ShapeKind.circle => double.infinity,
    };
    return ShapeSpec(
      kind: kind,
      size: size,
      sides: sides,
      breakThreshold: baseBreakThreshold * toughness * (size / 0.4),
      material: material,
      density: material == ShapeMaterial.metal ? 1.6 : 1.0,
      restitution: material == ShapeMaterial.metal ? 0.3 : 0.5,
    );
  }
}
