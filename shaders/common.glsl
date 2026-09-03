// Shared noise helpers. Included by the Puff shaders.
#ifndef PUFF_COMMON_GLSL
#define PUFF_COMMON_GLSL

float puffHash(vec2 p) {
  p = fract(p * vec2(123.34, 456.21));
  p += dot(p, p + 45.32);
  return fract(p.x * p.y);
}

float puffNoise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);
  float a = puffHash(i);
  float b = puffHash(i + vec2(1.0, 0.0));
  float c = puffHash(i + vec2(0.0, 1.0));
  float d = puffHash(i + vec2(1.0, 1.0));
  return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float puffFbm(vec2 p) {
  float v = 0.0;
  float amp = 0.5;
  for (int i = 0; i < 4; i++) {
    v += amp * puffNoise(p);
    p = p * 2.03 + vec2(17.1, 9.7);
    amp *= 0.5;
  }
  return v;
}

#endif
