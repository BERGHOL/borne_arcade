#!/usr/bin/env bash
set -euo pipefail

# Pull main only when remote is ahead.
# Intended for periodic execution (cron/systemd timer).

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

echo "== AUTOUPDATE: fetch =="
git fetch origin main

LOCAL="$(git rev-parse HEAD)"
REMOTE="$(git rev-parse origin/main)"

if [ "$LOCAL" != "$REMOTE" ]; then
  echo "== AUTOUPDATE: mise a jour detectee -> git pull =="
  git pull --ff-only
else
  echo "== AUTOUPDATE: rien a faire =="
fi