#!/usr/bin/env bash
set -euo pipefail

# Build and run the Java menu safely.
# Uses a file lock to avoid concurrent menu instances.

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

LOCK="/tmp/borne_arcade.lock"
exec 9>"$LOCK"
if ! flock -n 9; then
  echo "borne_arcade: deja en cours (lock $LOCK)."
  exit 0
fi

echo "== Build =="
bash "$PROJECT_DIR/scripts/build.sh"

echo "== Clavier borne =="
if command -v setxkbmap >/dev/null 2>&1; then
  if setxkbmap borne 2>/dev/null; then
    echo "Layout X11 actif: borne"
  else
    echo "Attention: layout 'borne' indisponible (fallback layout systeme)."
  fi
else
  echo "Attention: setxkbmap absent, mapping borne non applique."
fi

echo "== Lancement du menu =="
# Keep repo root in classpath so resource loading can resolve project assets.
CP="build:build_mg2d:.:img:fonts:sound"

export DISPLAY="${DISPLAY:-:0}"
exec java -cp "$CP" Main