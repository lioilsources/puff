#version 460 core
#include <flutter/runtime_effect.glsl>
precision mediump float;

// Full-screen pass in image pixel space: displaces the scene radially around
// up to four expanding rings.
uniform vec2 uSize;
uniform float uCount;      // active rings (0..4)
uniform vec4 uRing0;       // center.xy (uv), radius (uv, x-scaled), strength
uniform vec4 uRing1;
uniform vec4 uRing2;
uniform vec4 uRing3;
uniform float uWidth;      // gaussian width in uv
uniform sampler2D uScene;
out vec4 fragColor;

vec2 ringOffset(vec4 ring, vec2 uv, float aspect) {
  vec2 d = uv - ring.xy;
  d.x *= aspect;
  float dist = length(d);
  float g = exp(-pow((dist - ring.z) / uWidth, 2.0));
  vec2 dir = dist > 1e-5 ? d / dist : vec2(0.0);
  dir.x /= aspect;
  return dir * g * ring.w;
}

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;
  float aspect = uSize.x / uSize.y;
  vec2 offset = vec2(0.0);
  if (uCount > 0.5) offset += ringOffset(uRing0, uv, aspect);
  if (uCount > 1.5) offset += ringOffset(uRing1, uv, aspect);
  if (uCount > 2.5) offset += ringOffset(uRing2, uv, aspect);
  if (uCount > 3.5) offset += ringOffset(uRing3, uv, aspect);
  vec2 suv = clamp(uv + offset, vec2(0.0), vec2(1.0));
#ifdef IMPELLER_TARGET_OPENGLES
  suv.y = 1.0 - suv.y;
#endif
  vec4 c = texture(uScene, suv);
  // Brighten the ring itself a touch.
  float glow = length(offset) * 18.0;
  fragColor = vec4(c.rgb + glow * c.rgb, c.a);
}
