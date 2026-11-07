#!/usr/bin/env bash
# Renders the alternate app icons picked in the icon picker (7 Nov 2026) from
# tool/icon_designs.html and installs them for the App Store icon test.
#
#   assets/icon/alt/<name>.png                              1024 master, RGB
#   ios/Runner/Assets.xcassets/AppIcon-<Name>.appiconset/   single-size set
#   store/play/icon_tests/<name>_512.png                    Play experiments
#
# Order is Ol1n's priority; Product Page Optimization takes up to three.
# Needs Google Chrome (headless, loads the Audiowide font from Google Fonts)
# and ImageMagick.
set -euo pipefail
cd "$(dirname "$0")/.."

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
PICKS=(B4:Flash C4:Halves D4:Well E3:Wordmark G3:Orbit H3:Charged F4:Pulse A3:Waves)
TMP=$(mktemp -d)
mkdir -p assets/icon/alt store/play/icon_tests

for pick in "${PICKS[@]}"; do
  id=${pick%%:*}; Name=${pick##*:}; name=$(echo "$Name" | tr '[:upper:]' '[:lower:]')
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --window-size=1024,1024 --virtual-time-budget=4000 \
    --screenshot="$TMP/$name.png" "file://$PWD/tool/icon_designs.html#$id" >/dev/null 2>&1
  # App Store icons: exactly 1024x1024, no alpha.
  magick "$TMP/$name.png" -crop 1024x1024+0+0 +repage -alpha off -colorspace sRGB \
    "PNG24:assets/icon/alt/$name.png"
  set_dir="ios/Runner/Assets.xcassets/AppIcon-$Name.appiconset"
  mkdir -p "$set_dir"
  cp "assets/icon/alt/$name.png" "$set_dir/icon-1024.png"
  cat > "$set_dir/Contents.json" <<JSON
{
  "images": [
    {
      "filename": "icon-1024.png",
      "idiom": "universal",
      "platform": "ios",
      "size": "1024x1024"
    }
  ],
  "info": {
    "author": "xcode",
    "version": 1
  }
}
JSON
  magick "assets/icon/alt/$name.png" -resize 512x512 "PNG24:store/play/icon_tests/${name}_512.png"
  echo "  $id -> AppIcon-$Name"
done
rm -rf "$TMP"
