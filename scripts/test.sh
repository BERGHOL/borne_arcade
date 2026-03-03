#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "== Check jeux =="
bash scripts/check_games.sh

echo "== Build =="
bash scripts/build.sh

echo "==Tests Java =="
java -cp "build:build_mg2d" TestHighScore

./scripts/check_deps.sh
./scripts/check_games.sh

echo "Ok: tests terminés"
