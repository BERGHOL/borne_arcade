#!/usr/bin/env bash
set -euo pipefail

echo "=== Installation de la borne d’arcade ==="

# Vérifier qu’on est sur Linux
case "${OSTYPE:-}" in
  linux-gnu*) ;;
  *) echo "Ce script doit être exécuté sur Linux (Raspberry Pi OS / Debian)."; exit 1 ;;
esac

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARENT_DIR="$(dirname "$PROJECT_DIR")"
MG2D_DIR="$PARENT_DIR/MG2D"

echo "== Mise à jour des paquets =="
sudo apt update

echo "== Installation des dépendances =="

# Java (fallback si openjdk-21 indisponible)
if apt-cache show openjdk-21-jdk >/dev/null 2>&1; then
  JAVA_PKG="openjdk-21-jdk"
else
  JAVA_PKG="openjdk-17-jdk"
fi

sudo apt install -y \
  git \
  "$JAVA_PKG" \
  xorg \
  x11-xkb-utils \
  xdotool \
  python3 \
  python3-pygame \
  python3-venv \
  python3-pip \
  love \
  mkdocs

echo "== Vérification de MG2D =="
if [ ! -d "$MG2D_DIR" ]; then
  echo "MG2D non trouvé. Clonage automatique..."
  (cd "$PARENT_DIR" && git clone https://github.com/synave/MG2D.git MG2D)
fi

echo "== Permissions =="
cd "$PROJECT_DIR"
chmod +x scripts/*.sh || true
chmod +x .githooks/* 2>/dev/null || true
chmod +x *.sh 2>/dev/null || true
find . -type f -name "*.sh" -exec chmod +x {} \; || true

echo "== Activation des hooks git (si présents) =="
if [ -d ".githooks" ]; then
  git config core.hooksPath .githooks || true
fi

echo "== Compilation du projet =="
./scripts/build.sh

echo "== Génération documentation (optionnel) =="
if [ -x "./scripts/gen_docs.sh" ]; then
  ./scripts/gen_docs.sh || true
fi

echo "=== Installation terminée ==="
echo "Pour lancer la borne :"
echo "./scripts/run.sh"
