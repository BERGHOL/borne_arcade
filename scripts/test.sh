#!/usr/bin/env bash
set -euo pipefail

# Linux test entrypoint used in CI/local checks.

cd "$(dirname "$0")/.."

echo "== Check jeux =="
bash scripts/check_games.sh

echo "== Build =="
bash scripts/build.sh

echo "== Tests Java =="
java -cp "build:build_mg2d" TestHighScore

echo "== Verification dependances =="
bash scripts/check_deps.sh

echo "OK: tests termines"