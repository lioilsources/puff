// lib/game/tuning.dart: every gameplay constant, dumped by tool/dump_vectors.dart (not copied by hand).
import json from './generated/tuning.json';
import type { BlastParams } from './blast';
import type { HeatCurve } from './heat';
import { heatLerp } from './heat';

export type EnvironmentKind = 'vacuum' | 'air' | 'water' | 'plasma';

export interface Environment {
  kind: EnvironmentKind;
  linearDamping: number;
  angularDamping: number;
  blastMultiplier: number;
  gravityY: number;
  windAmplitude: number;
  windPeriod: number;
  ambient: { interval: number; strength: number } | null;
}

type Tuning = Omit<typeof json, 'blast' | 'heat' | 'environments'> & {
  blast: BlastParams;
  heat: HeatCurve;
  environments: Environment[];
};

export const tuning = json as Tuning;

export const environment = (kind: EnvironmentKind): Environment => tuning.environments.find((e) => e.kind === kind)!;

/** Tuning.blastRadiusScale. */
export const blastRadiusScale = (heat: number): number => heatLerp(heat, 1, tuning.blastRadiusHot, tuning.blastRadiusOver);

/** Tuning.blastImpulseScale. */
export const blastImpulseScale = (heat: number): number => heatLerp(heat, 1, tuning.blastImpulseHot, tuning.blastImpulseOver);
