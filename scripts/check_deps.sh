#!/usr/bin/env bash
set -euo pipefail

# Validate project-level dependencies and launcher conventions.
# This script is CI-friendly: exit 1 on any blocking issue.

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

echo "== Verification jeux (structure) =="

fail=0

if [ ! -d "projet" ]; then
  echo "ERREUR: dossier 'projet/' introuvable"
  exit 1
fi

# Every game folder must have a same-name launcher at repo root.
while IFS= read -r -d '' d; do
  game="$(basename "$d")"
  sh="./${game}.sh"
  if [ ! -f "$sh" ]; then
    echo "ERREUR: script manquant pour '$game' (attendu: $sh)"
    fail=1
  fi
done < <(find projet -mindepth 1 -maxdepth 1 -type d -print0)

echo "== Verification scripts Python =="

# Block old interpreter pinning.
if grep -Rni --include="*.sh" "python3\.7" . >/dev/null; then
  echo "ERREUR: des scripts utilisent python3.7 (utiliser python3)."
  fail=1
else
  echo "OK: aucun python3.7 detecte"
fi

if [ "$fail" -ne 0 ]; then
  echo "ECHEC: verification dependances/jeux"
  exit 1
fi

echo "OK: verification dependances/jeux"