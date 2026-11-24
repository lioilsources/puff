// F0 spike: one run of Puff in the browser. Hold to grow a pressure cloud, drag it, release:
// the blast (rules/blast.ts, golden-vector exact) pushes planck.js bodies, strong hits fracture
// (rules/fracture.ts), shapes hitting the core cost a life. ?seed=<n> repeats the spawns,
// ?env=vacuum|air|water|plasma, ?palette=<id>, ?debug shows fps and body count.
import { Engine } from '@babylonjs/core/Engines/engine';
import type { Mesh } from '@babylonjs/core/Meshes/mesh';
import type { Body, Contact } from 'planck';
import { Vec2 } from 'planck';
import { computeBlast, magnitude, radiusOfEffect } from '../rules/blast';
import { Charge, PuffEnergyCurve } from '../rules/energy';
import { FractureRules } from '../rules/fracture';
import { heatAt, heatLerp } from '../rules/heat';
import { gameRandom } from '../rules/random';
import { ScoreModel } from '../rules/score';
import { canFracture } from '../rules/shapes';
import { Spawner } from '../rules/spawner';
import { blastImpulseScale, blastRadiusScale, environment, tuning as T, type EnvironmentKind } from '../rules/tuning';
import type { Vec } from '../rules/vec';
import { showFps } from '../ui/fps';
import { PALETTES } from '../ui/generated/palette';
import { byId, Hud, showGameOver } from '../ui/hud';
import { addCore, addShape, createWorld, dataOf, type ShapeData } from './physics';
import { PuffScene } from './scene';
import '../ui/style.css';

const STEP = 1 / 60;
const q = new URLSearchParams(location.search);
const seedParam = q.get('seed');
const debug = q.has('debug');
const env = environment((q.get('env') as EnvironmentKind) ?? 'vacuum');
const palette = PALETTES[(q.get('palette') as keyof typeof PALETTES) ?? 'cyberpunk'] ?? PALETTES.cyberpunk;

const canvas = byId<HTMLCanvasElement>('game');
const engine = new Engine(canvas, true, { preserveDrawingBuffer: false, stencil: true }, true);
const view = new PuffScene(engine, palette);
const hud = new Hud();
const fractureRules = new FractureRules(T.fractureMaxDepth, T.minFragmentSize);
const curve = new PuffEnergyCurve(T.tOverpressure, T.easeInDuration);

interface Cloud {
  pos: Vec;
  target: Vec;
  charge: Charge;
  radius: number;
}

let world = createWorld(env);
let random = gameRandom(seedParam === null ? undefined : Number(seedParam));
let spawner = new Spawner(random);
let score = new ScoreModel(T);
let meshes = new Map<Body, Mesh>();
let cloud: Cloud | null = null;
let hp = T.coreHp;
let elapsed = 0;
let over = false;

function reset(): void {
  for (const m of meshes.values()) m.dispose();
  world = createWorld(env);
  random = gameRandom(seedParam === null ? undefined : Number(seedParam));
  spawner = new Spawner(random);
  score = new ScoreModel(T);
  meshes = new Map();
  cloud = null;
  hp = T.coreHp;
  elapsed = 0;
  over = false;
  addCore(world, T.coreRadius);
  world.on('begin-contact', onContact);
}

function onContact(c: Contact): void {
  const a = c.getFixtureA().getBody();
  const b = c.getFixtureB().getBody();
  const da = dataOf(a);
  const db = dataOf(b);
  if (da?.kind === 'core' && db?.kind === 'shape') return coreHit(db);
  if (db?.kind === 'core' && da?.kind === 'shape') return coreHit(da);
  if (da?.kind === 'shape' && db?.kind === 'shape') {
    const rel = Math.hypot(a.getLinearVelocity().x - b.getLinearVelocity().x, a.getLinearVelocity().y - b.getLinearVelocity().y);
    if (rel > 0.8) da.hitFlash = db.hitFlash = 1;
    if (rel > T.comboHitSpeed && !over) score.onShapeHit();
  }
}

