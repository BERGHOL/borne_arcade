#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARENT_DIR="$(dirname "$PROJECT_DIR")"
MG2D_DIR="$PARENT_DIR/MG2D"

cd "$PROJECT_DIR"
echo "=== UPDATE borne_arcade ==="

# 0) Permissions (évite les 'Permission denied' après pull)
echo "== Permissions =="
chmod +x scripts/*.sh 2>/dev/null || true
chmod +x .githooks/* 2>/dev/null || true
chmod +x *.sh 2>/dev/null || true
find . -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# 1) Vérif MG2D
echo "== Vérification de MG2D =="
if [ ! -d "$MG2D_DIR/MG2D" ]; then
  echo "MG2D non trouvé. Clonage automatique..."
  (cd "$PARENT_DIR" && git clone https://github.com/synave/MG2D.git MG2D) || true
fi

# 2) Vérif cohérence jeux (optionnel)
if [ -f "$PROJECT_DIR/scripts/check_games.sh" ]; then
  echo "== Check des jeux =="
  bash "$PROJECT_DIR/scripts/check_games.sh" || true
fi

# 3) Rebuild
echo "== Rebuild =="
bash "$PROJECT_DIR/scripts/build.sh"

# 4) Génération documentation (ne doit pas bloquer l’update)
if [ -x "$PROJECT_DIR/scripts/gen_docs.sh" ]; then
  echo "== Génération documentation =="
  bash "$PROJECT_DIR/scripts/gen_docs.sh" || true
fi

# 5) Redémarrage du service (si installé)
if command -v systemctl >/dev/null 2>&1; then
  if systemctl list-unit-files 2>/dev/null | grep -q "^borne-arcade\.service"; then
    echo "== Restart borne-arcade.service =="
    sudo systemctl restart borne-arcade.service || true
    echo "OK: borne-arcade.service redémarré"
  else
    echo "Info: borne-arcade.service non trouvé (normal si pas encore installé)."
    echo "Pour relancer manuellement : ./scripts/run.sh"
  fi
else
  echo "Info: systemctl non disponible."
  echo "Pour relancer manuellement : ./scripts/run.sh"
fi

echo "=== UPDATE terminé ==="