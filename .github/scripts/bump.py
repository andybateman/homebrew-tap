#!/usr/bin/env python3
"""Bump casks to the latest GitHub release.

Reads each upstream repo's latest (non-prerelease) release and takes the
SHA-256 from GitHub's asset digest, so nothing is downloaded. Rewrites the
cask's version and sha256 lines in place. Prints one line per cask bumped.

Usage: bump.py [--dry-run]
"""

import json
import os
import re
import sys
import urllib.request
from pathlib import Path

CASKS_DIR = Path(__file__).resolve().parents[2] / "Casks"

# Cask token -> upstream repo and the asset to read for each sha256 slot.
# Slot None is a plain `sha256 "..."` line; "arm"/"intel" are per-arch slots.
CASKS = {
    "solidcraft": {
        "repo": "tangency-labs/solidcraft",
        "assets": {None: "solidcraft-{v}-macos-universal.dmg"},
    },
    "iopenpod": {
        "repo": "TheRealSavi/iOpenPod",
        "assets": {
            "arm": "iOpenPod-{v}-macOS-arm64.dmg",
            "intel": "iOpenPod-{v}-macOS-x86_64.dmg",
        },
    },
}


def latest_release(repo):
    req = urllib.request.Request(
        f"https://api.github.com/repos/{repo}/releases/latest",
        headers={"Accept": "application/vnd.github+json"},
    )
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(req, timeout=30) as resp:
        return json.load(resp)


def bump(token, spec, dry_run):
    path = CASKS_DIR / f"{token}.rb"
    text = path.read_text()
    current = re.search(r'^\s*version "([^"]+)"', text, re.M).group(1)

    release = latest_release(spec["repo"])
    version = release["tag_name"].removeprefix("v")
    if version == current:
        return None

    digests = {a["name"]: a.get("digest") or "" for a in release["assets"]}
    for slot, pattern in spec["assets"].items():
        name = pattern.format(v=version)
        digest = digests.get(name, "")
        if not digest.startswith("sha256:"):
            raise SystemExit(f"{token}: no sha256 digest for {name} in {release['tag_name']}")
        sha = digest.removeprefix("sha256:")
        if slot is None:
            text = re.sub(r'^(\s*sha256 )"[0-9a-f]{64}"', rf'\g<1>"{sha}"', text, count=1, flags=re.M)
        else:
            text = re.sub(rf'({slot}:\s+)"[0-9a-f]{{64}}"', rf'\g<1>"{sha}"', text, count=1)

    text = re.sub(r'^(\s*version )"[^"]+"', rf'\g<1>"{version}"', text, count=1, flags=re.M)
    if not dry_run:
        path.write_text(text)
    return f"{token} {current} -> {version}"


def main():
    dry_run = "--dry-run" in sys.argv
    for token, spec in CASKS.items():
        change = bump(token, spec, dry_run)
        if change:
            print(change)


if __name__ == "__main__":
    main()
