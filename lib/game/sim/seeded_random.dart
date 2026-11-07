import 'dart:math' as math;

/// A [math.Random] that can be restarted from a seed.
///
/// Systems take their generator once, at construction. The weekly challenge
/// has to restart the spawn sequence at the start of every run, so it swaps
/// the generator underneath them instead of rebuilding them.
class SeededRandom implements math.Random {
  SeededRandom([int? seed]) : _inner = math.Random(seed);

  math.Random _inner;

  /// Restarts the sequence: the same [seed] yields the same numbers.
  void reseed(int seed) => _inner = math.Random(seed);

  /// Leaves the fixed sequence for an unpredictable one.
  void shuffle() => _inner = math.Random();

  @override
  bool nextBool() => _inner.nextBool();

  @override
  double nextDouble() => _inner.nextDouble();

  @override
  int nextInt(int max) => _inner.nextInt(max);
}
