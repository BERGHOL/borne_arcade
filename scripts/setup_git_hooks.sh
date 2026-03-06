#!/usr/bin/env bash
set -euo pipefail

# Activate versioned hooks from .githooks for this repository clone.

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

if [ ! -d ".git" ]; then
  echo "ERREUR: pas de dossier .git ici (le projet doit etre un depot git)."
  exit 1
fi

echo "== Activation des hooks git versionnes (.githooks) =="
git config core.hooksPath .githooks

chmod +x .githooks/post-merge .githooks/post-checkout .githooks/pre-commit scripts/update.sh scripts/setup_git_hooks.sh

echo "OK: hooks actives."
echo "Test: fais un 'git pull' -> update.sh doit se lancer automatiquement."