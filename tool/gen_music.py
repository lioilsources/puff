#!/usr/bin/env python3
"""Generates Puff's soundtrack on SPARK (AiStack audio, ACE-Step 1.5).

    python3 -I tool/gen_music.py --dry-run        # print the prompts, call nothing
    python3 -I tool/gen_music.py                  # every track without a sha256
    python3 -I tool/gen_music.py --only menu      # one track (a probe)
    python3 -I tool/gen_music.py --regen water_1  # again, with a new seed
    python3 -I tool/gen_music.py --all            # everything again
    python3 -I tool/gen_music.py --qa             # check the files on disk

The manifest (tool/music_manifest.json) is the source of truth: prompt, BPM and
key go in, seed and sha256 come back and are written after every track, so an
interrupted run resumes where it stopped. Prompt + seed reproduce a file;
`prompt_override` wins over the assembled prompt and survives template edits.

The service loopifies, normalises to -16 LUFS and limits to -1 dBTP itself.
Nothing is post-processed here.

SPARK is a shared machine. Between tracks the script reads its thermal log and
waits while it is hot; it never starts or stops anything there. The music
container is started by whoever runs the schedule, not by this script.

Environment: AISTACK_URL (default http://spark:8093), AUDIO_API_KEY (optional),
SPARK_SSH (default "spark"; empty disables the thermal guard).
"""

import argparse
import datetime
import hashlib
import json
import os
import subprocess
import sys
import time
import urllib.error
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MANIFEST = os.path.join(ROOT, "tool", "music_manifest.json")
OUT_DIR = os.path.join(ROOT, "assets", "audio", "music")

BASE_URL = os.environ.get("AISTACK_URL", "http://spark:8093").rstrip("/")
API_KEY = os.environ.get("AUDIO_API_KEY", "")
SPARK_SSH = os.environ.get("SPARK_SSH", "spark")

# Agreed with the SPARK schedule: wait at or above HOT, go on below COOL, and
# stop if the logger has not written for STALE seconds (it is dead, or SPARK is).
HOT_C = 93.0
COOL_C = 87.0
STALE_S = 60
THERMAL_CSV = "~/ops/thermal.csv"
ZONE_COLUMN = 8  # zone_max_c

POLL_S = 3
JOB_TIMEOUT_S = 15 * 60
RESULT_FIELDS = ("seed", "sha256", "measured_s", "lufs", "true_peak_db", "model", "generated_at")


def log(message):
    print(time.strftime("%H:%M:%S"), message, flush=True)


def load_manifest():
    with open(MANIFEST, encoding="utf-8") as f:
        return json.load(f)


def save_manifest(manifest):
    tmp = MANIFEST + ".tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2, ensure_ascii=False)
        f.write("\n")
    os.replace(tmp, MANIFEST)


def prompt_for(manifest, track):
    override = track.get("prompt_override", "").strip()
    if override:
        return override
    parts = [manifest["style"], track["tags"]]
    parts.append(manifest["loop_tags"] if track["loop"] else manifest["sting_tags"])
    return ", ".join(p.strip() for p in parts if p.strip())


def path_for(track):
    return os.path.join(OUT_DIR, track["id"] + ".ogg")


def sha256_of(path):
    digest = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def request(method, path, body=None, timeout=120):
    url = path if path.startswith("http") else BASE_URL + path
    data = None if body is None else json.dumps(body).encode()
    req = urllib.request.Request(url, data=data, method=method)
    if data is not None:
        req.add_header("Content-Type", "application/json")
    if API_KEY:
        req.add_header("Authorization", "Bearer " + API_KEY)
    try:
        with urllib.request.urlopen(req, timeout=timeout) as response:
            return response.read()
    except urllib.error.HTTPError as error:
        detail = error.read().decode(errors="replace")[:400]
        if error.code == 401:
            sys.exit("401 from the audio service: set AUDIO_API_KEY and run again.")
        raise RuntimeError(f"{method} {url} -> HTTP {error.code}: {detail}") from None
    except urllib.error.URLError as error:
        raise RuntimeError(f"{method} {url} -> {error.reason}") from None


