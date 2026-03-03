#!/usr/bin/env bash
set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS_OUTPUT="$PROJECT_DIR/docs-site"

echo "== Nettoyage ancien site =="
rm -rf "$DOCS_OUTPUT"

echo "== Génération Javadoc =="

mkdir -p "$DOCS_OUTPUT/javadoc"

javadoc \
  -d "$DOCS_OUTPUT/javadoc" \
  -classpath "$PROJECT_DIR/build:$PROJECT_DIR/../MG2D/build_mg2d" \
  -Xdoclint:none \
  -quiet \
  $(find "$PROJECT_DIR" -maxdepth 1 -name "*.java") \
  || true

echo "== Génération site MkDocs =="
mkdocs build --site-dir "$DOCS_OUTPUT/site"

echo "== Documentation générée dans :"
echo "   - $DOCS_OUTPUT/site"
echo "   - $DOCS_OUTPUT/javadoc"
