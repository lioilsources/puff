#!/usr/bin/env python3
"""Count every pasteable text in store/GOOGLE_PLAY.md against Play's limits.

A fenced block counts when a nearby line above it names a limit in brackets,
like `**Short description** (80)` or `(500 per language)`. The stated
"— N chars" next to it, if any, is checked too, so the doc cannot drift.
Release-note language tags (<en-US> … </en-US>) are not counted, as in Play.

    python3 tool/check_play_listing.py      # exit 1 on any problem
"""
import re
import sys
from pathlib import Path

DOC = Path(__file__).resolve().parent.parent / "store/GOOGLE_PLAY.md"
LIMIT = re.compile(r"\((\d+)(?:[ ,)])")
STATED = re.compile(r"(\d[\d  ]*) chars")
TAG = re.compile(r"^</?[a-z]{2}-[A-Z]{2}>$")


def main() -> int:
    lines = DOC.read_text(encoding="utf-8").splitlines()
    limit, stated, label, bad = None, None, "", 0
    in_bold = False  # inside a paragraph that starts with **
    i = 0
    while i < len(lines):
        line = lines[i]
        if line.startswith("```"):
            j = i + 1
            while not lines[j].startswith("```"):
                j += 1
            body = [l for l in lines[i + 1:j] if not TAG.match(l.strip())]
            if limit:
                n = len("\n".join(body))
                ok = n <= limit and (stated is None or stated == n)
                bad += not ok
                note = "" if stated in (None, n) else f"  (doc says {stated})"
                print(f"{'ok ' if ok else 'BAD'} {n:5}/{limit:<5} {label}{note}")
            limit, stated = None if not limit else limit, None
            i = j + 1
            continue
        if line.startswith("**"):
            in_bold, label = True, line.strip("* ").split("**")[0]
        elif not line.strip():
            in_bold = False
        m = LIMIT.search(line)
        if m and in_bold:
            limit, stated = int(m.group(1)), None
        s = STATED.search(line)
        if s and limit:
            stated = int(re.sub(r"\D", "", s.group(1)))
            if not in_bold:
                label = label.split(" [")[0] + " [" + line.split(" ")[0] + "]"
        if line.startswith("#") or line.startswith("---"):
            limit = None
        i += 1
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
