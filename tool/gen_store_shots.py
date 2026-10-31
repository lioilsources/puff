#!/usr/bin/env python3
"""Render the first three App Store screenshots with localized captions.

Search results show the icon, the name, the subtitle and the first one to
three screenshots, so those carry a caption a thumbnail can read: big, at most
four words, the last of them in the accent colour. The game frame sits under
the caption on a blurred, darkened copy of itself; the frame is identical in
every locale, only the caption changes.

  store/appstore/raw/<n>_<slug>.png   1320x2868 simulator frames (iPhone 17 Pro Max)
  store/appstore/captions.json        captions per App Store locale
  build/store_shots/<locale>/<n>_<slug>.png   1320x2868 = App Store 6.9"

The output folders are laid out the way `fastlane deliver` reads them
(`screenshots_path`), one folder per App Store locale code.

    python3 tool/gen_store_shots.py [locale ...]
"""
import json
import sys
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / 'store' / 'appstore'
OUT = ROOT / 'build' / 'store_shots'

W, H = 1320, 2868
FRAME_SCALE = 0.84            # game frame width as a share of the canvas
CAPTION_TOP = 120             # first caption line starts here
CAPTION_WIDTH = 1180
CORNER = 70                   # frame corner radius at canvas scale
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


def layout(locale, caption):
    """Largest font size at which the caption fits in MAX_LINES lines."""
    words = tokens(caption)
    sep = '' if is_cjk(locale) else ' '
    for size in range(168, 60, -4):
        f = font(locale, size)
        space = f.getlength(sep)
        lines, line, width = [], [], 0
        for text, acc in words:
            w = f.getlength(text)
            extra = w if not line else space + w
            if line and width + extra > CAPTION_WIDTH:
                lines.append(line)
                line, width = [], 0
                extra = w
            if w > CAPTION_WIDTH:
                break
            line.append((text, acc))
            width += extra
        else:
            lines.append(line)
            if len(lines) <= MAX_LINES:
                return f, space, lines
    raise ValueError(f'{locale}: caption does not fit: {caption!r}')


def draw_caption(canvas, locale, caption, accent):
    f, space, lines = layout(locale, caption)
    ascent, descent = f.getmetrics()
    line_h = round((ascent + descent) * 1.05)
    text = Image.new('RGB', (W, H))
    d = ImageDraw.Draw(text)
    glow = Image.new('RGB', (W, H))
    g = ImageDraw.Draw(glow)
    block_h = line_h * len(lines)
    y = CAPTION_TOP + (MAX_LINES * line_h - block_h) // 2
    for line in lines:
        width = sum(f.getlength(t) for t, _ in line) + space * (len(line) - 1)
        x = (W - width) / 2
        for t, acc in line:
            colour = accent if acc else WHITE
            d.text((x, y), t, font=f, fill=colour)
            if acc:
                g.text((x, y), t, font=f, fill=colour)
            x += f.getlength(t) + space
        y += line_h
    glow = glow.filter(ImageFilter.GaussianBlur(18)).point(lambda v: round(v * 0.8))
    canvas = ImageChops.add(canvas, glow)
    return ImageChops.lighter(canvas, text), CAPTION_TOP + MAX_LINES * line_h


def compose(raw, locale, caption, accent):
    frame = Image.open(raw).convert('RGB')
    if frame.size != (W, H):
        frame = frame.resize((W, H), Image.LANCZOS)
    # Background: the same frame, blurred and pushed down so the caption reads.
    bg = frame.filter(ImageFilter.GaussianBlur(40)).point(lambda v: round(v * 0.45))
    canvas, caption_bottom = draw_caption(bg, locale, caption, accent)

    fw = round(W * FRAME_SCALE)
    fh = round(H * FRAME_SCALE)
    top = max(caption_bottom + 40, H - fh)
    small = frame.resize((fw, fh), Image.LANCZOS)
    mask = Image.new('L', (fw, fh))
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, fw - 1, fh - 1], CORNER, fill=255)
    x = (W - fw) // 2
    # A thin neon rim in the accent colour, glowing onto the background.
    rim = Image.new('RGB', (W, H))
    ImageDraw.Draw(rim).rounded_rectangle([x - 4, top - 4, x + fw + 3, top + fh + 3],
                                          CORNER + 4, outline=accent, width=6)
    canvas = ImageChops.add(canvas, rim.filter(ImageFilter.GaussianBlur(22)))
    canvas = ImageChops.add(canvas, rim.point(lambda v: round(v * 0.6)))
    canvas.paste(small, (x, top), mask)
    return canvas


def captions_for(locales, locale):
    entry = locales[locale]
    if isinstance(entry, dict):
        return captions_for(locales, entry['copy'])
    return entry


def main(argv):
    spec = json.loads((SRC / 'captions.json').read_text())
    locales = spec['locales']
    wanted = argv or list(locales)
    for locale in wanted:
        captions = captions_for(locales, locale)
        folder = OUT / locale
        folder.mkdir(parents=True, exist_ok=True)
        for shot, caption in zip(spec['shots'], captions):
            image = compose(SRC / 'raw' / shot['raw'], locale, caption,
                            ACCENTS[shot['accent']])
            image.save(folder / shot['raw'], optimize=True)
        print(f'{locale}: {len(captions)} shots in {folder}')


if __name__ == '__main__':
    main(sys.argv[1:])
