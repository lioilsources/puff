#!/usr/bin/env python3
"""Build the launcher-icon masters from assets/icon/icon_source.png.

The source is a Display P3 PNG, 478x556, with a paper-grain cream background
and a soft grey vignette baked into the bottom-right corner. This normalises
it into what the stores want:

  assets/icon/icon.png             1024x1024 sRGB, no alpha, artwork at 84%
  assets/icon/icon_foreground.png  1024x1024, artwork at 60% for the Android
                                   adaptive safe zone

The cream tones (background, the pineapple's outline and its lattice) are all
collapsed to one exact colour, so padding the non-square source out to a
square leaves no seam. Run `dart run flutter_launcher_icons` afterwards.

    python3 tool/gen_icon.py
"""
from collections import Counter
from pathlib import Path
import io

from PIL import Image, ImageCms

ICON_DIR = Path(__file__).resolve().parent.parent / 'assets' / 'icon'
SIZE = 1024
CREAM_TOLERANCE = 46   # manhattan distance in RGB


def load_srgb(path):
    im = Image.open(path)
    icc = im.info.get('icc_profile')
    im = im.convert('RGB')
    if icc:
        im = ImageCms.profileToProfile(
            im, ImageCms.ImageCmsProfile(io.BytesIO(icc)),
            ImageCms.createProfile('sRGB'), outputMode='RGB')
    return im


def normalise(im):
    w, h = im.size
    px = im.load()
    bg = Counter(px[x, y] for y in range(3) for x in range(w)).most_common(1)[0][0]

    # Drop the grey vignette in the bottom-right corner; no artwork reaches here.
    for y in range(500, h):
        for x in range(430, w):
            p = px[x, y]
            if max(p) - min(p) < 60 and p[0] < 250:
                px[x, y] = bg

    for y in range(h):
        for x in range(w):
            p = px[x, y]
            if sum(abs(a - b) for a, b in zip(p, bg)) < CREAM_TOLERANCE:
                px[x, y] = bg
    return im, bg


def crop_artwork(im, bg):
    w, h = im.size
    px = im.load()
    xs = [x for y in range(h) for x in range(w) if px[x, y] != bg]
    ys = [y for y in range(h) for x in range(w) if px[x, y] != bg]
    return im.crop((min(xs), min(ys), max(xs) + 1, max(ys) + 1))


def compose(art, bg, ratio, path):
    aw, ah = art.size
    scale = (SIZE * ratio) / max(aw, ah)
    nw, nh = round(aw * scale), round(ah * scale)
    canvas = Image.new('RGB', (SIZE, SIZE), bg)
    canvas.paste(art.resize((nw, nh), Image.LANCZOS), ((SIZE - nw) // 2, (SIZE - nh) // 2))
    canvas.save(path)
    print(f'  {path.name}  {SIZE}x{SIZE}  artwork {ratio:.0%}')


def main():
    im, bg = normalise(load_srgb(ICON_DIR / 'icon_source.png'))
    art = crop_artwork(im, bg)
    print(f'background #{bg[0]:02X}{bg[1]:02X}{bg[2]:02X}, artwork {art.size[0]}x{art.size[1]}')
    compose(art, bg, 0.84, ICON_DIR / 'icon.png')
    compose(art, bg, 0.60, ICON_DIR / 'icon_foreground.png')


if __name__ == '__main__':
    main()
