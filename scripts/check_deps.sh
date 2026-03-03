#!/usr/bin/env bash
set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

echo "== Vérification jeux (structure) =="

fail=0

if [ ! -d "projet" ]; then
  echo "❌ Dossier 'projet/' introuvable"
  exit 1
fi

while IFS= read -r -d '' d; do
  game="$(basename "$d")"
  sh="./${game}.sh"
  if [ ! -f "$sh" ]; then
    echo "❌ Script manquant pour '$game' : attendu $sh"
    fail=1
  fi
done < <(find projet -mindepth 1 -maxdepth 1 -type d -print0)

echo "== Vérification scripts (python3) =="

if grep -Rni --include="*.sh" "python3\.7" . ; then
  echo "❌ Des scripts utilisent python3 -> remplacer par python3"
  fail=1
else
  echo "✅ Aucun python3 détecté"
fi

if [ $fail -ne 0 ]; then
  echo "❌ Vérifications jeux: ECHEC"
  exit 1
fi

echo "✅ Vérifications jeux: OK"
