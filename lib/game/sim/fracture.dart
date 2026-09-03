import 'dart:math' as math;

import 'package:vector_math/vector_math.dart';

import 'shapes.dart';

/// One piece of a fractured shape, expressed in the parent's local frame.
class Fragment {
  const Fragment({required this.spec, required this.offset});

  /// Spec with an explicit [ShapeSpec.outline] centered on the fragment's
  /// own centroid.
  final ShapeSpec spec;

  /// Fragment centroid in the parent's local (unrotated) frame.
  final Vector2 offset;
}

class FractureResult {
  const FractureResult({required this.fragments, required this.dust});

  final List<Fragment> fragments;

  /// Pieces too small to be bodies; the FX layer turns them into particles.
  /// Offsets in the parent's local frame.
  final List<Vector2> dust;

  bool get isEmpty => fragments.isEmpty && dust.isEmpty;
}

/// Pure geometry fracture rules (Phase 3).
///
/// - tri      -> 3 tris (centroid to each edge)
/// - square   -> 4 squares, or 2 rects when the impulse is near an axis
/// - poly(n)  -> n tris around the centroid
/// - circle   -> never
/// - shards (fragments of fragments) fan into tris until [maxDepth].
class FractureRules {
  const FractureRules({
    required this.maxDepth,
    required this.minFragmentSize,
    this.axisAlignedCos = 0.92,
  });

  /// Deepest generation that may still fracture. A spawned shape is
  /// generation 0; its pieces are generation 1, and so on.
  final int maxDepth;

  /// Circumradius (m) below which a piece becomes dust instead of a body.
  final double minFragmentSize;

  /// |cos| between the impulse and an axis above which a square splits in 2.
  final double axisAlignedCos;

  bool canFracture(ShapeSpec spec, int generation) =>
      spec.canFracture && generation < maxDepth;

  FractureResult fracture({
    required ShapeSpec spec,
    required int generation,
    required Vector2 localImpulse,
  }) {
    if (!canFracture(spec, generation)) {
      return const FractureResult(fragments: [], dust: []);
    }
    final verts = spec.vertices();
    final List<List<Vector2>> pieces;
    if (spec.outline == null && spec.kind == ShapeKind.square) {
      pieces = _splitSquare(verts, localImpulse);
    } else {
      pieces = _fan(verts);
    }
    return _pack(spec, generation, pieces);
  }

  /// Centroid fan: one triangle per edge.
  List<List<Vector2>> _fan(List<Vector2> verts) {
    final c = polygonCentroid(verts);
    final out = <List<Vector2>>[];
    for (var i = 0; i < verts.length; i++) {
      final a = verts[i];
      final b = verts[(i + 1) % verts.length];
      out.add([c.clone(), a.clone(), b.clone()]);
    }
    return out;
  }

  List<List<Vector2>> _splitSquare(List<Vector2> verts, Vector2 impulse) {
    // The square outline is axis-aligned in local space (see ShapeSpec).
    var minX = double.infinity, maxX = double.negativeInfinity;
    var minY = double.infinity, maxY = double.negativeInfinity;
    for (final v in verts) {
      minX = math.min(minX, v.x);
      maxX = math.max(maxX, v.x);
      minY = math.min(minY, v.y);
      maxY = math.max(maxY, v.y);
    }
    final midX = (minX + maxX) / 2;
    final midY = (minY + maxY) / 2;
    List<Vector2> box(double x0, double y0, double x1, double y1) => [
      Vector2(x0, y0),
      Vector2(x1, y0),
      Vector2(x1, y1),
      Vector2(x0, y1),
    ];
    final len = impulse.length;
    if (len > 1e-6) {
      final cx = (impulse.x / len).abs();
      final cy = (impulse.y / len).abs();
      if (cx >= axisAlignedCos) {
        // Impulse along x: two vertical halves.
        return [box(minX, minY, midX, maxY), box(midX, minY, maxX, maxY)];
      }
      if (cy >= axisAlignedCos) {
        return [box(minX, minY, maxX, midY), box(minX, midY, maxX, maxY)];
      }
    }
    return [
      box(minX, minY, midX, midY),
      box(midX, minY, maxX, midY),
      box(midX, midY, maxX, maxY),
      box(minX, midY, midX, maxY),
    ];
  }

  FractureResult _pack(ShapeSpec spec, int generation, List<List<Vector2>> pieces) {
    final fragments = <Fragment>[];
    final dust = <Vector2>[];
    for (final piece in pieces) {
      final centroid = polygonCentroid(piece);
      final local = piece.map((v) => v - centroid).toList(growable: false);
      var radius = 0.0;
      for (final v in local) {
        radius = math.max(radius, v.length);
      }
      if (radius < minFragmentSize || polygonArea(local) < 1e-4) {
        dust.add(centroid);
        continue;
      }
      final childGeneration = generation + 1;
      final canSplitAgain = childGeneration < maxDepth;
      fragments.add(
        Fragment(
          spec: spec.copyWith(
            size: radius,
            outline: local,
            // Smaller pieces break a bit easier, leaves never break.
            breakThreshold: canSplitAgain
                ? spec.breakThreshold * 0.8
                : double.infinity,
          ),
          offset: centroid,
        ),
      );
    }
    return FractureResult(fragments: fragments, dust: dust);
  }
}
