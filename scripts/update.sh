#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

echo "=== UPDATE borne_arcade ==="

# 1) Vérif cohérence jeux (optionnel mais utile)
if [ -f "$PROJECT_DIR/scripts/check_games.sh" ]; then
  echo "== Check des jeux =="
  bash "$PROJECT_DIR/scripts/check_games.sh" || true
fi

# 2) Rebuild
echo "== Rebuild =="
bash "$PROJECT_DIR/scripts/build.sh"

# 3) Relance si un service systemd existe (on le fera plus tard sur la Pi)
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
