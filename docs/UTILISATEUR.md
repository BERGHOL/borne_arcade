# Guide utilisateur

Ce guide explique l'usage de la borne cote joueur.

## 1) Demarrer la borne

Au demarrage:
- le systeme lance le menu,
- les jeux detectes sont affiches automatiquement,
- aucune commande terminal n'est necessaire.

## 2) Naviguer dans le menu

Par defaut:
- joystick joueur 1: navigation haut/bas,
- bouton A joueur 1: lancer le jeu selectionne,
- bouton Z joueur 1: demander la fermeture du menu.

## 3) Lancer un jeu

Le menu execute le script du jeu (`NomDuJeu.sh`) puis attend sa fin.
Quand le jeu se ferme proprement, retour automatique au menu principal.

## 4) Quitter un jeu

Chaque jeu doit fournir une commande de sortie (souvent ESC).
Sans sortie propre, le menu peut sembler bloque.

## 5) En cas de probleme

### Le jeu n'apparait pas

Verifier:
- dossier `projet/NomDuJeu/` present,
- script `NomDuJeu.sh` present a la racine,
- script executable.

### Retour immediat au menu

Ca signifie generalement que le script du jeu termine trop vite ou echoue au lancement.

### Ecran fige dans un jeu

Le jeu ne se termine pas. Utiliser sa touche de sortie ou corriger son script de lancement.

## 6) Utilisation avancee

Selon les jeux, les dependances peuvent differer (Java, Python, Love2D).
Le menu principal reste identique: il lance un script et attend sa fin.