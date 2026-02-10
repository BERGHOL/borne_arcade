#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="$PROJECT_DIR/docs-site"
JAVADOC_DIR="$OUT_DIR/javadoc"
MD_DIR="$OUT_DIR/markdown"

echo "== Génération documentation =="
rm -rf "$OUT_DIR"
mkdir -p "$JAVADOC_DIR" "$MD_DIR"

echo "== Copie des docs Markdown =="
if [ -d "$PROJECT_DIR/docs" ]; then
  cp -r "$PROJECT_DIR/docs/." "$MD_DIR/"
else
  echo "ATTENTION: dossier docs/ introuvable, copie des .md racine."
  cp "$PROJECT_DIR"/*.md "$MD_DIR/" 2>/dev/null || true
fi

echo "== Génération Javadoc (doc technique) =="
# On ne documente que le menu (les .java à la racine)
find "$PROJECT_DIR" -maxdepth 1 -name "*.java" -print0 | \
  xargs -0 javadoc -d "$JAVADOC_DIR" -encoding UTF-8 -charset UTF-8 -docencoding UTF-8

echo "OK: Documentation générée dans $OUT_DIR"
echo "- Markdown: $MD_DIR"
echo "- Javadoc:  $JAVADOC_DIR"
