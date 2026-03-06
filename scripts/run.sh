#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

# Empêche 2 menus en même temps (important si systemd + lancement manuel)
LOCK="/tmp/borne_arcade.lock"
exec 9>"$LOCK"
if ! flock -n 9; then
  echo "borne_arcade: déjà en cours (lock $LOCK)."
  exit 0
fi

echo "== Build =="
bash "$PROJECT_DIR/scripts/build.sh"

echo "== Lancement du menu =="

# IMPORTANT :
# - on ajoute "." (le PROJECT_DIR) au classpath
# - comme ça getResource("/projet/.../photo_small.png") peut fonctionner
CP="build:build_mg2d:.:img:fonts:sound"

export DISPLAY="${DISPLAY:-:0}"
exec java -cp "$CP" Main

