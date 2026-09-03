#version 460 core
#include <flutter/runtime_effect.glsl>
precision mediump float;

uniform vec2 uSize;
uniform float uThreshold;
uniform float uKnee;
uniform sampler2D uScene;
out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;
#ifdef IMPELLER_TARGET_OPENGLES
  uv.y = 1.0 - uv.y;
#endif
  vec4 c = texture(uScene, uv);
  float lum = dot(c.rgb, vec3(0.2126, 0.7152, 0.0722));
  float w = smoothstep(uThreshold - uKnee, uThreshold + uKnee, lum);
  fragColor = vec4(c.rgb * w, c.a * w);
}