function coreHit(s: ShapeData): void {
  if (over || s.dead) return;
  s.dead = true;
  hp -= 1;
  view.core.scaling.setAll(1.35);
  if (hp <= 0) {
    over = true;
    cloud = null;
    showGameOver(score.score, score.bestCombo, () => reset());
  }
}

function spawn(spec: Parameters<typeof addShape>[2], p: Vec, v: Vec, angle: number, w: number, gen = 0, depth: number | null = null): void {
  const body = addShape(world, env, spec, p, v, angle, w, gen, depth);
  meshes.set(body, view.shapeMesh(spec));
}

function remove(body: Body): void {
  meshes.get(body)?.dispose();
  meshes.delete(body);
  world.destroyBody(body);
}

function shapes(): [Body, ShapeData][] {
  const out: [Body, ShapeData][] = [];
  for (let b = world.getBodyList(); b; b = b.getNext()) {
    const d = dataOf(b);
    if (d?.kind === 'shape' && !d.dead) out.push([b, d]);
  }
  return out;
}

function detonate(c: Cloud): void {
  const energy = c.charge.releaseEnergy();
  const heat = heatAt(T.heat, elapsed);
  const radius = radiusOfEffect(T.blast, energy) * blastRadiusScale(heat);
  for (const [body, data] of shapes()) {
    const p = body.getPosition();
    const r = computeBlast({
      params: T.blast,
      origin: c.pos,
      bodyPos: { x: p.x, y: p.y },
      energy,
      blastMultiplier: env.blastMultiplier * blastImpulseScale(heat),
      randomSign: random.nextBool() ? 1 : -1,
      radiusOverride: radius,
    });
    if (r === null) continue;
    body.applyLinearImpulse(Vec2(r.impulse.x, r.impulse.y), body.getWorldCenter(), true);
    body.applyAngularImpulse(r.angularImpulse, true);
    score.onImpulse(magnitude(r));
    if (magnitude(r) > data.spec.breakThreshold && canFracture(data.spec)) data.pendingFracture = r.impulse;
  }
  score.onBlast();
  hud.flash();
}

const rot = (v: Vec, a: number): Vec => ({ x: v.x * Math.cos(a) - v.y * Math.sin(a), y: v.x * Math.sin(a) + v.y * Math.cos(a) });

function fractures(): void {
  for (const [body, data] of shapes()) {
    const imp = data.pendingFracture;
    if (!imp) continue;
    data.pendingFracture = null;
    const angle = body.getAngle();
    const res = fractureRules.fracture(data.spec, data.generation, rot(imp, -angle), data.maxDepth);
    if (res.fragments.length === 0 && res.dust.length === 0) continue;
    const pos = body.getPosition();
    const vel = body.getLinearVelocity();
    const w = body.getAngularVelocity();
    remove(body);
    score.onFracture();
    for (const f of res.fragments) {
      const off = rot(f.offset, angle);
      const l = Math.hypot(off.x, off.y) || 1;
      const out = T.fractureOutwardSpeed * (0.5 + random.nextDouble());
      spawn(
        f.spec,
        { x: pos.x + off.x, y: pos.y + off.y },
        { x: vel.x - w * off.y + (off.x / l) * out, y: vel.y + w * off.x + (off.y / l) * out },
        angle,
        w + (random.nextDouble() - 0.5) * T.fractureSpin,
        data.generation + 1,
        data.maxDepth,
      );
    }
  }
}

