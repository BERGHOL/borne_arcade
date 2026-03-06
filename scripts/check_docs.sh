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
test -d docs-site/site
# Depending on MkDocs config/version, home can be generated as root index
# or as a section page. Accept either to avoid false negatives in CI.
if [ ! -f docs-site/site/index.html ] && [ ! -f docs-site/site/README_DOCS/index.html ]; then
  echo "ERREUR: aucune page d'accueil MkDocs detectee."
  exit 1
fi

echo "OK: documentation valide"
