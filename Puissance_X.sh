#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MG2D_DIR="$(cd "$ROOT_DIR/../MG2D" && pwd)"

xdotool mousemove 1280 1024
cd "$ROOT_DIR/projet/Puissance_X"
java -cp ".:../..:$MG2D_DIR" -Dsun.java2d.pmoffscreen=false Main

# -Dsun.java2d.pmoffscreen=false : ameliore souvent les perfs sous X11.
