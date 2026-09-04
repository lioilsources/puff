#!/usr/bin/env bash
# Capture App Store screenshots from the iOS simulator.
#
# Boots an iPhone 17 Pro Max (native 1320x2868 = the App Store 6.9" size, so
# no upscaling), installs a PUFF_DEMO build and lets the scripted driver play
# while we grab frames. Output lands in /tmp/shots_final; pick the good ones
# by hand and copy them into ol1n.now under
# apps/puff/screenshots/raw/mobile/{ios,android}/, then run `make screenshots`
# there to get the exact store dimensions.
#
#   ./tool/gen_screenshots.sh
#
# GOTCHA: settings live in NSUserDefaults, and cfprefsd inside the simulator
# caches them. Editing the container plist while the simulator is booted has
# no effect — the app is served the stale value. Hence the shutdown/boot
# around every write below. Do not "optimise" that away.

set -euo pipefail

DEVICE_TYPE=com.apple.CoreSimulator.SimDeviceType.iPhone-17-Pro-Max
SIM_NAME=Puff-Shots
OUT=/tmp/shots_final
BUNDLE=com.ol1n.puff
SHOTS_PER_RUN=16

RUNTIME=$(xcrun simctl list runtimes -j \
  | python3 -c "import json,sys;print(max((r['identifier'] for r in json.load(sys.stdin)['runtimes'] if r['isAvailable'] and 'iOS' in r['name']), key=len))")

UDID=$(xcrun simctl list devices -j \
  | python3 -c "
import json,sys
for ds in json.load(sys.stdin)['devices'].values():
    for d in ds:
        if d['name']=='$SIM_NAME': print(d['udid']); break" | head -1)
if [[ -z "$UDID" ]]; then
  UDID=$(xcrun simctl create "$SIM_NAME" "$DEVICE_TYPE" "$RUNTIME")
  echo "created simulator $UDID"
fi

flutter build ios --simulator --debug --dart-define=PUFF_DEMO=true
xcrun simctl boot "$UDID" 2>/dev/null || true
xcrun simctl bootstatus "$UDID" -b
xcrun simctl install "$UDID" build/ios/iphonesimulator/Runner.app
# One launch so the app creates its preferences plist.
xcrun simctl launch "$UDID" "$BUNDLE" >/dev/null
sleep 4
xcrun simctl terminate "$UDID" "$BUNDLE" >/dev/null 2>&1 || true

PLIST=$(ls -d "$HOME/Library/Developer/CoreSimulator/Devices/$UDID/data/Containers/Data/Application"/*/Library/Preferences/$BUNDLE.plist | head -1)

set_pref() {  # key value type
  /usr/libexec/PlistBuddy -c "Set :$1 $2" "$PLIST" 2>/dev/null \
    || /usr/libexec/PlistBuddy -c "Add :$1 ${3:-string} $2" "$PLIST"
}

capture() {  # label environment modifier palette
  xcrun simctl terminate "$UDID" "$BUNDLE" >/dev/null 2>&1 || true
  xcrun simctl shutdown "$UDID" >/dev/null 2>&1 || true
  sleep 2
  set_pref flutter.environment "$2"
  set_pref flutter.modifier    "$3"
  set_pref flutter.palette     "$4"
  for env in vacuum air water plasma; do
    set_pref "flutter.highScore_$env" 425 integer
  done
  xcrun simctl boot "$UDID" >/dev/null 2>&1
  xcrun simctl bootstatus "$UDID" -b >/dev/null
  xcrun simctl launch "$UDID" "$BUNDLE" >/dev/null
  sleep 2.2
  xcrun simctl io "$UDID" screenshot "$OUT/${1}_menu.png" >/dev/null 2>&1
  sleep 4.3   # demo driver leaves the menu after ~4s
  for i in $(seq -w 1 $SHOTS_PER_RUN); do
    xcrun simctl io "$UDID" screenshot "$OUT/${1}_$i.png" >/dev/null 2>&1
    sleep 0.5
  done
  echo "  $1  ($2 / $3 / $4)"
}

rm -rf "$OUT"; mkdir -p "$OUT"
capture A_vacuum vacuum pressure    cyberpunk
capture B_water  water  pressure    vaporwave
capture C_plasma plasma chainSpark  cyberpunk
capture D_air    air    gravityWell ember
capture E_imp    vacuum implosion   arctic
echo "$(ls "$OUT" | wc -l | tr -d ' ') frames in $OUT"
