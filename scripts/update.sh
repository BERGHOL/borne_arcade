#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

# 1) Vérif MG2D
echo "== Vérification de MG2D =="

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARENT_DIR="$(dirname "$PROJECT_DIR")"
MG2D_DIR="$PARENT_DIR/MG2D"

if [ ! -d "$MG2D_DIR/MG2D" ]; then
  echo "MG2D non trouvé. Clonage automatique..."
  cd "$PARENT_DIR"
  git clone https://github.com/synave/MG2D.git MG2D || true
fi

cd "$PROJECT_DIR"

echo "=== UPDATE borne_arcade ==="

# 2) Vérif cohérence jeux (optionnel mais utile)
if [ -f "$PROJECT_DIR/scripts/check_games.sh" ]; then
  echo "== Check des jeux =="
  bash "$PROJECT_DIR/scripts/check_games.sh" || true
fi

# 3) Rebuild
echo "== Rebuild =="
bash "$PROJECT_DIR/scripts/build.sh"

# 4) Relance si un service systemd existe (on le fera plus tard sur la Pi)
if command -v systemctl >/dev/null 2>&1; then
  if systemctl --user list-unit-files 2>/dev/null | grep -q "^borne\.service"; then
    echo "== Restart systemd user service =="
    systemctl --user restart borne.service
    echo "OK: borne.service redémarré"
  else
    echo "Info: borne.service non trouvé (normal si pas encore configuré)."
    echo "Pour relancer manuellement : ./scripts/run.sh"
  fi
else
  echo "Info: systemctl non disponible."
  echo "Pour relancer manuellement : ./scripts/run.sh"
fi

echo "=== UPDATE terminé ==="