def music_model():
    """Name of the first music model the service can run right now, or None."""
    models = json.loads(request("GET", "/v1/audio/models", timeout=20))
    for model in models:
        if model.get("kind") == "music" and model.get("available"):
            return model["name"]
    return None


def thermal_wait():
    """Blocks while SPARK is hot. Exits when its thermal log has gone stale."""
    if not SPARK_SSH:
        return
    announced = False
    while True:
        zone, age = thermal_read()
        if age > STALE_S:
            sys.exit(f"thermal log on SPARK is {age:.0f} s old (limit {STALE_S}); stopping.")
        if zone < (COOL_C if announced else HOT_C):
            if announced:
                log(f"thermal: {zone:.1f} °C, going on")
            return
        if not announced:
            log(f"thermal: {zone:.1f} °C >= {HOT_C:.0f}, waiting for < {COOL_C:.0f}")
            announced = True
        time.sleep(20)


def thermal_read():
    command = f"tail -n 1 {THERMAL_CSV}; date '+%Y/%m/%d %H:%M:%S'"
    try:
        out = subprocess.run(
            ["ssh", "-o", "BatchMode=yes", "-o", "ConnectTimeout=8", SPARK_SSH, command],
            capture_output=True, text=True, timeout=30, check=True,
        ).stdout.strip().splitlines()
        row, now = out[-2].split(","), out[-1]
        stamp = datetime.datetime.strptime(row[0].split(".")[0], "%Y/%m/%d %H:%M:%S")
        age = (datetime.datetime.strptime(now, "%Y/%m/%d %H:%M:%S") - stamp).total_seconds()
        return float(row[ZONE_COLUMN]), age
    except Exception as error:  # ssh down, log missing, format changed
        sys.exit(f"cannot read the thermal log on SPARK ({error}); stopping. "
                 "SPARK_SSH= disables the guard, at your own risk.")


def generate(manifest, track, new_seed):
    body = {
        "prompt": prompt_for(manifest, track),
        "duration_s": track["duration_s"],
        "instrumental": True,
        "bpm": track["bpm"],
        "key": track["key"],
        "loop": track["loop"],
        "format": "ogg",
        "variations": 1,
    }
    if manifest.get("model"):
        body["model"] = manifest["model"]
    if "seed" in track and not new_seed:
        body["seed"] = track["seed"]

    started = time.time()
    job_id = json.loads(request("POST", "/v1/audio/music", body))["job_id"]
    while True:
        job = json.loads(request("GET", f"/v1/audio/jobs/{job_id}", timeout=30))
        if job["status"] == "done":
            break
        if job["status"] == "error":
            raise RuntimeError(f"job {job_id} failed: {job.get('error')}")
        if time.time() - started > JOB_TIMEOUT_S:
            raise RuntimeError(f"job {job_id} still {job['status']} after {JOB_TIMEOUT_S} s")
        time.sleep(POLL_S)

    output = job["outputs"][0]
    audio = request("GET", output["url"], timeout=300)
    digest = hashlib.sha256(audio).hexdigest()
    if output.get("sha256") and output["sha256"] != digest:
        raise RuntimeError(f"{track['id']}: download does not match the service's sha256")
    os.makedirs(OUT_DIR, exist_ok=True)
    tmp = path_for(track) + ".tmp"
    with open(tmp, "wb") as f:
        f.write(audio)
    os.replace(tmp, path_for(track))

    track.update({
        "seed": output.get("seed"),
        "sha256": digest,
        "measured_s": round(output.get("duration") or 0, 2),
        "lufs": output.get("loudness_lufs"),
        "true_peak_db": output.get("true_peak_db"),
        "model": job.get("model", ""),
        "generated_at": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    })
    return time.time() - started


