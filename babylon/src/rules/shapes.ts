// lib/game/sim/shapes.dart: shape specs, their outlines and the random spawn factory.
import type { GameRandom } from './random';
import { add, div, sub, vec, type Vec } from './vec';

export type ShapeKind = 'tri' | 'square' | 'poly' | 'circle';
export type ShapeMaterial = 'neon' | 'metal';

export interface ShapeSpec {
  kind: ShapeKind;
  /** Circumradius in meters. */
  size: number;
  /** Only for poly (5–8). */
  sides: number;
  density: number;
  restitution: number;
  friction: number;
  /** Impulse magnitude (N·s) above which the shape fractures; Infinity = never. */
  breakThreshold: number;
  material: ShapeMaterial;
  /** Explicit local outline (fracture fragments), centered on its centroid. */
  outline: Vec[] | null;
}

export const shapeSpec = (s: Partial<ShapeSpec> & Pick<ShapeSpec, 'kind' | 'size' | 'breakThreshold'>): ShapeSpec => ({
  sides: 6, density: 1, restitution: 0.45, friction: 0.2, material: 'neon', outline: null, ...s,
});

export const canFracture = (s: ShapeSpec): boolean => s.kind !== 'circle' && Number.isFinite(s.breakThreshold);

const sideCount = (s: ShapeSpec): number =>
  s.kind === 'tri' ? 3 : s.kind === 'square' ? 4 : s.kind === 'poly' ? s.sides : 0;

/** Local outline, counter-clockwise around the origin; circles return []. */
export function vertices(s: ShapeSpec): Vec[] {
  if (s.outline !== null) return s.outline;
  const n = sideCount(s);
  if (n === 0) return [];
  // Rotate so squares sit flat and triangles point up.
  const offset = s.kind === 'square' ? Math.PI / 4 : -Math.PI / 2;
  return Array.from({ length: n }, (_, i) => {
    const a = offset + (i * 2 * Math.PI) / n;
    return vec(Math.cos(a) * s.size, Math.sin(a) * s.size);
  });
}

export const area = (s: ShapeSpec): number => (s.kind === 'circle' ? Math.PI * s.size * s.size : polygonArea(vertices(s)));

/** Shoelace area (absolute). */
export function polygonArea(points: readonly Vec[]): number {
  let sum = 0;
  for (let i = 0; i < points.length; i++) {
    const a = points[i];
    const b = points[(i + 1) % points.length];
    sum += a.x * b.y - b.x * a.y;
  }
  return Math.abs(sum) / 2;
}

/** Area-weighted centroid. */
export function polygonCentroid(points: readonly Vec[]): Vec {
  let ar = 0;
  let cx = 0;
  let cy = 0;
  for (let i = 0; i < points.length; i++) {
    const a = points[i];
    const b = points[(i + 1) % points.length];
    const cross = a.x * b.y - b.x * a.y;
    ar += cross;
    cx += (a.x + b.x) * cross;
    cy += (a.y + b.y) * cross;
  }
  if (Math.abs(ar) < 1e-12) {
    const sum = points.reduce<Vec>((acc, p) => add(acc, p), vec());
    return div(sum, points.length);
  }
  ar *= 0.5;
  return vec(cx / (6 * ar), cy / (6 * ar));
}

export const translate = (points: readonly Vec[], by: Vec): Vec[] => points.map((p) => sub(p, by));

/** Randomized spawn specs (same draws, same order as Dart). */
export class ShapeFactory {
  constructor(readonly random: GameRandom, readonly baseBreakThreshold: number, readonly metalChance: number) {}

  next(minSize = 0.28, maxSize = 0.5, metalChance?: number | null): ShapeSpec {
    const r = this.random;
    const roll = r.nextDouble();
    const kind: ShapeKind = roll < 0.32 ? 'tri' : roll < 0.62 ? 'square' : roll < 0.86 ? 'poly' : 'circle';
    const size = minSize + r.nextDouble() * (maxSize - minSize);
    const sides = 5 + r.nextInt(4);
    const material: ShapeMaterial = r.nextDouble() < (metalChance ?? this.metalChance) ? 'metal' : 'neon';
    // Bigger and rounder shapes are tougher.
    const toughness = kind === 'tri' ? 0.8 : kind === 'square' ? 1.0 : kind === 'poly' ? 1.2 : Infinity;
    return shapeSpec({
      kind,
      size,
      sides,
      breakThreshold: this.baseBreakThreshold * toughness * (size / 0.4),
      material,
      density: material === 'metal' ? 1.6 : 1.0,
      restitution: material === 'metal' ? 0.3 : 0.5,
    });
  }
}
