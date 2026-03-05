# Documentation — Ajouter un nouveau jeu à la borne d’arcade

Ce document explique comment intégrer un nouveau jeu afin qu’il soit détecté automatiquement par le menu principal.

---

## 1) Détection automatique des jeux

Le menu Java détecte automatiquement les jeux présents dans :

    projet/

Chaque sous-dossier correspond à un jeu.

Exemples :

- projet/Pong/
- projet/TronGame/
- projet/ball-blast/

---

## 2) Structure obligatoire

Pour un jeu nommé `MonJeu` :

### A. Dossier du jeu

Créer :

    projet/MonJeu/

Ce dossier contient les ressources du jeu (images, sons, code, etc.).

### B. Script de lancement

Créer à la racine du projet :

    MonJeu.sh

Le nom du script doit être exactement identique au nom du dossier.

Exemple :

- dossier : projet/Pong/
- script : Pong.sh

---

## 3) Fonctionnement avec le menu

Le menu lance :

    ./MonJeu.sh

Puis attend la fin du processus (`waitFor()`).

Donc :

- Tant que le jeu tourne → le script doit rester actif
- Quand le jeu se termine → le script doit se terminer
- Ensuite → retour automatique au menu

Si le jeu ne se ferme jamais → le menu restera bloqué.

---

## 4) Script minimal de test

Créer :

    projet/TestJeu/

Créer `TestJeu.sh` :

    #!/usr/bin/env bash
    set -e
    echo "TestJeu démarre"
    sleep 2
    echo "TestJeu se termine"

Rendre exécutable :

    chmod +x TestJeu.sh

---

## 5) Exemple jeu Java (avec MG2D)

    #!/usr/bin/env bash
    set -e

    ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
    MG2D_DIR="$(cd "$ROOT_DIR/../MG2D" && pwd)"

    cd "$ROOT_DIR/projet/MonJeu"
    java -cp ".:$MG2D_DIR" Main

Important :

- Ne pas utiliser de chemin absolu (/home/pi/...)
- MG2D doit être référencé dynamiquement

---

## 6) Exemple jeu Python

    #!/usr/bin/env bash
    set -e

    cd "$(dirname "$0")/projet/MonJeu"
    python3 main.py

Important :

- Utiliser python3 (pas python3.7)
- Installer les dépendances nécessaires (pygame, etc.)

---

## 7) Dépendances système possibles

Selon le langage utilisé :

- Java → OpenJDK
- Python → python3 + pygame
- Lua → love2d
- Outils graphiques → xdotool

Les dépendances doivent être installées via `install.sh`.

---

## 8) Bonnes pratiques

- Prévoir une touche Quitter (ESC)
- Éviter les chemins absolus
- Utiliser des chemins relatifs
- Ne pas modifier la configuration système
- Vérifier que le jeu se termine proprement

---

## 9) Vérification automatique

Exécuter :

    ./scripts/check_games.sh

Résultat attendu :

    OK: tous les jeux ont un script .sh

---

## 10) Dépannage

### Le jeu n’apparaît pas

- Vérifier le dossier projet/NomJeu/
- Vérifier le nom exact du script

### Retour immédiat au menu

- Le script se termine immédiatement
- Le jeu ne démarre pas correctement

### Blocage du menu

- Le jeu ne se ferme jamais
- Ajouter une touche de sortie