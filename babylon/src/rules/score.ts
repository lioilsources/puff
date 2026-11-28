// lib/game/sim/score.dart: points per impulse, combo for chain hits inside a window, fracture bonus.
/** Dart's double.round(): half away from zero (Math.round rounds half up). */
export const dartRound = (x: number): number => Math.sign(x) * Math.round(Math.abs(x));

export interface ScoreParams {
  pointsPerImpulse: number;
  comboWindow: number;
  comboStep: number;
  maxMultiplier: number;
  fractureBonus: number;
}

export class ScoreModel {
  score = 0;
  combo = 0;
  bestCombo = 0;
  bodiesDisplaced = 0;
  fractures = 0;
  private time = 0;
  private lastBlastTime = -Infinity;
  private lastHitTime = -Infinity;

  constructor(readonly p: ScoreParams) {}

  get multiplier(): number {
    return Math.min(this.p.maxMultiplier, Math.max(1, 1 + this.combo * this.p.comboStep));
  }

  get comboActive(): boolean {
    return this.time - this.lastHitTime <= this.p.comboWindow;
  }

  get comboRemaining(): number {
    if (!this.comboActive) return 0;
    return 1 - (this.time - this.lastHitTime) / this.p.comboWindow;
  }

  update(dt: number): void {
    this.time += dt;
    if (this.combo > 0 && !this.comboActive) this.combo = 0;
  }

  onBlast(): void {
    this.lastBlastTime = this.time;
  }

  onImpulse(magnitude: number): number {
    const points = dartRound(magnitude * this.p.pointsPerImpulse * this.multiplier);
    this.score += points;
    this.bodiesDisplaced += 1;
    return points;
  }

  onShapeHit(): void {
    const sinceBlast = this.time - this.lastBlastTime;
    const sinceHit = this.time - this.lastHitTime;
    if (sinceBlast <= this.p.comboWindow || sinceHit <= this.p.comboWindow) {
      this.combo += 1;
      if (this.combo > this.bestCombo) this.bestCombo = this.combo;
      this.lastHitTime = this.time;
    }
  }

  onFracture(): void {
    this.fractures += 1;
    this.score += dartRound(this.p.fractureBonus * this.multiplier);
  }
}
