#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

echo "== AUTOUPDATE: fetch =="
git fetch origin main

LOCAL="$(git rev-parse HEAD)"
REMOTE="$(git rev-parse origin/main)"

if [ "$LOCAL" != "$REMOTE" ]; then
  echo "== AUTOUPDATE: update trouvée -> git pull =="
  git pull --ff-only
else
  echo "== AUTOUPDATE: rien à faire =="
fi
