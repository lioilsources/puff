#!/usr/bin/env bash
# Capture Google Play screenshots from an Android emulator.
#
# Counterpart of gen_screenshots.sh. Play refuses screenshots taller than 2:1
# and every current phone is taller than that, so the emulator's display is
# overridden to 1080x1920 for the session — the game then renders natively at
# 9:16 and nothing has to be cropped. Output lands in /tmp/shots_android; pick
# the good ones by hand and copy them into store/play/screenshots/.
#
#   emulator -avd Pixel_6 &      # any AVD; boot it first
#   ./tool/gen_screenshots_android.sh
#
# The build has to be a debug one: prefs are written through `run-as`, which
# only works on a debuggable package. A debug build shows nothing for the first
# few seconds (JIT), so the leading frames of every run are throwaway.
#
# GOTCHA: palettes are stored by display name ('Vaporwave'), environments and
# modifiers by enum name ('water', 'chainSpark'). A palette in the wrong case
# silently falls back to Cyberpunk.

set -euo pipefail

ADB=${ADB:-${ANDROID_HOME:-$HOME/Library/Android/sdk}/platform-tools/adb}
OUT=${OUT:-/tmp/shots_android}
PKG=com.ol1n.puff
SHOTS_PER_RUN=60

flutter build apk --debug --dart-define=PUFF_DEMO=true
"$ADB" wait-for-device
"$ADB" shell wm size 1080x1920
trap '"$ADB" shell wm size reset' EXIT
"$ADB" install -r build/app/outputs/flutter-apk/app-debug.apk

capture() {  # label environment modifier palette
  "$ADB" shell am force-stop "$PKG"
  local scores="" env
  for env in vacuum air water plasma; do
    scores+="<long name=\"flutter.highScore_$env\" value=\"425\" />"
  done
  "$ADB" shell "run-as $PKG mkdir -p shared_prefs"
  # shared_preferences keeps everything in this one file, ints as <long>.
  printf '%s\n' "<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<map>
<string name=\"flutter.environment\">$2</string>
<string name=\"flutter.modifier\">$3</string>
<string name=\"flutter.palette\">$4</string>
$scores
</map>" | "$ADB" shell "run-as $PKG sh -c 'cat > shared_prefs/FlutterSharedPreferences.xml'"
  "$ADB" shell am start -n "$PKG/.MainActivity" >/dev/null
  for i in $(seq -w 1 $SHOTS_PER_RUN); do
    "$ADB" exec-out screencap -p > "$OUT/${1}_$i.png"
    sleep 0.4
  done
  echo "  $1  ($2 / $3 / $4)"
}

rm -rf "$OUT"; mkdir -p "$OUT"
capture A_vacuum vacuum pressure    Cyberpunk
capture B_water  water  pressure    Vaporwave
capture C_plasma plasma chainSpark  Cyberpunk
capture D_air    air    gravityWell Ember
capture E_imp    vacuum implosion   Arctic
echo "$(ls "$OUT" | wc -l | tr -d ' ') frames in $OUT"
