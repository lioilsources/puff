// lib/game/components/spawner.dart without Flame: when and what to spawn, as plain requests.
// F0 spike: regular spawns with the heat-scaled size/speed/metal mix. Kolos and volleys follow in F2.
import { heatLerp } from './heat';
import type { GameRandom } from './random';
import { ShapeFactory, type ShapeSpec } from './shapes';
import { tuning as T } from './tuning';
import { vec, type Vec } from './vec';

export interface SpawnRequest {
  spec: ShapeSpec;
  position: Vec;
  velocity: Vec;
  angle: number;
  angularVelocity: number;
}

export class Spawner {
  private elapsed = 0;
  private cooldown = 0.2;
  private burstLeft = T.spawnInitialBurst;
  readonly factory: ShapeFactory;

  constructor(readonly random: GameRandom) {
    this.factory = new ShapeFactory(random, T.breakThreshold, T.metalChance);
  }

  interval(heat: number): number {
    if (heat > 1) return heatLerp(heat, 0, T.spawnIntervalMin, T.spawnIntervalOver);
    const t = Math.min(1, Math.max(0, this.elapsed / T.spawnRampSeconds));
    return T.spawnIntervalStart + (T.spawnIntervalMin - T.spawnIntervalStart) * t;
  }

  /** Advances by dt; returns what to spawn this step. [world] is the visible size in meters. */
  update(dt: number, heat: number, world: Vec, alive: number): SpawnRequest[] {
    this.elapsed += dt;
    this.cooldown -= dt;
    if (this.cooldown > 0) return [];
    const out = alive < T.maxBodies ? [this.spawnOne(heat, world)] : [];
    this.cooldown = this.burstLeft > 0 ? 0.35 : this.interval(heat);
    if (this.burstLeft > 0) this.burstLeft--;
    return out;
  }

  private edgePoint(edge: number, margin: number, world: Vec): Vec {
    const hx = world.x / 2;
    const hy = world.y / 2;
    const t = this.random.nextDouble() * 2 - 1;
    return edge === 0 ? vec(t * hx, -hy - margin) : edge === 1 ? vec(hx + margin, t * hy) : edge === 2 ? vec(t * hx, hy + margin) : vec(-hx - margin, t * hy);
  }

  private towardCenter(p: Vec, jitter: number, speed: number): Vec {
    const angle = Math.atan2(-p.y, -p.x) + (this.random.nextDouble() * 2 - 1) * jitter;
    return vec(Math.cos(angle) * speed, Math.sin(angle) * speed);
  }

  spawnOne(heat: number, world: Vec, edge?: number): SpawnRequest {
    const r = this.random;
    const position = this.edgePoint(edge ?? r.nextInt(4), T.spawnMargin, world);
    const speedMax = heatLerp(heat, T.spawnSpeedMax, T.spawnSpeedMaxHot, T.spawnSpeedMaxOver);
    const speed = T.spawnSpeedMin + r.nextDouble() * (speedMax - T.spawnSpeedMin);
    const spec = this.factory.next(
      heatLerp(heat, T.shapeMinSize, T.shapeMinSizeHot, T.shapeMinSizeOver),
      heatLerp(heat, T.shapeMaxSize, T.shapeMaxSizeHot, T.shapeMaxSizeOver),
      heatLerp(heat, T.metalChance, T.metalChanceHot, T.metalChanceOver),
    );
    return {
      spec,
      position,
      velocity: this.towardCenter(position, T.spawnAngleJitter, speed),
      angle: r.nextDouble() * Math.PI * 2,
      angularVelocity: (r.nextDouble() * 2 - 1) * 1.5,
    };
  }
}
