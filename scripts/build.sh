#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MG2D_SRC="$PROJECT_DIR/../MG2D/MG2D"
MG2D_OUT="$PROJECT_DIR/build_mg2d"
OUT="$PROJECT_DIR/build"

echo "== Nettoyage =="
rm -rf "$MG2D_OUT" "$OUT"
mkdir -p "$MG2D_OUT" "$OUT"

if [ ! -d "$MG2D_SRC" ]; then
  echo "ERREUR: MG2D introuvable à: $MG2D_SRC"
  echo "Attendu: .../SAE_06_A_Maintenance/MG2D/MG2D"
  exit 1
fi

echo "== Compilation MG2D =="
find "$MG2D_SRC" -name "*.java" -print0 | xargs -0 javac -d "$MG2D_OUT"

echo "== Compilation du menu (borne_arcade) =="
find "$PROJECT_DIR" -maxdepth 1 -name "*.java" -print0 | xargs -0 javac -cp ".:$MG2D_OUT" -d "$OUT"

echo "OK: Build terminé."
