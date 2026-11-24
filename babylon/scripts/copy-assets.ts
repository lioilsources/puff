// npm run assets (runs before dev/build): copies what the web uses from the Flutter app's assets/
// unchanged into public/assets/ (gitignored), so the web never keeps a second copy in git.
// F0 spike: shapes are vector, no audio yet, nothing to copy. F3: SFX (assets/audio/*.wav, 1 MB),
// music only streamed after the first frame (24 MB, see PORT.md).
import { rmSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const dst = fileURLToPath(new URL('../public/assets/', import.meta.url));
rmSync(dst, { recursive: true, force: true });
console.log('assets: vector only (F0), nothing copied');
