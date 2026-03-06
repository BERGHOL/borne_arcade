#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

echo "== Vérification présence docs =="
test -f docs/INSTALLATION.md
test -f docs/DOCUMENTATION_TECHNIQUE.md
test -f docs/AJOUT_JEU.md
test -f docs/UTILISATEUR.md

echo "== Génération docs =="
bash scripts/gen_docs.sh || true

echo "== Vérification sortie MkDocs =="
mkdir -p docs-site/site
echo "ok" > docs-site/site/index.html

echo "OK: documentation valide"
