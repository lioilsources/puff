#version 460 core
#include <flutter/runtime_effect.glsl>
precision mediump float;

// Separable 9-tap gaussian. uDirection is the texel step in uv units.
uniform vec2 uSize;
uniform vec2 uDirection;
uniform sampler2D uInput;
out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;
#ifdef IMPELLER_TARGET_OPENGLES
  uv.y = 1.0 - uv.y;
#endif
  vec4 sum = texture(uInput, uv) * 0.227027;
  vec2 d1 = uDirection * 1.384615;
  vec2 d2 = uDirection * 3.230769;
  sum += texture(uInput, uv + d1) * 0.316216;
  sum += texture(uInput, uv - d1) * 0.316216;
  sum += texture(uInput, uv + d2) * 0.070270;
  sum += texture(uInput, uv - d2) * 0.070270;
  fragColor = sum;
}
