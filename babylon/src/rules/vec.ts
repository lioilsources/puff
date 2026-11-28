// The little of vector_math the sim uses: plain {x, y} points in meters (y down, as in Forge2D).
export interface Vec {
  x: number;
  y: number;
}

/**
 * vector_math's Vector2 stores Float32List: every x/y written into one is rounded to float32,
 * while the arithmetic in between stays double. f32 marks those stores.
 */
export const f32 = Math.fround;

/** Vector2(x, y). */
export const vec = (x = 0, y = 0): Vec => ({ x: f32(x), y: f32(y) });

/** a - b (clone()..sub). */
export const sub = (a: Vec, b: Vec): Vec => vec(a.x - b.x, a.y - b.y);

/** a + b (clone()..add). */
export const add = (a: Vec, b: Vec): Vec => vec(a.x + b.x, a.y + b.y);

/** v * s (clone()..scale(s)). */
export const scale = (v: Vec, s: number): Vec => vec(v.x * s, v.y * s);

/** v / s: vector_math scales by 1 / s, not divides. */
export const div = (v: Vec, s: number): Vec => scale(v, 1 / s);

/** Vector2.length: double sqrt of the float32 components. */
export const len = (v: Vec): number => Math.sqrt(v.y * v.y + v.x * v.x);
