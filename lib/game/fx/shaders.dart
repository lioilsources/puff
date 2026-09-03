import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Sequential uniform writer: uniforms are laid out in declaration order.
class UniformWriter {
  UniformWriter(this.shader);

  final FragmentShader shader;
  int _index = 0;

  void f(double value) => shader.setFloat(_index++, value);

  void v2(double x, double y) {
    f(x);
    f(y);
  }

  void v4(double x, double y, double z, double w) {
    f(x);
    f(y);
    f(z);
    f(w);
  }

  void color(Color c) {
    f(c.r);
    f(c.g);
    f(c.b);
  }
}

/// All fragment programs, loaded once. Null members mean the shader failed
/// to load; callers must fall back to plain canvas drawing.
class Shaders {
  Shaders._({
    required this.cloud,
    required this.shockwave,
    required this.bloomExtract,
    required this.bloomBlur,
    required this.composite,
    required this.background,
  });

  final FragmentProgram cloud;
  final FragmentProgram shockwave;
  final FragmentProgram bloomExtract;
  final FragmentProgram bloomBlur;
  final FragmentProgram composite;
  final FragmentProgram background;

  static Future<Shaders?> load() async {
    try {
      final programs = await Future.wait([
        FragmentProgram.fromAsset('shaders/cloud.frag'),
        FragmentProgram.fromAsset('shaders/shockwave.frag'),
        FragmentProgram.fromAsset('shaders/bloom_extract.frag'),
        FragmentProgram.fromAsset('shaders/bloom_blur.frag'),
        FragmentProgram.fromAsset('shaders/composite.frag'),
        FragmentProgram.fromAsset('shaders/background.frag'),
      ]);
      return Shaders._(
        cloud: programs[0],
        shockwave: programs[1],
        bloomExtract: programs[2],
        bloomBlur: programs[3],
        composite: programs[4],
        background: programs[5],
      );
    } catch (error, stack) {
      debugPrint('Puff: shaders failed to load, falling back: $error\n$stack');
      return null;
    }
  }
}
