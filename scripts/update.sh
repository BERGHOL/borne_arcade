#!/usr/bin/env bash
set -euo pipefail

# Update sequence triggered by git hooks (post-merge/post-checkout):
# permissions -> MG2D check -> game checks -> build -> docs -> service restart.

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARENT_DIR="$(dirname "$PROJECT_DIR")"
MG2D_DIR="$PARENT_DIR/MG2D"

cd "$PROJECT_DIR"
echo "=== UPDATE borne_arcade ==="

echo "== Permissions =="
chmod +x scripts/*.sh 2>/dev/null || true
chmod +x .githooks/* 2>/dev/null || true
chmod +x *.sh 2>/dev/null || true
find . -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

echo "== Verification de MG2D =="
if [ ! -d "$MG2D_DIR/MG2D" ]; then
  echo "MG2D non trouve. Clonage automatique..."
  (cd "$PARENT_DIR" && git clone https://github.com/synave/MG2D.git MG2D) || true
fi

if [ -f "$PROJECT_DIR/scripts/check_games.sh" ]; then
  echo "== Check des jeux =="
  bash "$PROJECT_DIR/scripts/check_games.sh" || true
fi

echo "== Rebuild =="
bash "$PROJECT_DIR/scripts/build.sh"

if [ -x "$PROJECT_DIR/scripts/gen_docs.sh" ]; then
  echo "== Generation documentation =="
  bash "$PROJECT_DIR/scripts/gen_docs.sh" || true
fi

# Restart service only when available on target machine.
# Supports both deployment variants:
# - system service: borne-arcade.service
# - user service:   borne.service
if command -v systemctl >/dev/null 2>&1; then
  if systemctl list-unit-files 2>/dev/null | grep -q "^borne-arcade\.service"; then
    echo "== Restart borne-arcade.service =="
    sudo systemctl restart borne-arcade.service || true
    echo "OK: borne-arcade.service redemarre"
  elif systemctl --user list-unit-files 2>/dev/null | grep -q "^borne\.service"; then
    echo "== Restart borne.service (user) =="
    systemctl --user restart borne.service || true
    echo "OK: borne.service redemarre"
  else
    echo "Info: aucun service borne detecte (normal si non installe)."
    echo "Relance manuelle: ./scripts/run.sh"
  fi
else
  echo "Info: systemctl non disponible."
  echo "Relance manuelle: ./scripts/run.sh"
fi

echo "=== UPDATE termine ==="
