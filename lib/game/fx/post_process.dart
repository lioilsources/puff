import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/post_process.dart';

import '../palette.dart';
import '../puff_game.dart';
import 'shaders.dart';

enum PostProcessQuality { low, med, high }

/// An expanding ring distortion in world space.
class Shockwave {
  Shockwave({required this.position, required this.energy});

  final Vector2 position;
  final double energy;
  double t = 0;

  double get duration => 0.45 + 0.45 * energy;
  double get progress => (t / duration).clamp(0.0, 1.0);
  bool get finished => t >= duration;

  /// Ring radius in meters.
  double get radius => (0.3 + 4.5 * energy) * math.pow(progress, 0.6);

  double get strength => 0.018 * (0.3 + energy) * (1 - progress) * (1 - progress);
}

/// Scene -> [shockwave] -> bloom extract (1/2) -> blur (1/4, H+V) ->
/// composite (scene + bloom + aberration + vignette).
class PuffPostProcess extends PostProcess {
  PuffPostProcess({
    required this.game,
    required this.shaders,
    required PostProcessQuality quality,
  }) : _quality = quality,
       super(pixelRatio: _pixelRatioFor(quality)) {
    _shock = shaders.shockwave.fragmentShader();
    _extract = shaders.bloomExtract.fragmentShader();
    _blur = shaders.bloomBlur.fragmentShader();
    _composite = shaders.composite.fragmentShader();
  }

  final PuffGame game;
  final Shaders shaders;
  PostProcessQuality _quality;

  PostProcessQuality get quality => _quality;
  set quality(PostProcessQuality value) {
    _quality = value;
    pixelRatio = _pixelRatioFor(value);
  }

  static double _pixelRatioFor(PostProcessQuality q) {
    final dpr = PlatformDispatcher.instance.views.first.devicePixelRatio;
    return switch (q) {
      PostProcessQuality.high => dpr,
      PostProcessQuality.med => dpr * 0.75,
      PostProcessQuality.low => dpr,
    };
  }

  late final FragmentShader _shock;
  late final FragmentShader _extract;
  late final FragmentShader _blur;
  late final FragmentShader _composite;

  final List<Shockwave> shockwaves = [];
  double flash = 0;
  PaletteRole flashRole = PaletteRole.glow;

  double bloomThreshold = 0.42;
  double bloomKnee = 0.18;
  double bloomIntensity = 1.35;
  double aberration = 0.006;
  double vignette = 0.55;
  double shockWidth = 0.035;

  void addShockwave(Vector2 position, double energy) {
    if (shockwaves.length >= 4) {
      shockwaves.removeAt(0);
    }
    shockwaves.add(Shockwave(position: position.clone(), energy: energy));
  }

  void addFlash(double amount, PaletteRole role) {
    if (amount > flash) {
      flash = amount.clamp(0.0, 1.0);
      flashRole = role;
    }
  }

  @override
  void update(double dt) {
    for (final s in shockwaves) {
      s.t += dt;
    }
    shockwaves.removeWhere((s) => s.finished);
    flash = math.max(0, flash - dt * 3.5);
  }

  final _paint = Paint();

  @override
  void postProcess(Vector2 size, Canvas canvas) {
    if (_quality == PostProcessQuality.low) {
      renderSubtree(canvas);
      return;
    }
    final w = math.max(1, (size.x * pixelRatio).ceil());
    final h = math.max(1, (size.y * pixelRatio).ceil());
    final images = <Image>[];

    // 1. Scene at (scaled) device resolution.
    final recorder = PictureRecorder();
    final sceneCanvas = Canvas(recorder);
    sceneCanvas.scale(pixelRatio);
    renderSubtree(sceneCanvas);
    final picture = recorder.endRecording();
    var scene = picture.toImageSync(w, h);
    picture.dispose();
    images.add(scene);

    // 2. Shockwave distortion, only while rings are alive.
    if (shockwaves.isNotEmpty) {
      final u = UniformWriter(_shock);
      u.v2(w.toDouble(), h.toDouble());
      u.f(shockwaves.length.toDouble());
      for (var i = 0; i < 4; i++) {
        if (i < shockwaves.length) {
          final s = shockwaves[i];
          final screen = game.camera.localToGlobal(s.position);
          u.v4(
            screen.x / size.x,
            screen.y / size.y,
            s.radius * game.metersToPixels / size.y,
            s.strength,
          );
        } else {
          u.v4(0, 0, 0, 0);
        }
      }
      u.f(shockWidth);
      _shock.setImageSampler(0, scene);
      scene = _pass(_shock, w, h);
      images.add(scene);
    }

    // 3. Bloom extract at half res.
    final bw = math.max(1, w ~/ 2);
    final bh = math.max(1, h ~/ 2);
    UniformWriter(_extract)
      ..v2(bw.toDouble(), bh.toDouble())
      ..f(bloomThreshold)
      ..f(bloomKnee);
    _extract.setImageSampler(0, scene);
    var blur = _pass(_extract, bw, bh);
    images.add(blur);

    // 4. Separable blur at quarter res.
    final qw = math.max(1, w ~/ 4);
    final qh = math.max(1, h ~/ 4);
    final iterations = _quality == PostProcessQuality.high ? 2 : 1;
    for (var i = 0; i < iterations; i++) {
      UniformWriter(_blur)
        ..v2(qw.toDouble(), qh.toDouble())
        ..v2(1.0 / qw, 0);
      _blur.setImageSampler(0, blur);
      blur = _pass(_blur, qw, qh);
      images.add(blur);
      UniformWriter(_blur)
        ..v2(qw.toDouble(), qh.toDouble())
        ..v2(0, 1.0 / qh);
      _blur.setImageSampler(0, blur);
      blur = _pass(_blur, qw, qh);
      images.add(blur);
    }

    // 5. Composite onto the camera canvas in logical pixels.
    final flashColor = game.palette.byRole(flashRole);
    UniformWriter(_composite)
      ..v2(size.x, size.y)
      ..f(bloomIntensity)
      ..f(aberration)
      ..f(vignette)
      ..f(flash)
      ..color(flashColor);
    _composite.setImageSampler(0, scene);
    _composite.setImageSampler(1, blur);
    _paint.shader = _composite;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), _paint);

    for (final image in images) {
      image.dispose();
    }
  }

  Image _pass(FragmentShader shader, int w, int h) {
    final recorder = PictureRecorder();
    final c = Canvas(recorder);
    _paint.shader = shader;
    c.drawRect(Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()), _paint);
    final picture = recorder.endRecording();
    final image = picture.toImageSync(w, h);
    picture.dispose();
    return image;
  }
}
