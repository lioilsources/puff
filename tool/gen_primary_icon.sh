#!/usr/bin/env bash
# Renders the primary app icon from tool/icon_designs.html (D4, Gravitační
# studna / Well, picked by Ol1n on 8 Nov 2026) and fans it out with
# flutter_launcher_icons.
#
#   assets/icon/icon.png             1024 master, RGB (iOS, legacy Android)
#   assets/icon/icon_foreground.png  1024 spiral on transparency (adaptive)
#   assets/icon/icon_background.png  1024 background only (adaptive)
#   store/play/icon_512.png          Play listing icon
#
# Needs Google Chrome (headless) and ImageMagick.
set -euo pipefail
cd "$(dirname "$0")/.."

ID=D4
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
TMP=$(mktemp -d)

shot() { # <hash> <out>
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --window-size=1024,1024 --virtual-time-budget=4000 --default-background-color=00000000 \
    --screenshot="$2" "file://$PWD/tool/icon_designs.html#$1" >/dev/null 2>&1
}
shot "$ID" "$TMP/icon.png"
shot "$ID/fg" "$TMP/fg.png"
shot "$ID/bg" "$TMP/bg.png"

magick "$TMP/icon.png" -crop 1024x1024+0+0 +repage -alpha off -colorspace sRGB "PNG24:assets/icon/icon.png"
magick "$TMP/fg.png" -crop 1024x1024+0+0 +repage -colorspace sRGB "PNG32:assets/icon/icon_foreground.png"
magick "$TMP/bg.png" -crop 1024x1024+0+0 +repage -alpha off -colorspace sRGB "PNG24:assets/icon/icon_background.png"
magick assets/icon/icon.png -resize 512x512 "PNG24:store/play/icon_512.png"
# flutter_launcher_icons 0.14.4 rewrites unrelated Xcode build settings (the
# alternate icon list among them) with naive seds; keep our project file.
cp ios/Runner.xcodeproj/project.pbxproj "$TMP.pbxproj"
dart run flutter_launcher_icons
mv "$TMP.pbxproj" ios/Runner.xcodeproj/project.pbxproj
rm -rf "$TMP"
