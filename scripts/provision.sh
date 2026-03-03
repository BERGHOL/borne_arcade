#!/usr/bin/env bash
set -euo pipefail

echo "=== Provisione la borne arcade (post-OS) ==="

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
	echo "ERREUR: ce script doit etre exécuté sur Linux (Raspberry Pi OS)."
	exit 1
fi

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARENT_DIR="$(dirname "$PROJECT_DIR")"
MG2D_DIR="$PARENT_DIR/MG2D"

echo "== Paquets système =="
sudo apt update
sudo apt upgrade -y
sudo apt install -y git x11-xkb-utils

echo "== Installation Java (21 ou 25) =="
if apt-cache show openjdk-21-jdk >/dev/null 2>&1; then
	sudo apt install -y openjdk-21-jdk
elif apt-cache show openjdk-25-jdk >/dev/null 2>&1; then
	sudo apt install -y openjdk-25-jdk
else
	echo "ERREUR: aucune version OpenJDK 21/25 trouvée."
	apt-cache search openjdk | head -n 30
	exit 1
fi

echo "== MG2D =="
if [ ! -d "$MG2D_DIR" ]; then
	echo "MG2D absent -> clonage..."
	cd "$PARENT_DIR"
	git clone https://github.com/synave/MG2D.git
fi

echo "== Rendre scripts exécutables =="
chmod +x "$PROJECT_DIR"/scripts/*.sh || true
chmod +x "$PROJECT_DIR"/.githooks/* 2>/dev/null || true

echo "Activation hooks git (si depot git) =="
if [ -d "$PROJECT_DIR/.git" ]; then
	git -C "$PROJECT_DIR" config core.hooksPath .githooks
	echo "OK: core.hooksPath=.githooks"
else
	echo "Info: pas de .git ici (normal si copie par USB)."
	echo "Pour activer le déploiment via git, cloner le depot sur la borne."
fi

echo "== Build + tests =="
bash "$PROJECT_DIR/scripts/build.sh"
if [ -f "$PROJECT_DIR/scripts/test.sh" ]; then
	bash "$PROJECT_DIR/scripts/test.sh" || true
fi

echo "== Autostart (systemd user) =="
mkdir -p "$HOME/.config/systemd/user"
cat > "$HOME/.config/systemd/user/borne.service" <<EOF
[UNIT]
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

echo "OK: service user borne.service activité."
echo "Tu peux démarrer maintenant avec: systemctl --user start borne.service"
echo "Ou lancer manuellement: $PROJECT_DIR/scripts/run.sh"
