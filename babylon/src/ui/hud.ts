// DOM overlay only (ESLint: no Babylon in ui/). The game passes plain numbers in.
export const byId = <T extends HTMLElement = HTMLElement>(id: string): T => document.getElementById(id) as T;

/** Store links: the web is a free demo next to the paid-free store app (plan 06, R4). */
export const STORES = {
  appStore: 'https://apps.apple.com/app/id6808586613',
  googlePlay: 'https://play.google.com/store/apps/details?id=com.ol1n.puff',
};

export class Hud {
  private readonly score = byId('score');
  private readonly mult = byId('mult');
  private readonly hp = byId('hp');
  private readonly press = byId('press');
  private last = '';

  update(score: number, multiplier: number, combo: number, hp: number, maxHp: number, pressure: number): void {
    const key = `${score}|${multiplier}|${combo}|${hp}|${pressure.toFixed(2)}`;
    if (key === this.last) return;
    this.last = key;
    this.score.textContent = String(score);
    this.mult.textContent = combo > 0 ? `×${multiplier.toFixed(2)}` : '';
    this.hp.textContent = '●'.repeat(Math.max(0, hp)) + '○'.repeat(Math.max(0, maxHp - hp));
    this.press.style.transform = `scaleX(${pressure})`;
    this.press.classList.toggle('hot', pressure > 0.8);
  }

  flash(): void {
    document.body.classList.remove('boom');
    void document.body.offsetWidth;
    document.body.classList.add('boom');
  }
}

export function showGameOver(score: number, bestCombo: number, again: () => void): void {
  const el = byId('over');
  byId('over-score').textContent = String(score);
  byId('over-stats').textContent = bestCombo > 0 ? `nejlepší combo ${bestCombo}` : '';
  byId<HTMLAnchorElement>('as').href = STORES.appStore;
  byId<HTMLAnchorElement>('gp').href = STORES.googlePlay;
  el.hidden = false;
  byId('again').onclick = () => {
    el.hidden = true;
    again();
  };
}
