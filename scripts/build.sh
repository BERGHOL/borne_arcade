#!/usr/bin/env bash
set -euo pipefail

# Build Linux: compile MG2D classes, then menu classes.

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARENT_DIR="$(dirname "$PROJECT_DIR")"
MG2D_DIR="$PARENT_DIR/MG2D"
MG2D_SRC="$MG2D_DIR/MG2D"

cd "$PROJECT_DIR"

echo "== Nettoyage =="
rm -rf build build_mg2d
mkdir -p build build_mg2d

echo "== Compilation MG2D =="
if [ ! -d "$MG2D_SRC" ]; then
  echo "ERREUR: MG2D introuvable a: $MG2D_SRC"
  exit 1
fi

find "$MG2D_SRC" -name "*.java" -print0 | xargs -0 javac -d build_mg2d

echo "== Compilation menu borne_arcade =="
find "$PROJECT_DIR" -maxdepth 1 -name "*.java" -print0 | xargs -0 javac -cp "build_mg2d" -d build

echo "OK: build termine."