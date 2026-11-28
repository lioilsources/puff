// lib/game/sim/heat.dart: how far a run has escalated.
export interface HeatCurve {
  warmUp: number;
  fullAt: number;
  overdriveAt: number;
  max: number;
}

export const HEAT_TIER_NAMES = ['', 'HEAT I', 'HEAT II', 'HEAT III', 'OVERDRIVE'];

/** Smoothstep from warmUp to fullAt, then linear to max. */
export function heatAt(h: HeatCurve, elapsed: number): number {
  if (elapsed <= h.warmUp) return 0;
  if (elapsed < h.fullAt) {
    const u = (elapsed - h.warmUp) / (h.fullAt - h.warmUp);
    return u * u * (3 - 2 * u);
  }
  const over = Math.min(1, Math.max(0, (elapsed - h.fullAt) / (h.overdriveAt - h.fullAt)));
  return 1 + (h.max - 1) * over;
}

export function tierOf(h: HeatCurve, heat: number): number {
  if (heat <= 0) return 0;
  if (heat < 0.5) return 1;
  if (heat < 1) return 2;
  return heat < h.max ? 3 : 4;
}

/** cold at heat 0, hot at 1, over (default hot) at 1.5. */
export function heatLerp(heat: number, cold: number, hot: number, over?: number): number {
  if (heat <= 1) return cold + (hot - cold) * Math.min(1, Math.max(0, heat));
  const top = over ?? hot;
  return hot + (top - hot) * Math.min(1, Math.max(0, (heat - 1) / 0.5));
}
