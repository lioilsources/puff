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
uniform float uWind;      // air wind phase -1..1
// Water blast rings: xy centre and z radius in q units, w amplitude (0 = none).
uniform vec4 uRipple0;
uniform vec4 uRipple1;
uniform vec4 uRipple2;
uniform vec3 uBg;
uniform vec3 uBgAlt;
uniform vec3 uPrimary;
uniform vec3 uSecondary;
out vec4 fragColor;

// Crests of one expanding ring, plus the outward direction they push in.
// Returns (wave, wave * direction) so callers can both light the crest and
// drag the water underneath it.
vec3 puffRipple(vec2 q, vec4 ring) {
  vec2 delta = q - ring.xy;
  float d = max(length(delta), 1e-4);
  float offset = d - ring.z;
  // A short packet of crests riding the front, thinning as the ring grows.
  float envelope = exp(-offset * offset * 420.0) * ring.w / (0.6 + ring.z);
  float wave = sin(offset * 150.0) * envelope;
  return vec3(wave, delta * (wave / d));
}

void main() {
  vec2 uv = (FlutterFragCoord().xy - uOrigin) / uSize;
  float aspect = uSize.x / uSize.y;
  vec2 q = vec2(uv.x * aspect, uv.y);
  vec3 col = mix(uBgAlt, uBg, smoothstep(0.0, 1.0, uv.y * 0.8 + 0.1));
  float env = uEnv;

  if (env < 0.5) {
    // Vacuum: a nebula band, three parallax star layers, the odd meteor.
    vec2 drift = vec2(uTime * 0.006, uTime * 0.003);
    float band = smoothstep(0.55, 0.0, abs(q.y - 0.45 - 0.16 * sin(q.x * 1.3 + 0.6)));
    float neb = puffFbm(q * 1.7 + drift);
    float grain = puffFbm(q * 3.6 - drift * 2.0 + 9.4);
    col += mix(uSecondary, uPrimary, grain)
         * pow(smoothstep(0.25, 0.85, neb * 0.7 + grain * 0.4), 1.8) * band * 0.34;

    for (int layer = 0; layer < 3; layer++) {
      float fl = float(layer);
      vec2 g = q * (30.0 + fl * 34.0)
             + vec2(uTime * (0.30 - 0.09 * fl) + fl * 7.3, fl * 4.1);
      vec2 cell = floor(g);
      float h = puffHash(cell);
      float seed = smoothstep(0.945, 1.0, h);
      if (seed > 0.0) {
        vec2 f = fract(g) - 0.5 - (puffHash2(cell + 5.7) - 0.5) * 0.7;
        float r = length(f);
        float twinkle = 0.55 + 0.45 * sin(uTime * (1.3 + seed * 3.5) + h * 60.0);
        float star = smoothstep(0.12, 0.0, r) + smoothstep(0.4, 0.0, r) * 0.18;
        // Diffraction spikes, brightest stars only.
        float spike = smoothstep(0.34, 0.0, abs(f.x)) * smoothstep(0.08, 0.0, abs(f.y))
                    + smoothstep(0.34, 0.0, abs(f.y)) * smoothstep(0.08, 0.0, abs(f.x));
        spike *= smoothstep(0.55, 1.0, seed) * 0.4;
        col += mix(uPrimary, uSecondary, seed) * (star + spike) * twinkle * (0.95 - 0.22 * fl);
      }
    }

    // One meteor per cycle, and only for about half of them.
    float cycle = uTime / 9.0;
    vec2 mseed = puffHash2(vec2(floor(cycle), 3.0));
    float ph = fract(cycle);
    vec2 dir = normalize(vec2(1.0, 0.45 + mseed.y * 0.4));
    vec2 rel = q - (vec2(-0.4 + mseed.x * 0.6, -0.15) + dir * ph * 2.4);
    float along = dot(rel, dir);
    float perp = abs(dot(rel, vec2(-dir.y, dir.x)));
    float trail = exp(-perp * 110.0) * smoothstep(0.5, 0.0, -along) * step(along, 0.0)
                + smoothstep(0.035, 0.0, length(rel));
    col += mix(uPrimary, uSecondary, 0.3) * trail * step(0.5, mseed.y)
         * smoothstep(0.0, 0.08, ph) * smoothstep(1.0, 0.8, ph) * 0.8;
  } else if (env < 1.5) {
    // Air: haze banks and dust carried by the same wind the bodies feel.
    vec2 flow = vec2(uTime * 0.05 + uWind * 0.08, uTime * 0.01);
    float h1 = puffFbm(vec2(q.x * 1.5, q.y * 3.2) + flow);
    float h2 = puffFbm(vec2(q.x * 3.4, q.y * 6.4) - flow * 1.7 + 12.0);
    col += mix(uPrimary, uSecondary, h2) * smoothstep(0.34, 0.86, h1 * 0.75 + h2 * 0.4) * 0.22;

    // Gusts: one thin streak per row, jittered and sliding downwind.
    float sy = q.y * 15.0;
    float row = floor(sy);
    float rh = puffHash(vec2(row, 7.0));
    float rh2 = puffHash(vec2(row, 19.0));
    float profile = smoothstep(0.04 + rh2 * 0.04, 0.0, abs(fract(sy) - 0.5 - (rh - 0.5) * 0.7));
    float slide = q.x * (1.1 + rh) - uTime * (0.25 + rh2 * 0.5) - uWind * 0.6 + rh * 13.0;
    float gust = pow(smoothstep(0.5, 1.0, puffNoise(vec2(slide * 2.0, row * 3.7))), 2.5);
    col += mix(uPrimary, uSecondary, 0.2) * profile * gust * 0.20;

    for (int layer = 0; layer < 2; layer++) {
      float fl = float(layer);
      vec2 g = q * (11.0 + fl * 15.0)
             + vec2(uTime * (0.5 + 0.55 * fl) + uWind * (1.2 + fl),
                    -uTime * (0.10 + 0.06 * fl) + fl * 6.0);
      vec2 cell = floor(g);
      float h = puffHash(cell);
      float on = smoothstep(0.9, 0.98, h);
      if (on > 0.0) {
        vec2 f = fract(g) - 0.5 - (puffHash2(cell + 2.3) - 0.5) * 0.7;
        f.y += 0.08 * sin(uTime * (0.8 + h * 2.0) + h * 30.0);
        float r = length(f);
        float mote = smoothstep(0.08, 0.0, r) + smoothstep(0.22, 0.0, r) * 0.15;
        col += mix(uSecondary, uPrimary, h) * mote * on * (0.55 - 0.2 * fl);
      }
    }
  } else if (env < 2.5) {
    // Water: caustics off the surface, light shafts, bubbles on their way up.
    float depth = uv.y;
    vec3 rings = puffRipple(q, uRipple0)
               + puffRipple(q, uRipple1)
               + puffRipple(q, uRipple2);
    vec2 w = q + rings.yz * 0.012
           + vec2(sin(q.y * 9.0 + uTime * 0.7) * 0.02,
                  sin(q.x * 7.0 - uTime * 0.5) * 0.015);
    float c1 = sin(w.x * 41.0 + uTime * 1.1) * sin(w.y * 33.0 - uTime * 0.9);
    float c2 = sin((w.x + w.y) * 29.0 - uTime * 0.8) * sin((w.x - w.y) * 47.0 + uTime * 0.6);
    float caustic = pow(smoothstep(0.25, 0.95, (c1 + c2) * 0.5), 2.5)
                  * (0.4 + 0.6 * puffNoise(w * 4.0 + vec2(0.0, uTime * 0.2)));
    col += uPrimary * caustic * mix(0.8, 0.08, smoothstep(0.0, 0.9, depth));

    // Light spilling in through the surface.
    col += mix(uPrimary, uSecondary, 0.4) * smoothstep(0.3, 0.0, depth) * 0.09;

    // Shafts angling down from the surface.
    float shaft = puffNoise(vec2((q.x + depth * 0.45) * 9.0, uTime * 0.1));
    col += mix(uPrimary, uSecondary, 0.3)
         * pow(smoothstep(0.5, 1.0, shaft), 2.0) * smoothstep(1.05, 0.1, depth) * 0.14;

    for (int layer = 0; layer < 2; layer++) {
      float fl = float(layer);
      vec2 g = q * (6.5 + fl * 9.0) + vec2(fl * 11.0, uTime * (0.9 + 0.5 * fl));
      vec2 cell = floor(g);
      float h = puffHash(cell);
      float on = smoothstep(0.85, 0.94, h);
      if (on > 0.0) {
        vec2 f = fract(g) - 0.5 - (puffHash2(cell + 4.1) - 0.5) * 0.7;
        f.x += 0.09 * sin(uTime * (1.2 + h * 2.5) + h * 25.0);
        float r = length(f);
        float rad = 0.05 + 0.06 * h;
        float ring = smoothstep(rad, rad * 0.7, r) * smoothstep(rad * 0.45, rad * 0.7, r);
        float halo = smoothstep(rad * 2.0, 0.0, r) * 0.2;
        col += mix(uPrimary, uSecondary, 0.25) * (ring * 0.4 + halo) * on * (0.7 - 0.25 * fl);
      }
    }

    // The rings themselves, bright on the crest and dark in the trough.
    col += mix(uPrimary, uSecondary, 0.35) * rings.x * 0.10;

    // Depth swallows the light.
    col = mix(col, uBg * 0.75, smoothstep(0.35, 1.0, depth) * 0.4);
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
