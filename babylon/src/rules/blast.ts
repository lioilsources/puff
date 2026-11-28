// lib/game/sim/blast.dart: pure impulse math for a pressure blast, no physics engine.
import { div, len, scale, sub, vec, type Vec } from './vec';

export interface BlastParams {
  roeMin: number;
  roeMax: number;
  rMin: number;
  falloffPower: number;
  impulseScale: number;
  torqueScale: number;
}

export const radiusOfEffect = (p: BlastParams, energy: number): number =>
  p.roeMin + (p.roeMax - p.roeMin) * Math.min(1, Math.max(0, energy));

export interface BlastResult {
  impulse: Vec;
  angularImpulse: number;
  falloff: number;
}

export const magnitude = (r: BlastResult): number => len(r.impulse);

export interface BlastInput {
  params: BlastParams;
  origin: Vec;
  bodyPos: Vec;
  energy: number;
  blastMultiplier: number;
  randomSign: number;
  radiusOverride?: number | null;
  directionSign?: number;
}

/** null when the body is outside the radius of effect. */
export function computeBlast(i: BlastInput): BlastResult | null {
  const radius = i.radiusOverride ?? radiusOfEffect(i.params, i.energy);
  const d = sub(i.bodyPos, i.origin);
  const rawDist = len(d);
  if (rawDist > radius) return null;
  const dist = Math.max(rawDist, i.params.rMin);
  const falloff = Math.pow(1 - dist / radius, i.params.falloffPower);
  const dir = rawDist < 1e-6 ? vec(0, -1) : div(d, rawDist);
  const impulse = scale(dir, i.energy * i.params.impulseScale * falloff * i.blastMultiplier * (i.directionSign ?? 1));
  const angularImpulse = i.params.torqueScale * i.energy * falloff * i.randomSign;
  return { impulse, angularImpulse, falloff };
}
