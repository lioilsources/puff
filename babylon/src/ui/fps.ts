// DOM overlay only (ESLint: no Babylon in ui/). The game passes numbers in.
export function showFps(el: HTMLElement, fps: number): void {
  el.hidden = false;
  el.textContent = `${fps.toFixed(0)} fps`;
}
