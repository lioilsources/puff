// lib/game/sim/energy.dart: hold time → energy, and the charge state of one held cloud.
const clamp01 = (x: number): number => Math.min(1, Math.max(0, x));

export interface EnergyCurve {
  transform(t: number): number;
}

/** Ease-in, near-linear middle, asymptotic toward 1 at tOverpressure. */
export class PuffEnergyCurve implements EnergyCurve {
  constructor(readonly tOverpressure: number, readonly easeInDuration = 0.3, readonly approachPower = 1.7) {}

  transform(t: number): number {
    if (t <= 0) return 0;
    const s = clamp01(t / this.tOverpressure);
    const base = 1 - Math.pow(1 - s, this.approachPower);
    const u = clamp01(t / this.easeInDuration);
    const ramp = u * u * (3 - 2 * u);
    return clamp01(base * ramp);
  }
}

export class Charge {
  holdTime = 0;
  drained = 0;
  drainedThisTick = false;

  constructor(
    readonly curve: EnergyCurve,
    readonly tOverpressure: number,
    readonly overpressurePenalty: number,
    /** Seconds of charge lost per second per overlapping body. */
    readonly drainRate: number,
  ) {}

  get effectiveTime(): number {
    return Math.max(0, this.holdTime - this.drained);
  }

  get energy(): number {
    return this.curve.transform(this.effectiveTime);
  }

  get overpressureProgress(): number {
    return clamp01(this.holdTime / this.tOverpressure);
  }

  get overpressured(): boolean {
    return this.holdTime >= this.tOverpressure;
  }

  tick(dt: number, drainingBodies = 0): void {
    this.holdTime += dt;
    const loss = this.drainRate * dt * drainingBodies;
    this.drained += loss;
    this.drainedThisTick = loss > 0;
  }

  /** Energy delivered on release; an overpressured cloud fizzles. */
  releaseEnergy(): number {
    return this.overpressured ? this.energy * this.overpressurePenalty : this.energy;
  }
}
