#!/usr/bin/env bash
set -euo pipefail

# Validate required docs and build generated documentation artifacts.

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

echo "== Verification presence docs =="
test -f docs/INSTALLATION.md
test -f docs/DOCUMENTATION_TECHNIQUE.md
test -f docs/AJOUT_JEU.md
test -f docs/UTILISATEUR.md
test -f docs/DEPLOIEMENT_GIT.md
test -f docs/README_DOCS.md
test -f docs/STYLE_GUIDE.md

echo "== Generation docs =="
bash scripts/gen_docs.sh

echo "== Verification sortie MkDocs =="
test -f docs-site/site/index.html

echo "OK: documentation valide"