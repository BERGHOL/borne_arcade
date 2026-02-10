#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "== Vérification des jeux =="
cd "$PROJECT_DIR"

fail=0

if [ ! -d "projet" ]; then
  echo "ERREUR: dossier 'projet/' introuvable"
  exit 1
fi

for d in projet/*; do
  [ -d "$d" ] || continue
  game="$(basename "$d")"
  script="./$game.sh"
  if [ ! -f "$script" ]; then
    echo "ERREUR: script manquant pour le jeu '$game' -> attendu: $script"
    fail=1
  fi
done

if [ "$fail" -ne 0 ]; then
  echo "KO: certains jeux n'ont pas de script .sh"
  exit 1
fi

echo "OK: tous les jeux ont un script .sh"