function step(dt: number): void {
  if (over) return;
  elapsed += dt;
  score.update(dt);
  const heat = heatAt(T.heat, elapsed);
  const alive = shapes();
  for (const s of spawner.update(dt, heat, view.world, alive.length)) spawn(s.spec, s.position, s.velocity, s.angle, s.angularVelocity);

  if (cloud) {
    const c = cloud;
    const inside = alive.filter(([b, d]) => Math.hypot(b.getPosition().x - c.pos.x, b.getPosition().y - c.pos.y) < c.radius + d.spec.size * 0.6).length;
    c.charge.tick(dt, inside);
    const rMax = heatLerp(heat, T.cloudRMax, T.cloudRMaxHot, T.cloudRMaxOver);
    c.radius = T.cloudRMin + (rMax - T.cloudRMin) * c.charge.energy;
    const k = 1 - Math.exp(-dt / (T.lagBase + T.lagPerRadius * c.radius));
    c.pos = { x: c.pos.x + (c.target.x - c.pos.x) * k, y: c.pos.y + (c.target.y - c.pos.y) * k };
    if (c.charge.overpressured) release();
  }

  world.step(dt);
  fractures();
  const hx = view.world.x / 2 + T.despawnMargin;
  const hy = view.world.y / 2 + T.despawnMargin;
  for (const [body, data] of shapes().concat(deadShapes())) {
    const p = body.getPosition();
    if (data.dead || Math.abs(p.x) > hx || Math.abs(p.y) > hy) remove(body);
    else data.hitFlash = Math.max(0, data.hitFlash - dt * 4);
  }
}

function deadShapes(): [Body, ShapeData][] {
  const out: [Body, ShapeData][] = [];
  for (let b = world.getBodyList(); b; b = b.getNext()) {
    const d = dataOf(b);
    if (d?.kind === 'shape' && d.dead) out.push([b, d]);
  }
  return out;
}

function release(): void {
  const c = cloud;
  if (!c) return;
  cloud = null;
  detonate(c);
}

// ── Input ────────────────────────────────────────────────────────────────
const toWorld = (e: PointerEvent): Vec => view.toWorld(e.offsetX, e.offsetY, canvas.clientWidth, canvas.clientHeight);
let pointer: number | null = null;
canvas.addEventListener('pointerdown', (e) => {
  if (over || pointer !== null) return;
  pointer = e.pointerId;
  canvas.setPointerCapture(e.pointerId);
  const p = toWorld(e);
  cloud = { pos: p, target: p, charge: new Charge(curve, T.tOverpressure, T.overpressurePenalty, T.drainRate), radius: T.cloudRMin };
});
canvas.addEventListener('pointermove', (e) => {
  if (e.pointerId === pointer && cloud) cloud.target = toWorld(e);
});
const up = (e: PointerEvent): void => {
  if (e.pointerId !== pointer) return;
  pointer = null;
  release();
};
canvas.addEventListener('pointerup', up);
canvas.addEventListener('pointercancel', up);

// ── Loop ─────────────────────────────────────────────────────────────────
function resize(): void {
  engine.resize();
  view.fit(canvas.clientWidth, canvas.clientHeight);
}
window.addEventListener('resize', resize);
resize();
reset();

let acc = 0;
let firstFrame = true;
engine.runRenderLoop(() => {
  acc = Math.min(acc + engine.getDeltaTime() / 1000, 0.25);
  while (acc >= STEP) {
    step(STEP);
    acc -= STEP;
  }
  for (const [body, mesh] of meshes) {
    const p = body.getPosition();
    view.place(mesh, { x: p.x, y: p.y }, body.getAngle());
    const d = dataOf(body) as ShapeData;
    mesh.visibility = 1 - 0.3 * d.hitFlash;
  }
  view.core.scaling.setAll(Math.max(1, view.core.scaling.x - 0.02));
  view.setCloud(cloud?.pos ?? null, cloud?.radius ?? 0);
  hud.update(score.score, score.multiplier, score.combo, hp, T.coreHp, cloud ? cloud.charge.overpressureProgress : 0);
  view.scene.render();
  if (debug) showFps(byId('fps'), engine.getFps());
  if (firstFrame) {
    firstFrame = false;
    (window as unknown as { __firstFrameMs: number }).__firstFrameMs = performance.now();
  }
});
