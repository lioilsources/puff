#version 460 core
#include <flutter/runtime_effect.glsl>
precision mediump float;

// Final pass: scene + bloom + chromatic aberration + vignette.
uniform vec2 uSize;
uniform float uBloomIntensity;
uniform float uAberration;   // uv units at the screen edge
uniform float uVignette;     // 0..1
uniform float uFlash;        // 0..1 whole-screen flash
uniform vec3 uFlashColor;
uniform sampler2D uScene;
uniform sampler2D uBloom;
out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;
  vec2 suv = uv;
#ifdef IMPELLER_TARGET_OPENGLES
  suv.y = 1.0 - suv.y;
#endif
  vec2 fromCenter = uv - 0.5;
  float edge = dot(fromCenter, fromCenter) * 4.0; // 0 center .. 1 corners
  vec2 shift = fromCenter * uAberration * edge;

  float r = texture(uScene, suv + shift).r;
  vec4 mid = texture(uScene, suv);
  float b = texture(uScene, suv - shift).b;
  vec3 scene = vec3(r, mid.g, b);

  vec3 bloom = texture(uBloom, suv).rgb * uBloomIntensity;
  vec3 col = scene + bloom;

  float vig = 1.0 - smoothstep(0.35, 1.25, length(fromCenter) * 1.6);
  col *= mix(1.0, vig, uVignette);
  col += uFlashColor * uFlash;
  fragColor = vec4(col, 1.0);
}
