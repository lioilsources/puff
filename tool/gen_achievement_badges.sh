#!/usr/bin/env bash
# Renders the Game Center achievement images (512x512 RGB PNG, no alpha) from
# tool/achievement_badges.html into store/gamecenter/achievements/<id>.png.
# The id is the part after `puff.ach.`. Needs Google Chrome and ImageMagick.
set -euo pipefail
cd "$(dirname "$0")/.."

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
IDS=(first_run combo_x4 combo_40 perfect_release heat_3 overdrive untouchable
  shatter_50 all_environments all_modifiers all_palettes runs_10 runs_50 weekly)
OUT=store/gamecenter/achievements
TMP=$(mktemp -d)
mkdir -p "$OUT"
for id in "${IDS[@]}"; do
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --window-size=512,512 --virtual-time-budget=4000 \
    --screenshot="$TMP/$id.png" "file://$PWD/tool/achievement_badges.html#$id" >/dev/null 2>&1
  magick "$TMP/$id.png" -crop 512x512+0+0 +repage -alpha off -colorspace sRGB "PNG24:$OUT/$id.png"
  echo "  $id"
done
rm -rf "$TMP"
