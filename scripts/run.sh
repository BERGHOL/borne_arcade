#!/usr/bin/env bash
set -e

# Aller à la racine du projet
cd "$(dirname "$0")/.."

echo "== Build =="
./scripts/build.sh

echo "== Lancement du menu =="
java -cp "build:build_mg2d:.:img:fonts:sound" Main
