import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

import '../puff_game.dart';
import '../sim/environment.dart';
import '../sim/explosion_event.dart';
import '../sim/fx_event.dart';

/// All SFX are synthesized placeholders (see tool/gen_sfx.dart).
///
/// - Charge: five pre-baked seamless loops, switched as energy rises.
/// - Release: low/mid/high layered thump+crack+tail; water uses muffled takes.
/// - Fracture: three glass ticks picked at random for pitch variety.
class AudioSystem extends Component with HasGameReference<PuffGame> {
  AudioSystem(this.random);

  final math.Random random;
  bool enabled = true;
  double volume = 1;

  bool _ready = false;
  final List<AudioPool> _fracturePools = [];
  AudioPool? _arcPool;
  AudioPool? _clickPool;

  int _chargeStage = 0;
  int _chargeGeneration = 0;
  AudioPlayer? _chargePlayer;

  static const _files = [
    'charge_1.wav',
    'charge_2.wav',
    'charge_3.wav',
    'charge_4.wav',
    'charge_5.wav',
    'release_low.wav',
    'release_mid.wav',
    'release_high.wav',
    'release_water_low.wav',
    'release_water_mid.wav',
    'release_water_high.wav',
    'fizzle.wav',
    'implosion.wav',
    'fracture_1.wav',
    'fracture_2.wav',
    'fracture_3.wav',
    'arc.wav',
    'core_hit.wav',
    'ui_click.wav',
    'game_over.wav',
  ];

  @override
  Future<void> onLoad() async {
    game.explosionListeners.add(onExplosion);
    game.fractureListeners.add(onFracture);
    game.arcListeners.add(onArc);
    game.phaseListeners.add(onPhase);
    try {
      await FlameAudio.audioCache.loadAll(_files);
      for (final f in ['fracture_1.wav', 'fracture_2.wav', 'fracture_3.wav']) {
        _fracturePools.add(await FlameAudio.createPool(f, maxPlayers: 3));
      }
      _arcPool = await FlameAudio.createPool('arc.wav', maxPlayers: 3);
      _clickPool = await FlameAudio.createPool('ui_click.wav', maxPlayers: 2);
      _ready = true;
    } catch (error) {
      debugPrint('Puff: audio unavailable: $error');
    }
  }

  @override
  void onRemove() {
    game.explosionListeners.remove(onExplosion);
    game.fractureListeners.remove(onFracture);
    game.arcListeners.remove(onArc);
    game.phaseListeners.remove(onPhase);
    _stopCharge();
    super.onRemove();
  }

  bool get _active => enabled && _ready;

  void _play(String file, double v) {
    if (!_active) {
      return;
    }
    FlameAudio.play(file, volume: (v * volume).clamp(0.0, 1.0)).catchError((Object e) {
      debugPrint('Puff: play $file failed: $e');
      return Future<AudioPlayer>.error(e);
    }).ignore();
  }

  void _pool(AudioPool? pool, double v) {
    if (!_active || pool == null) {
      return;
    }
    pool.start(volume: (v * volume).clamp(0.0, 1.0)).ignore();
  }

  void click() => _pool(_clickPool, 0.6);

  void onExplosion(ExplosionEvent e) {
    final energy = e.energy;
    switch (e.kind) {
      case ExplosionKind.fizzle:
        _play('fizzle.wav', 0.7);
        return;
      case ExplosionKind.implosion:
        _play('implosion.wav', 0.8);
        return;
      case ExplosionKind.pressure:
      case ExplosionKind.magnet:
      case ExplosionKind.gravityWell:
      case ExplosionKind.chainSpark:
        break;
    }
    final water = game.environment.kind == EnvironmentKind.water;
    final tier = energy < 0.35
        ? 'low'
        : energy < 0.7
        ? 'mid'
        : 'high';
    _play(water ? 'release_water_$tier.wav' : 'release_$tier.wav', 0.45 + 0.55 * energy);
  }

  void onFracture(FractureEvent f) {
    if (_fracturePools.isEmpty) {
      return;
    }
    _pool(_fracturePools[random.nextInt(_fracturePools.length)], 0.55);
  }

  void onArc(ArcEvent a) => _pool(_arcPool, 0.5 + 0.3 * a.energy);

  void onCoreHit() => _play('core_hit.wav', 0.9);

  void onPhase(GamePhase phase) {
    if (phase == GamePhase.gameOver) {
      _play('game_over.wav', 0.8);
    }
    if (phase != GamePhase.playing) {
      _stopCharge();
    }
  }

  @override
  void update(double dt) {
    final cloud = game.cloud;
    final stage = (!_active || cloud == null || !game.isPlaying)
        ? 0
        : 1 + (cloud.energy * 4.999).floor().clamp(0, 4);
    if (stage != _chargeStage) {
      _chargeStage = stage;
      _stopCharge();
      if (stage > 0) {
        _startCharge(stage);
      }
    }
  }

  void _startCharge(int stage) {
    final generation = ++_chargeGeneration;
    FlameAudio.loop('charge_$stage.wav', volume: (0.45 * volume).clamp(0.0, 1.0)).then((player) {
      if (generation != _chargeGeneration) {
        player.stop().ignore();
        player.dispose().ignore();
        return;
      }
      _chargePlayer = player;
    }).catchError((Object e) {
      debugPrint('Puff: charge loop failed: $e');
    });
  }

  void _stopCharge() {
    _chargeGeneration++;
    final p = _chargePlayer;
    _chargePlayer = null;
    if (p != null) {
      p.stop().ignore();
      p.dispose().ignore();
    }
  }
}
