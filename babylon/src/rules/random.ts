// Random sources. Unseeded play uses Math.random; a seed gives the Dart-identical
// sequence of LcgRandom in tool/dump_vectors.dart, so golden vectors can replay the
// rules that draw from a Random (Spawner, FlightPath.random) draw for draw.

/** What the rules draw from: dart:math Random's surface. */
export interface GameRandom {
  nextDouble(): number;
  nextInt(max: number): number;
  nextBool(): boolean;
}

/** Seeded LCG, bit-identical to the Dart `Lcg` in tool/dump_vectors.dart (Math.imul keeps it exact). */
export function lcg(seed: number): () => number {
  let s = Math.trunc(seed) & 0x7fffffff;
  return () => (s = (Math.imul(s, 1103515245) + 12345) & 0x7fffffff);
}

const UNIT = 1 << 30;

/** A GameRandom; seeded = Dart LcgRandom (demo rides, tests, ?seed), unseeded = Math.random. */
export function gameRandom(seed?: number): GameRandom {
  if (seed === undefined) {
    return {
      nextDouble: () => Math.random(),
      nextInt: (max) => Math.floor(Math.random() * max),
      nextBool: () => Math.random() < 0.5,
    };
  }
  const r = lcg(seed);
  return {
    nextDouble: () => (r() % UNIT) / UNIT,
    nextInt: (max) => r() % max,
    nextBool: () => r() % 2 === 0,
  };
}
