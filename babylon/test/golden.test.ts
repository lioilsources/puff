// Replays the golden vectors written by tool/dump_vectors.dart (plan 06).
// Each test/golden/<name>.json is { "cases": [{ "in": …, "out": … }] }. Every file needs a
// replayer below and every replayer a file, so a vector set can't be silently skipped.
// Discrete values (ints, strings, bools) must match exactly (P0); floats to 1e-9 relative,
// which only tolerates last-bit libm differences between platforms.
import { readdirSync, readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';
import { computeBlast } from '../src/rules/blast';
import { Charge, PuffEnergyCurve } from '../src/rules/energy';
import { FractureRules } from '../src/rules/fracture';
import { heatAt, heatLerp, tierOf } from '../src/rules/heat';
import { gameRandom } from '../src/rules/random';
import { ScoreModel } from '../src/rules/score';
import { area, polygonCentroid, ShapeFactory, vertices, type ShapeSpec } from '../src/rules/shapes';
import { blastImpulseScale, blastRadiusScale, tuning as T } from '../src/rules/tuning';
import { vec, type Vec } from '../src/rules/vec';

type Case = { in: unknown; out: unknown };
type P = [number, number];
type JsonSpec = Omit<ShapeSpec, 'breakThreshold' | 'outline'> & { breakThreshold: number | 'inf'; outline: P[] | null };

const v = ([x, y]: P): Vec => vec(x, y);
const p = (a: Vec): P => [a.x, a.y];
const fromJson = (s: JsonSpec): ShapeSpec => ({
  ...s,
  breakThreshold: s.breakThreshold === 'inf' ? Infinity : s.breakThreshold,
  outline: s.outline === null ? null : s.outline.map(v),
});
const toJson = (s: ShapeSpec): JsonSpec => ({
  ...s,
  breakThreshold: Number.isFinite(s.breakThreshold) ? s.breakThreshold : 'inf',
  outline: s.outline === null ? null : s.outline.map(p),
});

const REPLAY: Record<string, (input: never) => unknown> = {
  'blast.json': (i: { origin: P; body: P; energy: number; mult: number; sign: number; radius: number | null; dir: number }) => {
    const r = computeBlast({
      params: T.blast, origin: v(i.origin), bodyPos: v(i.body), energy: i.energy, blastMultiplier: i.mult,
      randomSign: i.sign, radiusOverride: i.radius, directionSign: i.dir,
    });
    return r === null ? null : { impulse: p(r.impulse), angular: r.angularImpulse, falloff: r.falloff };
  },
  'energy.json': (steps: [number, number][]) => {
    const c = new Charge(new PuffEnergyCurve(T.tOverpressure, T.easeInDuration), T.tOverpressure, T.overpressurePenalty, T.drainRate);
    return steps.map(([dt, bodies]) => {
      c.tick(dt, bodies);
      return [c.energy, c.overpressureProgress, c.overpressured, c.drainedThisTick, c.releaseEnergy()];
    });
  },
  'fracture.json': (i: { spec: JsonSpec; generation: number; impulse: P; maxDepth: number | null }) => {
    const rules = new FractureRules(T.fractureMaxDepth, T.minFragmentSize);
    const r = rules.fracture(fromJson(i.spec), i.generation, v(i.impulse), i.maxDepth);
    return { fragments: r.fragments.map((f) => ({ spec: toJson(f.spec), offset: p(f.offset) })), dust: r.dust.map(p) };
  },
  'heat.json': (t: number) => {
    const h = heatAt(T.heat, t);
    return [h, tierOf(T.heat, h), blastRadiusScale(h), blastImpulseScale(h), heatLerp(h, 0.3, 0.8, 0.9)];
  },
  'score.json': (ops: ('blast' | 'hit' | 'fracture' | ['impulse', number] | number)[]) => {
    const s = new ScoreModel(T);
    return ops.map((o) => {
      if (o === 'blast') s.onBlast();
      else if (o === 'hit') s.onShapeHit();
      else if (o === 'fracture') s.onFracture();
      else if (Array.isArray(o)) s.onImpulse(o[1]);
      else s.update(o);
      return [s.score, s.combo, s.bestCombo, s.bodiesDisplaced, s.fractures, s.multiplier, s.comboRemaining];
    });
  },
  'shapes.json': (i: { seed: number; minSize: number; maxSize: number; metalChance: number | null }) => {
    const f = new ShapeFactory(gameRandom(i.seed), T.breakThreshold, T.metalChance);
    return Array.from({ length: 12 }, () => {
      const s = f.next(i.minSize, i.maxSize, i.metalChance);
      const verts = vertices(s);
      return { spec: toJson(s), vertices: verts.map(p), area: area(s), centroid: verts.length === 0 ? null : p(polygonCentroid(verts)) };
    });
  },
};

const dir = fileURLToPath(new URL('./golden/', import.meta.url));
const files = readdirSync(dir).filter((f) => f.endsWith('.json')).sort();
const EPS = 1e-9;

function same(actual: unknown, expected: unknown, path: string): void {
  if (typeof expected === 'number' && typeof actual === 'number') {
    if (Number.isInteger(expected) ? actual !== expected : Math.abs(actual - expected) > EPS * Math.max(1, Math.abs(expected))) {
      expect.fail(`${path}: ${actual} ≠ ${expected}`);
    }
  } else if (Array.isArray(expected)) {
    if (!Array.isArray(actual) || actual.length !== expected.length) expect.fail(`${path}: length ${JSON.stringify(actual)?.length} vs ${expected.length}`);
    expected.forEach((e, k) => same((actual as unknown[])[k], e, `${path}[${k}]`));
  } else if (expected !== null && typeof expected === 'object') {
    if (actual === null || typeof actual !== 'object') expect.fail(`${path}: not an object`);
    const keys = Object.keys(expected);
    expect(Object.keys(actual as object).sort(), `${path} keys`).toEqual([...keys].sort());
    for (const k of keys) same((actual as Record<string, unknown>)[k], (expected as Record<string, unknown>)[k], `${path}.${k}`);
  } else expect(actual, path).toEqual(expected);
}

describe('golden vectors', () => {
  it('every file has a replayer and every replayer a file', () => {
    expect(files).toEqual(Object.keys(REPLAY).sort());
  });
  for (const f of files) {
    it(f, () => {
      const { cases } = JSON.parse(readFileSync(dir + f, 'utf8')) as { cases: Case[] };
      expect(cases.length).toBeGreaterThan(0);
      // JSON has no int/double split: Dart writes 1.0 as 1, so an integral float compares exactly — fine for P0.
      cases.forEach((c, k) => same(REPLAY[f](c.in as never), c.out, `${f}#${k}`));
    });
  }
});
