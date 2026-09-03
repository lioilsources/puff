import 'sim/blast.dart';
import 'sim/energy.dart';

enum LoseRule { core, bottomEscape }

/// Every gameplay knob lives here. Change a value, hot reload, feel it.
///
/// Units: meters, seconds, kilograms (Forge2D world units).
abstract final class Tuning {
  // ---- World ---------------------------------------------------------------
  /// Fixed world width in meters; height follows the screen aspect ratio.
  static const double worldWidth = 9.0;

  /// Physics never steps more than this per frame (spiral-of-death guard).
  static const double maxDt = 1 / 30;

  // ---- Phase 0 test square (removed in Phase 1) ----------------------------
  static const double testSquareSize = 0.6;
  static const double testSquareSpeed = 2.5;

  // ---- Cloud ---------------------------------------------------------------
  static const double cloudRMin = 0.22;
  static const double cloudRMax = 1.45;
  static const double tOverpressure = 3.2;
  static const double easeInDuration = 0.3;
  static const double overpressurePenalty = 0.5;

  /// Position lag time constant: lag = lagBase + lagPerRadius * r (seconds).
  static const double lagBase = 0.04;
  static const double lagPerRadius = 0.11;

  /// Seconds of charge lost per second per body overlapping the cloud.
  static const double drainRate = 0.45;
  static const EnergyCurve energyCurve = PuffEnergyCurve(
    tOverpressure: tOverpressure,
    easeInDuration: easeInDuration,
  );

  // ---- Blast ---------------------------------------------------------------
  static const BlastParams blast = BlastParams(
    roeMin: 1.1,
    roeMax: 4.2,
    rMin: 0.25,
    falloffPower: 1.4,
    impulseScale: 11,
    torqueScale: 0.35,
  );

  /// Base impulse needed to fracture a 0.4 m square.
  static const double breakThreshold = 2.4;

  // ---- Shapes --------------------------------------------------------------
  static const double shapeMinSize = 0.26;
  static const double shapeMaxSize = 0.5;
  static const double metalChance = 0.3;
  static const double strokeWidth = 0.05;
  static const int maxBodies = 200;

  /// Bodies this far outside the visible world are removed.
  static const double despawnMargin = 1.6;

  // ---- Spawner -------------------------------------------------------------
  static const double spawnIntervalStart = 1.6;
  static const double spawnIntervalMin = 0.45;
  static const double spawnRampSeconds = 150;
  static const double spawnSpeedMin = 0.7;
  static const double spawnSpeedMax = 1.6;
  static const double spawnAngleJitter = 0.55;
  static const double spawnMargin = 0.7;
  static const int spawnInitialBurst = 4;

  // ---- Lose condition ------------------------------------------------------
  static const LoseRule loseRule = LoseRule.core;
  static const double coreRadius = 0.42;
  static const int coreHp = 5;
  static const int maxEscapes = 10;

  // ---- Fracture (Phase 3) --------------------------------------------------
  /// Generations allowed to split: spawned = 0, pieces = 1, pieces of pieces
  /// never split at maxDepth 2.
  static const int fractureMaxDepth = 2;
  static const double minFragmentSize = 0.11;
  static const double fractureOutwardSpeed = 1.6;
  static const double fractureSpin = 4.0;

  // ---- Modifiers (Phase 4) -------------------------------------------------
  static const double implosionPullMultiplier = 0.9;
  static const double implosionPopDelay = 0.38;
  static const double implosionPopFraction = 0.45;
  static const double magnetMultiplier = 1.5;
  static const double wellPopFraction = 0.3;
  static const double wellStrength = 9.0;
  static const double wellDurationMin = 1.6;
  static const double wellDurationPerEnergy = 2.4;
  static const double chainBlastFraction = 0.55;
  static const double chainImpulseFraction = 0.45;
  static const double chainMaxHop = 3.2;
  static const int chainMinTargets = 2;
  static const double chainTargetsPerEnergy = 5;
  static const double plasmaArcRange = 3.0;

  // ---- FX (Phase 5) --------------------------------------------------------
  /// Bodies faster than this (m/s) leave spark trails.
  static const double sparkTrailSpeed = 5.5;

  // ---- Score ---------------------------------------------------------------
  static const double pointsPerImpulse = 12;
  static const double comboWindow = 1.0;
  static const double comboStep = 0.15;
  static const double maxMultiplier = 4;

  /// Shape-shape contacts slower than this (m/s, relative) don't count.
  static const double comboHitSpeed = 2.0;
  static const int fractureBonus = 25;
}
