#!/usr/bin/env bash
set -euo pipefail

# One-shot installer for Raspberry Pi OS / Debian.
# Installs dependencies, checks MG2D, sets permissions, then builds project.

echo "=== Installation de la borne d'arcade ==="

case "${OSTYPE:-}" in
  linux-gnu*) ;;
  *)
    echo "ERREUR: ce script doit etre execute sur Linux (Raspberry Pi OS / Debian)."
    exit 1
    ;;
esac

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARENT_DIR="$(dirname "$PROJECT_DIR")"
MG2D_DIR="$PARENT_DIR/MG2D"

echo "== Mise a jour des paquets =="
sudo apt update

echo "== Installation des dependances =="
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

echo "== Verification de MG2D =="
if [ ! -d "$MG2D_DIR" ]; then
  echo "MG2D non trouve. Clonage automatique..."
  (cd "$PARENT_DIR" && git clone https://github.com/synave/MG2D.git MG2D)
fi

echo "== Permissions =="
cd "$PROJECT_DIR"
chmod +x scripts/*.sh || true
chmod +x .githooks/* 2>/dev/null || true
chmod +x *.sh 2>/dev/null || true
find . -type f -name "*.sh" -exec chmod +x {} \; || true

echo "== Installation du layout clavier borne (X11) =="
if [ -f "$PROJECT_DIR/borne" ]; then
  sudo cp "$PROJECT_DIR/borne" /usr/share/X11/xkb/symbols/borne
  echo "Layout installe: /usr/share/X11/xkb/symbols/borne"
else
  echo "Attention: fichier 'borne' introuvable dans le projet."
fi

echo "== Activation des hooks git (si presents) =="
if [ -d ".githooks" ]; then
  git config core.hooksPath .githooks || true
fi

echo "== Compilation du projet =="
./scripts/build.sh

echo "== Generation documentation (optionnel) =="
if [ -x "./scripts/gen_docs.sh" ]; then
  ./scripts/gen_docs.sh || true
fi

echo "=== Installation terminee ==="
echo "Pour lancer la borne: ./scripts/run.sh"