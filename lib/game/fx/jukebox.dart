import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../puff_game.dart';
import '../sim/jukebox.dart';
import '../tuning.dart';

/// Background music: one theme per environment, a menu theme, a game-over
/// sting. The rules of what plays live in [Jukebox]; this owns the engine.
///
/// Music runs on SoLoud, next to `flame_audio` for the SFX. `audioplayers`
/// cannot loop a compressed file without a gap or fade one player into
/// another; SoLoud does both and leaves the platform audio session alone, so
/// the two engines do not fight over it.
///
/// A track that fails to load is skipped silently: the game plays without it.
class JukeboxSystem extends Component with HasGameReference<PuffGame> {
  JukeboxSystem(math.Random random) : _rules = Jukebox(random);

  final Jukebox _rules;

  /// The looping track that is audible right now, for the widget layer.
  final ValueNotifier<Track?> nowPlaying = ValueNotifier(null);

  /// Reserved for music that follows the charge or the combo. Unused.
  double intensity = 0;

  bool _enabled = true;
  /// Null until the engine is up; stays null when it cannot be loaded, and
  /// every call below turns into a no-op.
  SoLoud? _engine;
  bool _started = false;
  bool _suspended = false;

  final Map<Track, Future<AudioSource?>> _sources = {};
  Track? _track;
  SoundHandle? _handle;
  int _generation = 0;
  double _toast = 0;

  bool get enabled => _enabled;
  set enabled(bool value) {
    if (_enabled == value) {
      return;
    }
    _enabled = value;
    _sync(Tuning.musicOffFade);
  }

  /// Whether a run ends on the sting; the SFX layer then keeps its own
  /// game-over sound quiet.
  bool get playsSting => _active;

  /// `♪ TITLE` while a freshly started track is being announced, else empty.
  String get toastText {
    final title = nowPlaying.value?.title ?? '';
    return _toast > 0 && title.isNotEmpty ? '♪ ${title.toUpperCase()}' : '';
  }

  double get toastOpacity => (_toast / Tuning.musicToastFade).clamp(0.0, 1.0);

  @override
  Future<void> onLoad() async {
    game.phaseListeners.add(onPhase);
    try {
      final engine = SoLoud.instance;
      if (!engine.isInitialized) {
        await engine.init();
      }
      _engine = engine;
    } catch (error) {
      debugPrint('Puff: music unavailable: $error');
    }
  }

  @override
  void onRemove() {
    game.phaseListeners.remove(onPhase);
    _generation++;
    _stop(_handle, 0);
    _handle = null;
    super.onRemove();
  }

  @override
  void update(double dt) {
    if (!_started) {
      // The game settles its first phase after the components have loaded.
      _started = true;
      _sync(Tuning.musicCrossfade);
    }
    if (_toast > 0) {
      _toast = math.max(0, _toast - dt);
    }
  }

  void onPhase(GamePhase phase) {
    _sync(Tuning.musicDuckFade);
    if (phase == GamePhase.gameOver) {
      _sting(Track.gameOver);
    }
  }

  /// Jump to the other track of the current environment.
  void skip() {
    final env = _track?.environment;
    if (!_active || env == null) {
      return;
    }
    _crossfadeTo(_rules.next(env), Tuning.musicSkipFade);
  }

  /// The app left the foreground: the audio thread would keep playing.
  void suspend() => _setSuspended(true);

  void resume() => _setSuspended(false);

  bool get _ready => _engine != null;

  /// Only reached behind [_ready]: a handle or a wanted track implies it.
  SoLoud get _soloud => _engine!;

  bool get _active => _enabled && _ready;

  bool get _ducked => game.phase == GamePhase.paused || game.phase == GamePhase.gameOver;

  double get _volume => Tuning.musicVolume * (_ducked ? Tuning.musicDuck : 1);

  /// What the current phase wants to hear. A run keeps the track that is
  /// already playing as long as the environment is the same: runs are short,
  /// and restarting the theme on every retry would loop its first bars.
  Track? _wanted() {
    if (!_active) {
      return null;
    }
    if (game.phase == GamePhase.menu) {
      return Track.menu;
    }
    final env = game.environment.kind;
    final current = _track;
    return current != null && current.environment == env ? current : _rules.pickFor(env);
  }

  void _sync(double fade) {
    if (!_started) {
      return;
    }
    final wanted = _wanted();
    if (wanted != _track) {
      _crossfadeTo(wanted, wanted == null ? fade : Tuning.musicCrossfade);
      return;
    }
    final handle = _handle;
    if (handle != null) {
      _guard(() => _soloud.fadeVolume(handle, _volume, _seconds(fade)));
    }
  }

  void _crossfadeTo(Track? track, double fade) {
    final generation = ++_generation;
    _stop(_handle, fade);
    _handle = null;
    _track = track;
    if (track == null) {
      nowPlaying.value = null;
      return;
    }
    _load(track).then((source) {
      if (source == null || generation != _generation) {
        if (generation == _generation) {
          nowPlaying.value = null;
        }
        return;
      }
      _guard(() {
        final handle = _soloud.play(source, volume: 0, looping: true, paused: _suspended);
        _soloud.setProtectVoice(handle, true);
        _soloud.fadeVolume(handle, _volume, _seconds(fade));
        _handle = handle;
        nowPlaying.value = track;
        _toast = game.phase == GamePhase.menu ? 0 : Tuning.musicToastSeconds;
      });
    });
  }

  void _sting(Track track) {
    if (!_active) {
      return;
    }
    final generation = _generation;
    _load(track).then((source) {
      if (source == null || generation != _generation || _suspended || !_active) {
        return;
      }
      _guard(() => _soloud.play(source, volume: Tuning.musicVolume));
    });
  }

  Future<AudioSource?> _load(Track track) => _sources.putIfAbsent(track, () async {
    try {
      // Streamed from disk: decoding ten two-minute loops into memory would
      // cost a few hundred megabytes.
      return await _soloud.loadAsset(track.asset, mode: LoadMode.disk);
    } catch (error) {
      debugPrint('Puff: music ${track.id} unavailable: $error');
      return null;
    }
  });

  void _stop(SoundHandle? handle, double fade) {
    if (handle == null || !_ready) {
      return;
    }
    _guard(() {
      if (fade <= 0 || _suspended) {
        _soloud.stop(handle).ignore();
        return;
      }
      _soloud.fadeVolume(handle, 0, _seconds(fade));
      _soloud.scheduleStop(handle, _seconds(fade));
    });
  }

  void _setSuspended(bool value) {
    if (_suspended == value) {
      return;
    }
    _suspended = value;
    final handle = _handle;
    if (handle != null && _ready) {
      _guard(() => _soloud.setPause(handle, value));
    }
  }

  void _guard(void Function() call) {
    try {
      call();
    } catch (error) {
      debugPrint('Puff: music call failed: $error');
    }
  }

  static Duration _seconds(double s) => Duration(milliseconds: (s * 1000).round());
}
