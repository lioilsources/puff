#version 460 core
#include <flutter/runtime_effect.glsl>
#include "common.glsl"
precision mediump float;

// Drawn in world space over the visible world rect.
uniform vec2 uOrigin;     // rect origin in local coords
uniform vec2 uSize;       // rect size in local coords
uniform float uTime;
uniform float uEnv;       // 0 vacuum, 1 air, 2 water, 3 plasma
uniform float uFlash;     // plasma arc flash 0..1
uniform vec3 uBg;
uniform vec3 uBgAlt;
uniform vec3 uPrimary;
uniform vec3 uSecondary;
out vec4 fragColor;

void main() {
  vec2 uv = (FlutterFragCoord().xy - uOrigin) / uSize;
  float aspect = uSize.x / uSize.y;
  vec2 q = vec2(uv.x * aspect, uv.y);
  vec3 col = mix(uBgAlt, uBg, smoothstep(0.0, 1.0, uv.y * 0.8 + 0.1));
  float env = uEnv;

  if (env < 0.5) {
    // Vacuum: layered star field with slow twinkle.
    for (int layer = 0; layer < 2; layer++) {
      float scale = layer == 0 ? 42.0 : 90.0;
      vec2 g = q * scale + vec2(float(layer) * 7.3, uTime * (0.4 - 0.25 * float(layer)));
      vec2 cell = floor(g);
      vec2 f = fract(g) - 0.5;
      float h = puffHash(cell);
      if (h > 0.965) {
        float twinkle = 0.55 + 0.45 * sin(uTime * (1.5 + h * 4.0) + h * 40.0);
        float star = smoothstep(0.18, 0.0, length(f)) * twinkle;
        col += mix(uPrimary, uSecondary, h * 3.0 - 2.8) * star * (layer == 0 ? 0.8 : 0.45);
      }
    }
  } else if (env < 1.5) {
    // Air: faint drifting grid.
    vec2 g = fract(q * 6.0 + vec2(uTime * 0.03, uTime * 0.02));
    vec2 d = abs(g - 0.5);
    float line = smoothstep(0.47, 0.5, max(d.x, d.y));
    float soft = smoothstep(0.35, 0.5, max(d.x, d.y)) * 0.25;
    col += uPrimary * (line * 0.10 + soft * 0.02);
  } else if (env < 2.5) {
    // Water: caustics.
    float c1 = sin(q.x * 14.0 + uTime * 0.9) * sin(q.y * 11.0 - uTime * 1.1);
    float c2 = sin((q.x + q.y) * 9.0 - uTime * 0.7) * sin((q.x - q.y) * 13.0 + uTime * 0.5);
    float c = pow(max(0.0, (c1 + c2) * 0.5), 3.0);
    float n = puffFbm(q * 3.0 + vec2(0.0, uTime * 0.15));
    col += uPrimary * c * 0.16 + uSecondary * n * 0.04;
    col = mix(col, uBgAlt, 0.15 * uv.y);
  } else {
    // Plasma: electric noise with occasional flashes.
    float n = puffFbm(q * 4.0 + vec2(uTime * 0.6, -uTime * 0.4));
    float veins = pow(1.0 - abs(n * 2.0 - 1.0), 6.0);
    col += uPrimary * veins * 0.22 + uSecondary * n * 0.05;
    col += uPrimary * uFlash * 0.35;
  }

  // Gentle radial darkening toward the corners.
  float vig = 1.0 - 0.35 * smoothstep(0.3, 1.1, length((uv - 0.5) * vec2(1.0, 1.4)) * 1.5);
  fragColor = vec4(col * vig, 1.0);
}
