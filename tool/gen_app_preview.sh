#!/usr/bin/env bash
# Record the App Store app previews (iPhone 6.9", portrait) from the simulator.
#
# Three scenes, each its own PUFF_DEMO build on an iPhone 17 Pro Max
# simulator: environment, palette and modifier are dart-defines, and the run
# is endless (PUFF_ENDLESS) so the scripted driver survives until the heat
# climbs. Heat reaches 1 (HEAT III, the densest spawns and biggest blasts) at
# 150 s, so the cut starts there by default; the preview autoplays muted in
# search results, so it opens mid-chaos, not on a title.
#
#   ./tool/gen_app_preview.sh                    # all three scenes
#   ./tool/gen_app_preview.sh water              # one scene
#   CUT_ONLY=1 START=158 ./tool/gen_app_preview.sh water   # re-cut a recording
#
# Output per scene in build/app_preview/<scene>/: raw.mov, contact frames in
# frames/ (one every 2 s, NNN.png = NNN*2 seconds, to pick START from) and
# puff_preview_<scene>_886x1920.mp4 — 886x1920, 30 fps, H.264, stereo AAC;
# the soundtrack is the scene's own environment theme.
#
# Run it from a normal terminal: the Flutter build does not pass inside a
# sandbox (its lipo check of Flutter.framework comes back empty there).

set -euo pipefail
cd "$(dirname "$0")/.."

DEVICE_TYPE=com.apple.CoreSimulator.SimDeviceType.iPhone-17-Pro-Max
SIM_NAME=Puff-Shots
BUNDLE=com.ol1n.puff
ROOT_OUT=build/app_preview
START=${START:-150}          # seconds into raw.mov where the preview starts
LENGTH=${LENGTH:-25}         # App Store allows 15–30 s
RECORD_SECONDS=${RECORD_SECONDS:-$(echo "$START + $LENGTH + 10" | bc)}

ORDER=(vacuum water plasma)

# scene -> "environment palette modifier"
scene_spec() {
  case $1 in
    vacuum) echo "vacuum Cyberpunk pressure" ;;
    water) echo "water Vaporwave implosion" ;;
    plasma) echo "plasma Ember chainSpark" ;;
    *) echo "unknown scene: $1 (${ORDER[*]})" >&2; exit 1 ;;
  esac
}

cut() {
  local scene=$1 env=$2 out=$ROOT_OUT/$1
  ffmpeg -y -loglevel error -ss "$START" -t "$LENGTH" -i "$out/raw.mov" \
    -ss 0 -t "$LENGTH" -i "assets/audio/music/${env}_1.ogg" \
    -map 0:v -map 1:a \
    -vf "scale=886:1920:flags=lanczos,fps=30,format=yuv420p" \
    -af "volume=0.7,afade=t=in:d=0.3,afade=t=out:st=$(echo "$LENGTH - 1.5" | bc):d=1.5" \
    -c:v libx264 -profile:v high -level 4.0 -preset slow -crf 16 \
    -c:a aac -b:a 256k -ar 44100 -ac 2 \
    -movflags +faststart \
    "$out/puff_preview_${scene}_886x1920.mp4"
  echo "$scene: $out/puff_preview_${scene}_886x1920.mp4 (start ${START}s, ${LENGTH}s)"
}

scenes=("$@")
[[ ${#scenes[@]} -eq 0 ]] && scenes=("${ORDER[@]}")

if [[ -n "${CUT_ONLY:-}" ]]; then
  for scene in "${scenes[@]}"; do
    read -r env _ _ <<<"$(scene_spec "$scene")"
    cut "$scene" "$env"
  done
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
xcrun simctl boot "$UDID" 2>/dev/null || true
xcrun simctl bootstatus "$UDID" -b
xcrun simctl status_bar "$UDID" override --time 9:41 --batteryState charged \
  --batteryLevel 100 --cellularBars 4 --wifiBars 3 >/dev/null 2>&1 || true

for scene in "${scenes[@]}"; do
  read -r env palette modifier <<<"$(scene_spec "$scene")"
  out=$ROOT_OUT/$scene
  echo "== $scene: $env / $palette / $modifier, recording ${RECORD_SECONDS}s"
  flutter build ios --simulator --debug --dart-define=PUFF_DEMO=true \
    --dart-define=PUFF_ENDLESS=true --dart-define=PUFF_ENV="$env" \
    --dart-define=PUFF_PALETTE="$palette" --dart-define=PUFF_MODIFIER="$modifier"
  xcrun simctl terminate "$UDID" "$BUNDLE" >/dev/null 2>&1 || true
  xcrun simctl install "$UDID" build/ios/iphonesimulator/Runner.app

  rm -rf "$out"; mkdir -p "$out/frames"
  xcrun simctl io "$UDID" recordVideo --codec h264 --force "$out/raw.mov" &
  rec=$!
  sleep 1
  xcrun simctl launch "$UDID" "$BUNDLE" >/dev/null
  sleep "$RECORD_SECONDS"
  kill -INT "$rec"
  wait "$rec" || true
  xcrun simctl terminate "$UDID" "$BUNDLE" >/dev/null 2>&1 || true

  ffmpeg -loglevel error -i "$out/raw.mov" -vf "fps=0.5,scale=220:-1" -start_number 0 "$out/frames/%03d.png"
  cut "$scene" "$env"
done
