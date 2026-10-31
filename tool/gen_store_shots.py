#!/usr/bin/env python3
"""Render the first three store screenshots with localized captions.

Search results show the icon, the name, the subtitle and the first one to
three screenshots, so those carry a caption a thumbnail can read: big, at most
four words, the last of them in the accent colour. The game frame sits under
the caption on a blurred, darkened copy of itself; the frame is identical in
every locale, only the caption changes.

  store/appstore/captions.json   captions per locale, Play language map

App Store (default):
  store/appstore/raw/<n>_<slug>.png      1320x2868 simulator frames (iPhone 17 Pro Max)
  build/store_shots/<locale>/<n>_<slug>.png   1320x2868 = App Store 6.9"
  One folder per App Store locale code, the layout `fastlane deliver` reads.

Google Play (--play):
  store/play/screenshots/puff_<n>_*.png  1080x1920 emulator frames
  build/store_shots/play/<language>/<n>_<slug>.png   1080x1920 (Play allows
  at most 2:1, so the iPhone frames cannot be reused)

    python3 tool/gen_store_shots.py [--play] [locale ...]
"""
import json
import sys
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
SPEC = ROOT / 'store' / 'appstore' / 'captions.json'
OUT = ROOT / 'build' / 'store_shots'

TARGETS = {
    'appstore': dict(size=(1320, 2868), frame_scale=0.84, caption_top=120,
                     caption_width=1180, corner=70, max_font=168,
                     raw_dir=ROOT / 'store' / 'appstore' / 'raw', raw_key='raw', out=OUT),
    'play': dict(size=(1080, 1920), frame_scale=0.78, caption_top=70,
                 caption_width=980, corner=48, max_font=124,
                 raw_dir=ROOT / 'store' / 'play' / 'screenshots', raw_key='play_raw',
                 out=OUT / 'play'),
}
MAX_LINES = 2

WHITE = (255, 255, 255)
ACCENTS = {
    'yellow': (244, 240, 0),
    'cyan': (34, 230, 255),
    'magenta': (255, 45, 122),
}

SF = '/System/Library/Fonts/SFNS.ttf'
FONTS = {
    'ja': ('/System/Library/Fonts/ヒラギノ角ゴシック W8.ttc', 0, None),
    'ko': ('/System/Library/Fonts/AppleSDGothicNeo.ttc', 6, None),
}


def font(locale, size):
    path, index, variation = FONTS.get(locale, (SF, 0, b'Heavy'))
    f = ImageFont.truetype(path, size, index=index)
    if variation:
        f.set_variation_by_name(variation)
    return f


def tokens(caption):
    """Split a caption into (text, accented) words; '|' starts the accent."""
    plain, _, accent = caption.partition('|')
    words = [(w, False) for w in plain.split()]
    words += [(w, True) for w in accent.split()]
    return words


def is_cjk(locale):
    return locale in ('ja', 'zh-Hans', 'zh-Hant')


def layout(t, locale, caption):
    """Largest font size at which the caption fits in MAX_LINES lines."""
    words = tokens(caption)
    sep = '' if is_cjk(locale) else ' '
    limit = t['caption_width']
    for size in range(t['max_font'], 40, -4):
        f = font(locale, size)
        space = f.getlength(sep)
        lines, line, width = [], [], 0
        for text, acc in words:
            w = f.getlength(text)
            extra = w if not line else space + w
            if line and width + extra > limit:
                lines.append(line)
                line, width = [], 0
                extra = w
            if w > limit:
                break
            line.append((text, acc))
            width += extra
        else:
            lines.append(line)
            if len(lines) <= MAX_LINES:
                return f, space, lines
    raise ValueError(f'{locale}: caption does not fit: {caption!r}')


def draw_caption(t, canvas, locale, caption, accent):
    w, h = t['size']
    f, space, lines = layout(t, locale, caption)
    ascent, descent = f.getmetrics()
    line_h = round((ascent + descent) * 1.05)
    text = Image.new('RGB', (w, h))
    d = ImageDraw.Draw(text)
    glow = Image.new('RGB', (w, h))
    g = ImageDraw.Draw(glow)
    block_h = line_h * len(lines)
    y = t['caption_top'] + (MAX_LINES * line_h - block_h) // 2
    for line in lines:
        width = sum(f.getlength(s) for s, _ in line) + space * (len(line) - 1)
        x = (w - width) / 2
        for s, acc in line:
            colour = accent if acc else WHITE
            d.text((x, y), s, font=f, fill=colour)
            if acc:
                g.text((x, y), s, font=f, fill=colour)
            x += f.getlength(s) + space
        y += line_h
    blur = round(18 * w / 1320)
    glow = glow.filter(ImageFilter.GaussianBlur(blur)).point(lambda v: round(v * 0.8))
    canvas = ImageChops.add(canvas, glow)
    return ImageChops.lighter(canvas, text), t['caption_top'] + MAX_LINES * line_h


def compose(t, raw, locale, caption, accent):
    w, h = t['size']
    k = w / 1320                      # scale of strokes and blurs
    frame = Image.open(raw).convert('RGB')
    if frame.size != (w, h):
        frame = frame.resize((w, h), Image.LANCZOS)
    # Background: the same frame, blurred and pushed down so the caption reads.
    bg = frame.filter(ImageFilter.GaussianBlur(round(40 * k))).point(lambda v: round(v * 0.45))
    canvas, caption_bottom = draw_caption(t, bg, locale, caption, accent)

    fw = round(w * t['frame_scale'])
    fh = round(h * t['frame_scale'])
    top = max(caption_bottom + round(40 * k), h - fh)
    small = frame.resize((fw, fh), Image.LANCZOS)
    corner = t['corner']
    mask = Image.new('L', (fw, fh))
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, fw - 1, fh - 1], corner, fill=255)
    x = (w - fw) // 2
    # A thin neon rim in the accent colour, glowing onto the background.
    pad = max(2, round(4 * k))
    rim = Image.new('RGB', (w, h))
    ImageDraw.Draw(rim).rounded_rectangle([x - pad, top - pad, x + fw + pad - 1, top + fh + pad - 1],
                                          corner + pad, outline=accent, width=max(3, round(6 * k)))
    canvas = ImageChops.add(canvas, rim.filter(ImageFilter.GaussianBlur(round(22 * k))))
    canvas = ImageChops.add(canvas, rim.point(lambda v: round(v * 0.6)))
    canvas.paste(small, (x, top), mask)
    return canvas


def captions_for(locales, locale):
    entry = locales[locale]
    if isinstance(entry, dict):
        return captions_for(locales, entry['copy'])
    return entry


def main(argv):
    play = '--play' in argv
    argv = [a for a in argv if a != '--play']
    t = TARGETS['play' if play else 'appstore']
    spec = json.loads(SPEC.read_text())
    locales = spec['locales']
    # Output folder name -> caption locale.
    names = spec['play_locales'] if play else {l: l for l in locales}
    for name in argv or list(names):
        captions = captions_for(locales, names[name])
        folder = t['out'] / name
        folder.mkdir(parents=True, exist_ok=True)
        for shot, caption in zip(spec['shots'], captions):
            image = compose(t, t['raw_dir'] / shot[t['raw_key']], names[name], caption,
                            ACCENTS[shot['accent']])
            image.save(folder / shot['raw'], optimize=True)
        print(f'{name}: {len(captions)} shots in {folder}')


if __name__ == '__main__':
    main(sys.argv[1:])
