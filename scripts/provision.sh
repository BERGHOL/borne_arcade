#!/usr/bin/env bash
set -euo pipefail

# Post-OS provisioning helper for Raspberry Pi images.
# Installs runtime, prepares MG2D, builds, and configures user systemd service.

echo "=== Provisionne la borne arcade (post-OS) ==="

if [[ "${OSTYPE:-}" != "linux-gnu"* ]]; then
  echo "ERREUR: ce script doit etre execute sur Linux (Raspberry Pi OS)."
  exit 1
fi

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARENT_DIR="$(dirname "$PROJECT_DIR")"
MG2D_DIR="$PARENT_DIR/MG2D"

echo "== Paquets systeme =="
sudo apt update
sudo apt upgrade -y
sudo apt install -y git x11-xkb-utils

echo "== Installation Java (21 ou 25) =="
if apt-cache show openjdk-21-jdk >/dev/null 2>&1; then
  sudo apt install -y openjdk-21-jdk
elif apt-cache show openjdk-25-jdk >/dev/null 2>&1; then
  sudo apt install -y openjdk-25-jdk
else
  echo "ERREUR: aucune version OpenJDK 21/25 trouvee."
  apt-cache search openjdk | head -n 30
  exit 1
fi

echo "== MG2D =="
if [ ! -d "$MG2D_DIR" ]; then
  echo "MG2D absent -> clonage..."
  (cd "$PARENT_DIR" && git clone https://github.com/synave/MG2D.git MG2D)
fi

echo "== Rendre scripts executables =="
chmod +x "$PROJECT_DIR"/scripts/*.sh || true
chmod +x "$PROJECT_DIR"/.githooks/* 2>/dev/null || true

echo "== Installation du layout clavier borne (X11) =="
if [ -f "$PROJECT_DIR/borne" ]; then
  sudo cp "$PROJECT_DIR/borne" /usr/share/X11/xkb/symbols/borne
  echo "Layout installe: /usr/share/X11/xkb/symbols/borne"
else
  echo "Attention: fichier 'borne' introuvable dans le projet."
fi

echo "== Activation hooks git (si depot git) =="
if [ -d "$PROJECT_DIR/.git" ]; then
  git -C "$PROJECT_DIR" config core.hooksPath .githooks
  echo "OK: core.hooksPath=.githooks"
else
  echo "Info: pas de .git ici (normal si copie par USB)."
  echo "Pour activer le deploiement via git, cloner le depot sur la borne."
fi

echo "== Build + tests =="
bash "$PROJECT_DIR/scripts/build.sh"
if [ -f "$PROJECT_DIR/scripts/test.sh" ]; then
  bash "$PROJECT_DIR/scripts/test.sh" || true
fi

echo "== Autostart (systemd user) =="
mkdir -p "$HOME/.config/systemd/user"
cat > "$HOME/.config/systemd/user/borne.service" <<EOF
[Unit]
Description=Borne d'arcade - Menu Java
After=graphical-session.target

[Service]
Type=simple
WorkingDirectory=$PROJECT_DIR
ExecStart=$PROJECT_DIR/scripts/run.sh
Restart=on-failure
RestartSec=2

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable borne.service

echo "OK: service user borne.service active."
echo "Demarrage: systemctl --user start borne.service"
echo "Lancement manuel: $PROJECT_DIR/scripts/run.sh"