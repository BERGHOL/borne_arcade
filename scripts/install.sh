#!/usr/bin/env bash
set -euo pipefail

echo "=== Installation de la borne d’arcade ==="

# Vérifier qu’on est sur Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "Ce script doit être exécuté sur Linux (Raspberry Pi OS)."
  exit 1
fi

echo "== Mise à jour des paquets =="
sudo apt update

echo "== Installation des dépendances =="
sudo apt install -y \
  git \
  openjdk-21-jdk \
  xorg \
  x11-xkb-utils

echo "== Vérification de MG2D =="

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARENT_DIR="$(dirname "$PROJECT_DIR")"
MG2D_DIR="$PARENT_DIR/MG2D"

if [ ! -d "$MG2D_DIR" ]; then
  echo "MG2D non trouvé. Clonage automatique..."
  cd "$PARENT_DIR"
  git clone https://github.com/synave/MG2D.git
fi

echo "== Compilation du projet =="
cd "$PROJECT_DIR"
chmod +x scripts/build.sh
./scripts/build.sh

echo "=== Installation terminée ==="
echo "Pour lancer la borne :"
echo "./scripts/run.sh"
