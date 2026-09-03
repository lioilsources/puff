import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'components/background.dart';
import 'components/cloud.dart';
import 'components/core.dart';
import 'components/debug_overlay.dart';
import 'components/hud.dart';
import 'components/shape_body.dart';
import 'components/spawner.dart';
import 'components/touch_layer.dart';
import 'fx/audio.dart';
import 'fx/fx_system.dart';
import 'fx/haptics.dart';
import 'fx/post_process.dart';
import 'fx/shaders.dart';
import 'input/demo_driver.dart';
import 'input/touch_controller.dart';
import 'palette.dart';
import 'physics/explosion.dart';
import 'physics/force_fields.dart';
import 'physics/fracture.dart';
import 'physics/modifiers.dart';
import 'sim/environment.dart';
import 'sim/explosion_event.dart';
import 'sim/fx_event.dart';
import 'sim/modifier.dart';
import 'sim/score.dart';
import 'sim/shapes.dart';
import 'tuning.dart';

enum GamePhase { menu, playing, paused, gameOver }

class PuffGame extends Forge2DGame {
  PuffGame({
    Palette? palette,
    Environment? environment,
    ModifierSpec? modifier,
    this.quality = PostProcessQuality.med,
    this.startInMenu = true,
    this.hapticsEnabled = true,
    this.soundEnabled = true,
    this.debugOverlayEnabled = false,
    this.onRunFinished,
    int? seed,
  }) : palette = palette ?? Palette.cyberpunk,
       environment = environment ?? Environment.vacuum,
       _initialModifier = modifier ?? ModifierSpec.pressure,
       random = math.Random(seed),
       super(gravity: (environment ?? Environment.vacuum).gravity());

  Palette palette;
  Environment environment;
  final ModifierSpec _initialModifier;
  PostProcessQuality quality;
  final bool startInMenu;
  final bool hapticsEnabled;
  final bool soundEnabled;
  final bool debugOverlayEnabled;

  /// Called with the final score when a run ends; returns true if it was a
  /// new best (shown on the game-over screen).
  final Future<bool> Function(PuffGame game, int score)? onRunFinished;
  final math.Random random;

  static const menuOverlay = 'menu';
  static const hudOverlay = 'hud';
  static const pauseOverlay = 'pause';
  static const gameOverOverlay = 'gameOver';
  static const settingsOverlay = 'settings';

  /// Scripted input for screenshots: `--dart-define=PUFF_DEMO=true`.
  static const bool demoMode = bool.fromEnvironment('PUFF_DEMO');

  /// Force the debug overlay on: `--dart-define=PUFF_DEBUG=true`.
  static const bool debugForced = bool.fromEnvironment('PUFF_DEBUG');

  late final ShapeFactory shapeFactory = ShapeFactory(
    random,
    baseBreakThreshold: Tuning.breakThreshold,
    metalChance: Tuning.metalChance,
  );
  final ScoreModel score = ScoreModel(
    pointsPerImpulse: Tuning.pointsPerImpulse,
    comboWindow: Tuning.comboWindow,
    comboStep: Tuning.comboStep,
    maxMultiplier: Tuning.maxMultiplier,
    fractureBonus: Tuning.fractureBonus,
  );
  late final Detonator detonator = Detonator(this, random);
  late final TouchController touch;
  late final Spawner spawner;
  late final Hud hud;
  late final FractureSystem fractureSystem;
  late final ModifierSystem modifiers;
  late final EnvironmentForces forces;
  late final FxSystem fx;
  late final AudioSystem audio;
  late final HapticsSystem haptics;
  DebugOverlay? _debugOverlay;
  Shaders? shaders;
  PuffPostProcess? postProcess;
  BackgroundLayer? background;
  Core? core;
  Cloud? cloud;

  GamePhase phase = GamePhase.playing;

  /// Live shapes, maintained by [ShapeBody] mount/remove.
  final Set<ShapeBody> shapes = {};
  int coreHp = Tuning.coreHp;
  int escapes = 0;
  double elapsed = 0;
  bool lastRunWasBest = false;

  /// Safe-area insets in logical pixels, set by the widget layer.
  double safeTop = 0;
  double safeBottom = 0;

  /// Visible world size in meters. Width is fixed, height follows the screen.
  Vector2 worldSize = Vector2(Tuning.worldWidth, Tuning.worldWidth);

  final List<void Function(ExplosionEvent)> explosionListeners = [];
  final List<void Function(FractureEvent)> fractureListeners = [];
  final List<void Function(ArcEvent)> arcListeners = [];
  final List<void Function(GamePhase)> phaseListeners = [];

