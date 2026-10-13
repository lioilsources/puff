import 'sim/blast.dart';
import 'sim/energy.dart';
import 'sim/heat.dart';

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

  // ---- Water ripples -------------------------------------------------------
  /// How fast a blast ring spreads across the surface, m/s.
  static const double waterRippleSpeed = 2.2;
  static const double waterRippleLife = 2.6;

  /// Half-width of the band around the front that pushes bodies, meters.
  static const double waterRippleWidth = 0.5;

  /// Peak force per kg a passing front applies. Deliberately small: the front
  /// should rock a shape, not throw it.
  static const double waterRippleNudge = 1.4;

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

  // ---- Heat: how a run escalates -------------------------------------------
  // Each knob below is `heatLerp(heat, cold, hot, over)`; the cold value is
  // the constant it extends, above. Spec: Prompts/PUFF_HEAT_PLAN.md.
  static const HeatCurve heat = HeatCurve();

  /// Spawn interval once heat passes 1 (the ramp above ends at 0.45).
  static const double spawnIntervalOver = 0.4;
  static const double shapeMinSizeHot = 0.32;
  static const double shapeMinSizeOver = 0.35;
  static const double shapeMaxSizeHot = 0.8;
  static const double shapeMaxSizeOver = 0.9;
  static const double metalChanceHot = 0.45;
  static const double metalChanceOver = 0.5;
  static const double spawnSpeedMaxHot = 2.3;
  static const double spawnSpeedMaxOver = 2.6;

  /// Kolos: one huge polygon that has to be cracked, not pushed.
  static const double kolosFromHeat = 0.6;
  static const double kolosInterval = 40;
  static const double kolosIntervalOver = 25;
  static const double kolosSizeMin = 1.1;
  static const double kolosSizeMax = 1.4;
  static const double kolosSizeOver = 1.5;
  static const double kolosSpeedMin = 0.5;
  static const double kolosSpeedMax = 0.8;

  /// How far inside the screen a Kolos must get where the medium damps it.
  static const double kolosReach = 2.5;

  /// Impulse that cracks a Kolos where the blast multiplier is 1; scaled by
  /// the environment's multiplier so it cracks in Water as it does in Air.
  static const double kolosBreak = 6.5;
  static const int kolosFractureDepth = 3;

  /// A Kolos and a volley need this much room under [maxBodies].
  static const int heatBodyReserve = 40;

  /// Above this many bodies nothing fractures deeper than [fractureMaxDepth].
  static const int deepFractureBodies = 140;

  /// Volley: several shapes from one edge, from tier III.
  static const double volleyInterval = 30;
  static const double volleyIntervalOver = 20;
  static const int volleyMin = 3;
  static const int volleyMax = 5;
  static const double volleyGap = 0.12;

  /// Blast radius and impulse multipliers.
  static const double blastRadiusHot = 1.24;
  static const double blastRadiusOver = 1.33;
  static const double blastImpulseHot = 1.27;
  static const double blastImpulseOver = 1.41;
  static const double cloudRMaxHot = 1.75;
  static const double cloudRMaxOver = 1.9;

  /// FX multipliers at heat 1 (and in overdrive where it differs).
  static const double fxParticlesHot = 1.6;
  static const double fxParticlesOver = 1.9;
  static const double fxParticleSpeedHot = 1.3;
  static const double fxShakeHot = 1.4;
  static const double fxShockwaveHot = 1.3;
  static const double fxFlashHot = 1.3;

  /// Energy needed for the zoom pulse and the heavy haptic drops by this.
  static const double fxThresholdDrop = 0.2;

  /// A second shockwave ring follows when energy * heat exceeds the first.
  static const double fxEchoThreshold = 0.6;
  static const double fxEchoDelay = 0.12;
  static const double bloomIntensity = 1.35;
  static const double bloomIntensityHot = 1.6;
  static const double bloomIntensityOver = 1.7;
  static const double aberration = 0.006;
  static const double aberrationHot = 0.010;
  static const double aberrationOver = 0.012;

  /// The low boom joins the release when energy * (1 + heat) passes this.
  static const double boomThreshold = 0.9;
  static const double tierToastSeconds = 1.5;

  static double blastRadiusScale(double heat) =>
      heatLerp(heat, 1, blastRadiusHot, blastRadiusOver);

  static double blastImpulseScale(double heat) =>
      heatLerp(heat, 1, blastImpulseHot, blastImpulseOver);

  // ---- Music ---------------------------------------------------------------
  /// Music level against SFX at 1.0: it sits under the blasts, never on top.
  static const double musicVolume = 0.55;

  /// Volume factor while the pause or game-over screen is up (about -6 dB).
  static const double musicDuck = 0.5;

  /// Fade times in seconds: between two tracks, on a skip, into and out of a
  /// duck, and when music is switched off.
  static const double musicCrossfade = 1.5;
  static const double musicSkipFade = 0.8;
  static const double musicDuckFade = 0.3;
  static const double musicOffFade = 0.5;

  /// How long the HUD shows the title of a new track, and its fade-out.
  static const double musicToastSeconds = 3;
  static const double musicToastFade = 0.6;
}
