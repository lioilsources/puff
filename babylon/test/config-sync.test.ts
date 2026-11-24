// The generated palette must stay in sync with lib/game/palette.dart (tuning.json is diffed by CI).
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';
import { paletteSource } from '../scripts/gen-palette';

describe('generated', () => {
  it('ui/generated/palette.ts matches lib/game/palette.dart (npm run gen)', () => {
    const now = readFileSync(fileURLToPath(new URL('../src/ui/generated/palette.ts', import.meta.url)), 'utf8');
    expect(now).toBe(paletteSource());
  });
});
