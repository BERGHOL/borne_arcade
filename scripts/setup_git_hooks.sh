#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

if [ ! -d ".git" ]; then
  echo "ERREUR: pas de dossier .git ici. (Le projet doit être un dépôt git sur la borne)"
  exit 1
fi

echo "== Activation des hooks git versionnés (.githooks) =="
git config core.hooksPath .githooks

chmod +x .githooks/post-merge .githooks/post-checkout scripts/update.sh scripts/setup_git_hooks.sh

echo "OK: hooks activés."
echo "Test: fais un 'git pull' -> update.sh doit se lancer automatiquement."