def qa(manifest):
    """Files on disk against the manifest. Returns the number of problems."""
    problems = 0
    for track in manifest["tracks"]:
        path = path_for(track)
        flags = []
        if "sha256" not in track:
            flags.append("not generated")
        elif not os.path.exists(path):
            flags.append("file missing")
        else:
            if sha256_of(path) != track["sha256"]:
                flags.append("sha256 differs from the manifest")
            measured, wanted = track.get("measured_s") or 0, track["duration_s"]
            if measured < wanted * 0.6:
                flags.append(f"short: {measured:.0f} s of {wanted} s asked")
            lufs = track.get("lufs")
            if lufs is not None and abs(lufs + 16) > 1.5:
                flags.append(f"loudness {lufs:.1f} LUFS, target -16")
            peak = track.get("true_peak_db")
            if peak is not None and peak > -0.5:
                flags.append(f"true peak {peak:.1f} dBTP")
        problems += len(flags)
        size = f"{os.path.getsize(path) / 1e6:5.2f} MB" if os.path.exists(path) else "   -    "
        print(f"{track['id']:10} {size}  {track.get('measured_s', 0):6.1f} s  "
              f"{'ok' if not flags else '; '.join(flags)}")
    known = {t["id"] + ".ogg" for t in manifest["tracks"]}
    if os.path.isdir(OUT_DIR):
        for name in sorted(os.listdir(OUT_DIR)):
            if name.endswith(".ogg") and name not in known:
                print(f"{name}: not in the manifest")
                problems += 1
    return problems


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--dry-run", action="store_true", help="print prompts, call nothing")
    parser.add_argument("--qa", action="store_true", help="check files against the manifest")
    parser.add_argument("--all", action="store_true", help="regenerate every track")
    parser.add_argument("--only", nargs="+", metavar="ID", help="limit the run to these tracks")
    parser.add_argument("--regen", nargs="+", metavar="ID", help="regenerate these tracks")
    parser.add_argument("--keep-seed", action="store_true",
                        help="with --regen/--all: reuse the recorded seed (reproduce, not reroll)")
    args = parser.parse_args()

    manifest = load_manifest()
    by_id = {t["id"]: t for t in manifest["tracks"]}
    for track_id in (args.only or []) + (args.regen or []):
        if track_id not in by_id:
            sys.exit(f"unknown track '{track_id}'; known: {', '.join(by_id)}")

    if args.qa:
        sys.exit(1 if qa(manifest) else 0)

    forced = set(by_id) if args.all else set(args.regen or [])
    todo = [
        t for t in manifest["tracks"]
        if (t["id"] in forced or "sha256" not in t or not os.path.exists(path_for(t)))
        and (not args.only or t["id"] in args.only)
    ]

    if args.dry_run:
        for track in todo:
            print(f"{track['id']}  {track['duration_s']} s  {track['bpm']} BPM  {track['key']}"
                  f"  loop={track['loop']}\n  {prompt_for(manifest, track)}\n")
        print(f"{len(todo)} of {len(manifest['tracks'])} tracks would be generated at {BASE_URL}")
        return
    if not todo:
        print("nothing to generate; --regen ID or --all to do it again")
        return

    model = music_model()
    if model is None:
        sys.exit(f"no music model is available at {BASE_URL}: the audio-music container is "
                 "not running. Do not start it from here; ask whoever runs the SPARK schedule.")
    log(f"{len(todo)} tracks, model {manifest.get('model') or model}, {BASE_URL}")

    for index, track in enumerate(todo, 1):
        thermal_wait()
        log(f"[{index}/{len(todo)}] {track['id']} ...")
        new_seed = track["id"] in forced and not args.keep_seed
        if new_seed:
            for field in RESULT_FIELDS:
                track.pop(field, None)
        took = generate(manifest, track, new_seed)
        save_manifest(manifest)
        log(f"[{index}/{len(todo)}] {track['id']}: {track['measured_s']} s of "
            f"{track['duration_s']} s asked, {track['lufs']} LUFS, seed {track['seed']}, "
            f"{took:.0f} s")

    print()
    qa(manifest)


if __name__ == "__main__":
    try:
        main()
    except RuntimeError as error:
        sys.exit(f"error: {error}")
    except KeyboardInterrupt:
        sys.exit("\ninterrupted; the manifest is saved after every track, run again to resume")
