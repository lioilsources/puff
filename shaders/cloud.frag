#version 460 core
#include <flutter/runtime_effect.glsl>
#include "common.glsl"
precision mediump float;

// Drawn in world space as a square of side 2*uRadius around uCenter.
uniform vec2 uCenter;        // local (world) coords
uniform float uRadius;
uniform float uEnergy;       // 0..1
uniform float uTime;
uniform float uOverpressure; // 0..1 progress toward self-detonation
uniform float uDrain;        // 0/1 jitter when energy is being drained
uniform vec3 uColor;         // palette primary
uniform vec3 uAccent;        // palette glow
uniform vec3 uHazard;        // palette hazard
out vec4 fragColor;

void main() {
  vec2 p = (FlutterFragCoord().xy - uCenter) / uRadius;
  float r = length(p);
  if (r > 1.15) {
    fragColor = vec4(0.0);
    return;
  }
  float a = atan(p.y, p.x);
  float swirlSpeed = 0.6 + 1.8 * uEnergy;
  float n = puffFbm(vec2(a * 1.6 + uTime * 0.5, r * 3.2 - uTime * swirlSpeed));
  float n2 = puffFbm(p * 2.5 + vec2(uTime * 0.35, -uTime * 0.2));
  float noise = mix(n, n2, 0.5);

  // Soft body with internal swirl.
  float body = smoothstep(1.0, 0.45, r) * (0.30 + 0.45 * uEnergy);
  body *= 0.55 + 0.7 * noise;
  body += smoothstep(0.35, 0.0, r) * 0.25 * (0.6 + 0.4 * uEnergy);

  // Pulsing rim that speeds up with energy.
  float rimSpeed = 4.0 + 16.0 * uEnergy;
  float rimPos = 0.90 + 0.04 * sin(uTime * rimSpeed) + 0.03 * (noise - 0.5);
  float rim = exp(-pow((r - rimPos) * 14.0, 2.0));
  rim *= 0.65 + 0.35 * sin(uTime * rimSpeed * 1.7 + a * 3.0);

  // Near overpressure the rim flickers.
  float flicker = 1.0;
  if (uOverpressure > 0.72) {
    float rate = 14.0 + 50.0 * uOverpressure;
    flicker = 0.35 + 0.65 * step(0.45, fract(uTime * rate + noise));
  }
  float drainJitter = 1.0 - uDrain * 0.35 * step(0.5, fract(uTime * 37.0 + noise * 3.0));

  vec3 rimColor = mix(uAccent, uHazard, smoothstep(0.6, 1.0, uOverpressure));
  vec3 col = uColor * body + rimColor * rim * flicker * (0.9 + 0.6 * uEnergy);
  float alpha = clamp(body * 0.9 + rim * flicker, 0.0, 1.0) * smoothstep(1.12, 0.98, r) * drainJitter;
  fragColor = vec4(col * alpha, alpha);
}
