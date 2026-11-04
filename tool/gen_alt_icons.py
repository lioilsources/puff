#!/usr/bin/env python3
"""Draw the alternate app icons for the App Store icon A/B test.

Product Page Optimization can only test icons that ship in the build, so each
variant here also becomes an `AppIcon-<Name>.appiconset` in the iOS asset
catalog. Every variant is one object, neon on near-black, no text, and has to
read at 60x60 — big shapes, thick strokes, few of them.

  assets/icon/alt/<name>.png                              1024x1024 master
  ios/Runner/Assets.xcassets/AppIcon-<Name>.appiconset/   single-size set

    python3 tool/gen_alt_icons.py
"""
import json
import math
import random
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
OUT_DIR = ROOT / 'assets' / 'icon' / 'alt'
CATALOG = ROOT / 'ios' / 'Runner' / 'Assets.xcassets'
SIZE = 1024
SS = 2                       # supersampling
S = SIZE * SS

# The Cyberpunk palette, as the game draws it.
BG_CENTER = (26, 20, 58)
BG_EDGE = (6, 5, 16)
CYAN = (34, 230, 255)
MAGENTA = (255, 45, 122)
YELLOW = (244, 240, 0)
WHITE = (240, 252, 255)


def background():
    """Radial falloff from a deep violet centre to near-black corners."""
    small = Image.new('RGB', (256, 256))
    px = small.load()
    for y in range(256):
        for x in range(256):
            d = min(1.0, math.hypot(x - 128, y - 128) / 181)
            t = d ** 1.4
            px[x, y] = tuple(round(c + (e - c) * t) for c, e in zip(BG_CENTER, BG_EDGE))
    return small.resize((S, S), Image.BICUBIC)


def glow(layer, radii=(6, 24, 70), gains=(1.0, 0.9, 0.7)):
    """Bloom: the sharp layer plus blurred copies of it, added together."""
    out = layer.copy()
    for r, g in zip(radii, gains):
        blurred = layer.filter(ImageFilter.GaussianBlur(r * SS))
        if g != 1.0:
            blurred = blurred.point(lambda v, g=g: min(255, round(v * g)))
        out = ImageChops.add(out, blurred)
    return out


def compose(*layers):
    im = background()
    for layer in layers:
        im = ImageChops.add(im, layer)
    return im.resize((SIZE, SIZE), Image.LANCZOS)


def ring(draw, c, r, width, colour):
    draw.ellipse([c[0] - r, c[1] - r, c[0] + r, c[1] + r], outline=colour, width=width)


def shard(draw, c, angle, length, width, colour):
    """A thin rotated rectangle, the way the game draws a flying shard."""
    dx, dy = math.cos(angle), math.sin(angle)
    nx, ny = -dy, dx
    hl, hw = length / 2, width / 2
    pts = [(c[0] + dx * a + nx * b, c[1] + dy * a + ny * b)
           for a, b in ((-hl, -hw), (hl, -hw), (hl, hw), (-hl, hw))]
    draw.polygon(pts, fill=colour)


def blast():
    """The release: a yellow core ring and a ring of cyan shards flying out."""
    rng = random.Random(7)
    c = (S / 2, S / 2)
    shards = Image.new('RGB', (S, S))
    d = ImageDraw.Draw(shards)
    n = 22
    for i in range(n):
        a = i / n * math.tau + rng.uniform(-0.08, 0.08)
        dist = rng.uniform(0.27, 0.40) * S
        p = (c[0] + math.cos(a) * dist, c[1] + math.sin(a) * dist)
        shard(d, p, a + rng.uniform(-0.25, 0.25), rng.uniform(0.07, 0.12) * S,
              rng.uniform(0.026, 0.036) * S, CYAN)
    core = Image.new('RGB', (S, S))
    d = ImageDraw.Draw(core)
    ring(d, c, 0.14 * S, round(0.035 * S), YELLOW)
    ring(d, c, 0.055 * S, round(0.026 * S), YELLOW)
    return compose(glow(shards, gains=(0.9, 0.6, 0.45)), glow(core))


def cloud():
    """The charge: the pressure cloud with its bright rim, about to go."""
    c = (S / 2, S / 2)
    r = 0.33 * S
    body = Image.new('L', (S, S))
    ImageDraw.Draw(body).ellipse([c[0] - r, c[1] - r, c[0] + r, c[1] + r], fill=255)
    body = body.filter(ImageFilter.GaussianBlur(0.05 * S))
    fill = Image.new('RGB', (S, S))
    fill.paste(tuple(round(v * 0.38) for v in CYAN), mask=body)
    rim = Image.new('RGB', (S, S))
    d = ImageDraw.Draw(rim)
    ring(d, c, r, round(0.04 * S), CYAN)
    core = Image.new('RGB', (S, S))
    d = ImageDraw.Draw(core)
    ring(d, c, 0.075 * S, round(0.03 * S), YELLOW)
    return compose(fill, glow(rim), glow(core, radii=(6, 22), gains=(1.0, 0.8)))


def shatter():
    """The hit: a magenta square cracked in two, the halves flying apart."""
    c = (S / 2, S / 2)
    half = 0.24 * S
    # A zigzag crack from the top edge to the bottom edge, in unit square space.
    crack = [(0.15, -1), (-0.12, -0.35), (0.18, 0.2), (-0.1, 1)]
    left = [(-1, -1)] + crack + [(-1, 1)]
    right = [(1, 1)] + crack[::-1] + [(1, -1)]

    def place(poly, shift, tilt):
        out = []
        for x, y in poly:
            x, y = x * half, y * half
            x, y = x * math.cos(tilt) - y * math.sin(tilt), x * math.sin(tilt) + y * math.cos(tilt)
            out.append((c[0] + x + shift[0] * S, c[1] + y + shift[1] * S))
        return out

    layer = Image.new('RGB', (S, S))
    d = ImageDraw.Draw(layer)
    w = round(0.036 * S)
    for poly in (place(left, (-0.07, 0.03), 0.07), place(right, (0.07, -0.03), 0.07)):
        d.line(poly + [poly[0], poly[1]], fill=MAGENTA, width=w, joint='curve')
    sparks = Image.new('RGB', (S, S))
    d = ImageDraw.Draw(sparks)
    for (x, y), a in (((0.5, 0.17), 1.4), ((0.52, 0.5), 1.75), ((0.49, 0.83), 1.55)):
        shard(d, (x * S, y * S), a, 0.06 * S, 0.026 * S, CYAN)
    return compose(glow(layer), glow(sparks, gains=(0.8, 0.5, 0.35)))


VARIANTS = {
    'Blast': blast,
    'Cloud': cloud,
    'Shatter': shatter,
}


def write_appiconset(name, image):
    folder = CATALOG / f'AppIcon-{name}.appiconset'
    folder.mkdir(parents=True, exist_ok=True)
    image.save(folder / 'icon-1024.png')
    contents = {
        'images': [{'filename': 'icon-1024.png', 'idiom': 'universal',
                    'platform': 'ios', 'size': '1024x1024'}],
        'info': {'author': 'xcode', 'version': 1},
    }
    (folder / 'Contents.json').write_text(json.dumps(contents, indent=2) + '\n')


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    for name, draw in VARIANTS.items():
        image = draw()
        image.save(OUT_DIR / f'{name.lower()}.png')
        write_appiconset(name, image)
        print(f'{name}: {OUT_DIR / (name.lower() + ".png")}')


if __name__ == '__main__':
    main()
