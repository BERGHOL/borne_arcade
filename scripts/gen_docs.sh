#!/usr/bin/env bash
set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS_OUTPUT="$PROJECT_DIR/docs-site"

echo "== Nettoyage ancien site =="
rm -rf "$DOCS_OUTPUT"

echo "== Génération Javadoc =="

mkdir -p docs-site/javadoc

javadoc \
  -encoding UTF-8 \
  -charset UTF-8 \
  -docencoding UTF-8 \
  -quiet \
  -Xdoclint:none \
  -classpath "build_mg2d" \
  -d docs-site/javadoc \
  *.java || true

echo "== Génération site MkDocs =="
mkdocs build --site-dir "$DOCS_OUTPUT/site"

echo "== Documentation générée dans :"
echo "   - $DOCS_OUTPUT/site"
echo "   - $DOCS_OUTPUT/javadoc"
