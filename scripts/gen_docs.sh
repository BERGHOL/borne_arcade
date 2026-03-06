#!/usr/bin/env bash
set -euo pipefail

# Build documentation artifacts:
# - docs-site/javadoc from Java sources
# - docs-site/site from MkDocs markdown pages

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS_OUTPUT="$PROJECT_DIR/docs-site"

cd "$PROJECT_DIR"

echo "== Nettoyage ancien site =="
rm -rf "$DOCS_OUTPUT"

mkdir -p "$DOCS_OUTPUT/javadoc"

echo "== Generation Javadoc =="
# Non-blocking on javadoc errors so docs site can still be published.
javadoc \
  -encoding UTF-8 \
  -charset UTF-8 \
  -docencoding UTF-8 \
  -quiet \
  -Xdoclint:none \
  -classpath "build_mg2d" \
  -d "$DOCS_OUTPUT/javadoc" \
  *.java || true

echo "== Generation site MkDocs =="
mkdocs build --site-dir "$DOCS_OUTPUT/site"

echo "== Documentation generee dans: =="
echo "- $DOCS_OUTPUT/site"
echo "- $DOCS_OUTPUT/javadoc"