  bool get isPlaying => phase == GamePhase.playing;

  /// Shapes that have a valid physics body right now.
  List<ShapeBody> get liveShapes => [
    for (final s in shapes)
      if (s.isLoaded && !s.isRemoving && s.body.isValid) s,
  ];

  @override
  Color backgroundColor() => palette.bg;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    metersToPixels = size.x / Tuning.worldWidth;
    worldSize = Vector2(Tuning.worldWidth, size.y / metersToPixels);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewfinder.position = Vector2.zero();
    camera.viewfinder.anchor = Anchor.center;

    shaders = await Shaders.load();

    touch = TouchController(
      onDown: _startCharge,
      onMove: _moveCharge,
      onUp: _release,
      onCancel: _release,
    );
    spawner = Spawner(random);
    hud = Hud();
    fractureSystem = FractureSystem(random);
    modifiers = ModifierSystem(random)..spec = _initialModifier;
    forces = EnvironmentForces(random);
    fx = FxSystem(random);
    audio = AudioSystem(random)..enabled = soundEnabled;
    haptics = HapticsSystem()..enabled = hapticsEnabled;

    background = BackgroundLayer();
    world.add(background!);
    if (Tuning.loseRule == LoseRule.core) {
      core = Core();
      world.add(core!);
    }
    camera.viewport.addAll([TouchLayer(), hud]);
    await addAll([spawner, fractureSystem, modifiers, forces, fx, audio, haptics]);
    if (demoMode) {
      add(DemoDriver(random));
    }
    _applyQuality();
    showDebugOverlay(debugOverlayEnabled || debugForced);

