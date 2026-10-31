#!/usr/bin/env bash
# Record the App Store app preview (iPhone 6.9", portrait) from the simulator.
#
# Installs a PUFF_DEMO build on its own iPhone 17 Pro Max simulator, lets the
# scripted driver play and records the screen. The cut skips the menu and
# starts on a blast: the preview autoplays muted in search results, so the
# first three seconds have to show something blowing up, not a title.
#
#   ./tool/gen_app_preview.sh            # record + cut
#   CUT_ONLY=1 START=6.4 ./tool/gen_app_preview.sh   # re-cut the last recording
#
# Output: build/app_preview/raw.mov, contact frames in build/app_preview/frames/
# (one per half second, named by timestamp, to pick START from) and
# build/app_preview/puff_preview_886x1920.mp4 — 886x1920, 30 fps, H.264,
# stereo AAC; the soundtrack is the game's own vacuum_1 theme.
#
# Run it from a normal terminal: the Flutter build does not pass inside a
# sandbox (its lipo check of Flutter.framework comes back empty there).

set -euo pipefail
cd "$(dirname "$0")/.."

DEVICE_TYPE=com.apple.CoreSimulator.SimDeviceType.iPhone-17-Pro-Max
SIM_NAME=Puff-Shots
BUNDLE=com.ol1n.puff
OUT=build/app_preview
RECORD_SECONDS=${RECORD_SECONDS:-60}
START=${START:-6.0}          # seconds into raw.mov where the preview starts
LENGTH=${LENGTH:-25}         # App Store allows 15–30 s
MUSIC=assets/audio/music/vacuum_1.ogg

cut() {
  ffmpeg -y -loglevel error -ss "$START" -t "$LENGTH" -i "$OUT/raw.mov" \
    -ss 0 -t "$LENGTH" -i "$MUSIC" \
    -map 0:v -map 1:a \
    -vf "scale=886:1920:flags=lanczos,fps=30,format=yuv420p" \
    -af "volume=0.7,afade=t=in:d=0.3,afade=t=out:st=$(echo "$LENGTH - 1.5" | bc):d=1.5" \
    -c:v libx264 -profile:v high -level 4.0 -preset slow -crf 16 \
    -c:a aac -b:a 256k -ar 44100 -ac 2 \
    -movflags +faststart \
    "$OUT/puff_preview_886x1920.mp4"
  echo "preview: $OUT/puff_preview_886x1920.mp4 (start ${START}s, ${LENGTH}s)"
}

if [[ -n "${CUT_ONLY:-}" ]]; then
  cut
  exit 0
fi

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
fi

flutter build ios --simulator --debug --dart-define=PUFF_DEMO=true
xcrun simctl boot "$UDID" 2>/dev/null || true
xcrun simctl bootstatus "$UDID" -b
xcrun simctl install "$UDID" build/ios/iphonesimulator/Runner.app
xcrun simctl status_bar "$UDID" override --time 9:41 --batteryState charged \
  --batteryLevel 100 --cellularBars 4 --wifiBars 3 >/dev/null 2>&1 || true

rm -rf "$OUT"; mkdir -p "$OUT/frames"
xcrun simctl terminate "$UDID" "$BUNDLE" >/dev/null 2>&1 || true
xcrun simctl io "$UDID" recordVideo --codec h264 --force "$OUT/raw.mov" &
REC=$!
sleep 1
xcrun simctl launch "$UDID" "$BUNDLE" >/dev/null
sleep "$RECORD_SECONDS"
kill -INT "$REC"
wait "$REC" || true
xcrun simctl terminate "$UDID" "$BUNDLE" >/dev/null 2>&1 || true

ffmpeg -loglevel error -i "$OUT/raw.mov" -vf "fps=2,scale=220:-1" -start_number 0 "$OUT/frames/%03d.png"
echo "frames: $OUT/frames/NNN.png = NNN/2 seconds into raw.mov"
cut
