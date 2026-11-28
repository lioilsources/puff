// lib/game/sim/fracture.dart: pure geometry fracture rules.
//   tri → 3 tris, square → 4 squares (2 halves when the impulse is near an axis),
//   poly(n) → n tris, circle → never, fragments fan into tris until maxDepth.
import { canFracture, polygonArea, polygonCentroid, vertices, type ShapeSpec } from './shapes';
import { len, sub, vec, type Vec } from './vec';

export interface Fragment {
  /** Spec with an explicit outline centered on the fragment's own centroid. */
  spec: ShapeSpec;
  /** Fragment centroid in the parent's local (unrotated) frame. */
  offset: Vec;
}

export interface FractureResult {
  fragments: Fragment[];
  /** Pieces too small to be bodies (particles), in the parent's local frame. */
  dust: Vec[];
}

export class FractureRules {
  constructor(readonly maxDepth: number, readonly minFragmentSize: number, readonly axisAlignedCos = 0.92) {}

  canFracture(spec: ShapeSpec, generation: number, maxDepth?: number | null): boolean {
    return canFracture(spec) && generation < (maxDepth ?? this.maxDepth);
  }

  fracture(spec: ShapeSpec, generation: number, localImpulse: Vec, maxDepth?: number | null): FractureResult {
    const depth = maxDepth ?? this.maxDepth;
    if (!this.canFracture(spec, generation, depth)) return { fragments: [], dust: [] };
    const verts = vertices(spec);
    const pieces = spec.outline === null && spec.kind === 'square' ? this.splitSquare(verts, localImpulse) : fan(verts);
    return this.pack(spec, generation, pieces, depth);
  }

  private splitSquare(verts: readonly Vec[], impulse: Vec): Vec[][] {
    let minX = Infinity, maxX = -Infinity, minY = Infinity, maxY = -Infinity;
    for (const v of verts) {
      minX = Math.min(minX, v.x);
      maxX = Math.max(maxX, v.x);
      minY = Math.min(minY, v.y);
      maxY = Math.max(maxY, v.y);
    }
    const midX = (minX + maxX) / 2;
    const midY = (minY + maxY) / 2;
    const box = (x0: number, y0: number, x1: number, y1: number): Vec[] => [vec(x0, y0), vec(x1, y0), vec(x1, y1), vec(x0, y1)];
    const l = len(impulse);
    if (l > 1e-6) {
      if (Math.abs(impulse.x / l) >= this.axisAlignedCos) return [box(minX, minY, midX, maxY), box(midX, minY, maxX, maxY)];
      if (Math.abs(impulse.y / l) >= this.axisAlignedCos) return [box(minX, minY, maxX, midY), box(minX, midY, maxX, maxY)];
    }
    return [box(minX, minY, midX, midY), box(midX, minY, maxX, midY), box(midX, midY, maxX, maxY), box(minX, midY, midX, maxY)];
  }

  private pack(spec: ShapeSpec, generation: number, pieces: Vec[][], maxDepth: number): FractureResult {
    const fragments: Fragment[] = [];
    const dust: Vec[] = [];
    for (const piece of pieces) {
      const centroid = polygonCentroid(piece);
      const local = piece.map((v) => sub(v, centroid));
      let radius = 0;
      for (const v of local) radius = Math.max(radius, len(v));
      if (radius < this.minFragmentSize || polygonArea(local) < 1e-4) {
        dust.push(centroid);
        continue;
      }
      const canSplitAgain = generation + 1 < maxDepth;
      fragments.push({
        spec: { ...spec, size: radius, outline: local, breakThreshold: canSplitAgain ? spec.breakThreshold * 0.8 : Infinity },
        offset: centroid,
      });
    }
    return { fragments, dust };
  }
}

/** Centroid fan: one triangle per edge. */
function fan(verts: readonly Vec[]): Vec[][] {
  const c = polygonCentroid(verts);
  return verts.map((a, i) => [{ ...c }, { ...a }, { ...verts[(i + 1) % verts.length] }]);
}
