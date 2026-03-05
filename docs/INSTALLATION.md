# Installation de la borne d’arcade

## 1. Prérequis

- Raspberry Pi 3 Model B (minimum)
- Raspberry Pi OS récent (Desktop recommandé)
- Connexion Internet
- Utilisateur avec droits sudo (ex : arcade)

---

## 2. Installation initiale du système

Mettre à jour le système :

    sudo apt update
    sudo apt upgrade -y

Installer git si nécessaire :

    sudo apt install -y git

---

## 3. Clonage du projet

    git clone https://github.com/BERGHOL/borne_arcade.git
    cd borne_arcade

---

## 4. Installation automatique

Lancer le script d’installation :

    ./scripts/install.sh

Ce script :

- Installe Java (OpenJDK)
- Installe Python3 et pygame
- Installe Love2D
- Installe xdotool
- Clone automatiquement la bibliothèque MG2D
- Compile le projet
- Configure les hooks Git
- Génère la documentation

---

## 5. Activation du lancement automatique au démarrage

Installer le service systemd :

    sudo cp scripts/borne-arcade.service /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable borne-arcade.service

Redémarrer :

    sudo reboot

---

## 6. Fonctionnement automatique

Au démarrage de la borne :

1. Vérification des mises à jour Git
2. Rebuild automatique si nécessaire
3. Génération automatique de la documentation
4. Lancement du menu principal

La borne est entièrement autonome.

---

## 7. Mise à jour manuelle (si nécessaire)

    git pull

La mise à jour déclenche automatiquement :

- Rebuild
- Régénération de la documentation
- Redémarrage du service