    phase = startInMenu ? GamePhase.menu : GamePhase.playing;
    _syncOverlays();
  }

  void showDebugOverlay(bool show) {
    final existing = _debugOverlay;
    if (show && existing == null) {
      _debugOverlay = DebugOverlay();
      camera.viewport.add(_debugOverlay!);
    } else if (!show && existing != null) {
      existing.removeFromParent();
      _debugOverlay = null;
    }
  }

  void _applyQuality() {
    final s = shaders;
    if (s == null || quality == PostProcessQuality.low) {
      postProcess = null;
      camera.postProcess = null;
      return;
    }
    final existing = postProcess;
    if (existing != null) {
      existing.quality = quality;
      return;
    }
    postProcess = PuffPostProcess(game: this, shaders: s, quality: quality);
    camera.postProcess = postProcess;
  }

  void setQuality(PostProcessQuality value) {
    quality = value;
    _applyQuality();
  }

  @override
  void update(double dt) {
    final clamped = math.min(dt, Tuning.maxDt);
    super.update(clamped);
    if (isPlaying) {
      elapsed += clamped;
      score.update(clamped);
    }
    final shake = fx.shake;
    camera.viewfinder.position = shake.offset;
    camera.viewfinder.angle = shake.angle;
    camera.viewfinder.zoom = shake.zoom;
  }

  // ---- Input (canvas coordinates, forwarded by TouchLayer) -----------------

  void onPointerDown(int pointerId, Vector2 canvasPosition) {
    switch (phase) {
      case GamePhase.playing:
        touch.pointerDown(pointerId, camera.globalToLocal(canvasPosition));
      case GamePhase.gameOver:
      case GamePhase.menu:
      case GamePhase.paused:
        break;
    }
  }

  void onPointerMove(int pointerId, Vector2 canvasPosition) {
    touch.pointerMove(pointerId, camera.globalToLocal(canvasPosition));
  }

  void onPointerUp(int pointerId) => touch.pointerUp(pointerId);

  void onPointerCancel(int pointerId) => touch.pointerCancel(pointerId);

  // ---- Charge / detonate ---------------------------------------------------

  void _startCharge(Vector2 position) {
    cloud?.removeFromParent();
    final c = Cloud(position: position, random: random);
    cloud = c;
    world.add(c);
  }

  void _moveCharge(Vector2 position) => cloud?.target.setFrom(position);

  void _release() {
    final c = cloud;
    if (c == null) {
      return;
    }
    _detonateCloud(c);
  }

  /// Called by the cloud itself when it has been held too long.
  void onOverpressure(Cloud c) {
    if (cloud != c) {
      return;
    }
    _detonateCloud(c);
  }

  void _detonateCloud(Cloud c) {
    cloud = null;
    c.removeFromParent();
    modifiers.release(
      c.position,
      c.charge.releaseEnergy(),
      fizzle: c.charge.overpressured,
    );
  }

  ExplosionEvent detonateAt(
    Vector2 position,
    double energy,
    ExplosionKind kind, {
    double directionSign = 1,
    double impulseMultiplier = 1,
    double? radiusOverride,
    bool Function(ShapeBody)? filter,
  }) {
    final event = detonator.detonate(
      position: position,
      energy: energy,
      kind: kind,
      directionSign: directionSign,
      impulseMultiplier: impulseMultiplier,
      radiusOverride: radiusOverride,
      filter: filter,
    );
    for (final listener in explosionListeners) {
      listener(event);
    }
    return event;
  }

  void emitFracture(FractureEvent event) {
    for (final listener in fractureListeners) {
      listener(event);
    }
  }

  void emitArc(ArcEvent event) {
    for (final listener in arcListeners) {
      listener(event);
    }
  }

  // ---- World events --------------------------------------------------------

  void registerShape(ShapeBody shape) => shapes.add(shape);

  void unregisterShape(ShapeBody shape) => shapes.remove(shape);

  void onShapeHit(ShapeBody a, ShapeBody b, double relativeSpeed) {
    if (isPlaying) {
      score.onShapeHit();
    }
  }

  void onCoreHit(ShapeBody shape) {
    if (!isPlaying) {
      return;
    }
    shape.removeFromParent();
    coreHp -= 1;
    fx.shake.addTrauma(0.35);
    postProcess?.addFlash(0.25, PaletteRole.hazard);
    audio.onCoreHit();
    haptics.onCoreHit();
    if (coreHp <= 0) {
      gameOver();
    }
  }

  void onShapeLeftBottom(ShapeBody shape) {
    if (Tuning.loseRule == LoseRule.bottomEscape && isPlaying) {
      escapes += 1;
      if (escapes >= Tuning.maxEscapes) {
        gameOver();
      }
    }
  }

  // ---- Phase control -------------------------------------------------------

  void _setPhase(GamePhase next) {
    if (phase == next) {
      return;
    }
    phase = next;
    for (final listener in phaseListeners) {
      listener(next);
    }
    _syncOverlays();
  }

  void _syncOverlays() {
    final wanted = switch (phase) {
      GamePhase.menu => {menuOverlay},
      GamePhase.playing => {hudOverlay},
      GamePhase.paused => {hudOverlay, pauseOverlay},
      GamePhase.gameOver => {gameOverOverlay},
    };
    for (final name in [menuOverlay, hudOverlay, pauseOverlay, gameOverOverlay, settingsOverlay]) {
      if (wanted.contains(name)) {
        overlays.add(name);
      } else {
        overlays.remove(name);
      }
    }
  }

  void startGame() {
    _clearRun();
    _setPhase(GamePhase.playing);
  }

  void pause() {
    if (!isPlaying) {
      return;
    }
    touch.reset();
    cloud?.removeFromParent();
    cloud = null;
    _setPhase(GamePhase.paused);
  }

  void resume() {
    if (phase == GamePhase.paused) {
      _setPhase(GamePhase.playing);
    }
  }

  void gameOver() {
    touch.reset();
    cloud?.removeFromParent();
    cloud = null;
    lastRunWasBest = false;
    final callback = onRunFinished;
    if (callback != null) {
      callback(this, score.score).then((best) {
        lastRunWasBest = best;
        // Re-show so the overlay picks up the flag.
        if (phase == GamePhase.gameOver) {
          overlays.remove(gameOverOverlay);
          overlays.add(gameOverOverlay);
        }
      });
    }
    _setPhase(GamePhase.gameOver);
  }

  void backToMenu() {
    _clearRun();
    _setPhase(GamePhase.menu);
  }

  void _clearRun() {
    touch.reset();
    for (final shape in shapes.toList()) {
      shape.removeFromParent();
    }
    cloud?.removeFromParent();
    cloud = null;
    score.reset();
    coreHp = Tuning.coreHp;
    escapes = 0;
    elapsed = 0;
    spawner.reset();
    modifiers.reset();
    forces.reset();
    fx.reset();
  }

  // ---- Run configuration ---------------------------------------------------

  void setEnvironment(Environment env) {
    environment = env;
    world.gravity = env.gravity();
    for (final shape in liveShapes) {
      shape.body.linearDamping = env.linearDamping;
      shape.body.angularDamping = env.angularDamping;
    }
  }

  void setModifier(ModifierSpec spec) {
    modifiers.spec = spec;
  }

  void setPalette(Palette value) {
    palette = value;
  }
}
