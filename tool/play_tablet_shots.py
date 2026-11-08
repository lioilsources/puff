#!/usr/bin/env python3
"""Frame the Play phone screenshots for the 7" and 10" tablet slots.

Puff is portrait-only and renders the same scene at any width, so a tablet
shot is the phone frame on a wider 10:16 canvas. The side margins are the
same frame, scaled to cover, blurred and darkened, so the starfield runs on
instead of ending in black bars. Output is RGB (Play rejects nothing for
alpha here, but the icon rule is easier to keep everywhere).

    python3 tool/play_tablet_shots.py

Reads store/play/screenshots/*.png, writes store/play/tablet/*.png at
1600x2560 — inside Play's 320..3840 px and 2:1 limits, and fine for both the
7-inch and the 10-inch slot.
"""
from pathlib import Path

from PIL import Image, ImageEnhance, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "store/play/screenshots"
OUT = ROOT / "store/play/tablet"
W, H = 1600, 2560


def frame(src: Path) -> Image.Image:
    shot = Image.open(src).convert("RGB")
    # Background: cover-fill, blur, darken.
    scale = max(W / shot.width, H / shot.height)
    bg = shot.resize((round(shot.width * scale), round(shot.height * scale)),
                     Image.LANCZOS)
    left, top = (bg.width - W) // 2, (bg.height - H) // 2
    bg = bg.crop((left, top, left + W, top + H)).filter(
        ImageFilter.GaussianBlur(40))
    bg = ImageEnhance.Brightness(bg).enhance(0.45)
    # Foreground: the phone frame at full canvas height, centred.
    fg = shot.resize((round(shot.width * H / shot.height), H), Image.LANCZOS)
    bg.paste(fg, ((W - fg.width) // 2, 0))
    return bg


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    for src in sorted(SRC.glob("*.png")):
        dst = OUT / src.name
        frame(src).save(dst, optimize=True)
        print(f"{dst.relative_to(ROOT)}  {W}x{H}")


if __name__ == "__main__":
    main()
