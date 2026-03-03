# Documentation — Ajouter un nouveau jeu à la borne d’arcade

Ce document explique comment ajouter un nouveau jeu à la borne, afin qu’il apparaisse dans le menu principal.

---

## 1) Comment le menu détecte les jeux

Le menu Java liste automatiquement les jeux présents dans le dossier :

* `projet/`

Chaque sous-dossier dans `projet/` correspond à **un jeu**.

Exemple :

* `projet/Pong/`
* `projet/TronGame/`
* `projet/ball-blast/`

---

## 2) Règles obligatoires pour qu’un jeu fonctionne

Pour un jeu nommé `MonJeu`, il faut **obligatoirement** :

### A. Créer un dossier dans `projet/`

Créer :
projet/MonJeu/

Ce dossier doit contenir les fichiers du jeu (images, sons, exécutables, sources, etc.) selon les besoins du jeu.

### B. Créer un script de lancement à la racine

Créer à la racine du projet (au même niveau que `Main.java`) :
MonJeu.sh

Le nom du script doit être exactement le même que le nom du dossier dans `projet/`.

Exemples :

* dossier `projet/Pong/`  → script `Pong.sh`
* dossier `projet/TronGame/` → script `TronGame.sh`

---

## 3) Règle la plus importante : le menu attend la fin du jeu

Dans le code du menu, le lancement se fait via :

* exécution de `./MonJeu.sh`
* puis le programme attend que le processus se termine (`waitFor()`).

Conséquence :

* Tant que le jeu tourne : le script doit rester actif.
* Quand le jeu se termine (ou que l’utilisateur quitte) : le script doit se terminer.
* Ensuite seulement : retour automatique au menu.

Donc :

* si ton jeu tourne en boucle → il faut une touche “quitter”
* ou un mécanisme qui termine proprement le jeu et le script

---

## 4) Exemple minimal (jeu de test)

### A. Créer le dossier

```
projet/TestJeu/
```

### B. Créer le script `TestJeu.sh` à la racine

Contenu du script :

```
#!/usr/bin/env bash
set -e
echo "=== TestJeu démarre ==="
echo "Le jeu va se fermer dans 2 secondes..."
sleep 2
echo "=== TestJeu se termine ==="
```

### C. Rendre le script exécutable (sur Linux / Raspberry Pi)

```
chmod +x TestJeu.sh
```

Test attendu :

* Le jeu apparaît dans le menu
* Le menu lance `TestJeu.sh`
* Après 2 secondes → retour au menu

---

## 5) Exemple de script pour un jeu Java

```
#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/projet/MonJeu"
java -jar MonJeu.jar
```

Important :

* la commande java doit rester active tant que le jeu tourne
* quand le jeu se ferme, le script se termine → retour menu

---

## 6) Exemple de script pour un jeu Python

```
#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/projet/MonJeu"
python3 main.py
```

Important :

* utiliser python3
* installer les dépendances du jeu si nécessaire
* quand l’utilisateur quitte, le script doit se terminer

---

## 7) Bonnes pratiques recommandées

* Mettre une touche “Quitter” dans le jeu (ex: ESC)
* Éviter les chemins absolus (`/home/pi/...`)
* Utiliser des chemins relatifs
* Documenter les contrôles du jeu

---

## 8) Vérification automatique des jeux

Un script de contrôle est fourni :

```
./scripts/check_games.sh
```

Résultat attendu :

```
OK: tous les jeux ont un script .sh
```

Si un jeu n’a pas de script :

* le script affichera une erreur.

---

## 9) Dépannage

### Le jeu n’apparaît pas dans le menu

* Vérifier qu’il y a bien un dossier : `projet/NomJeu/`
* Vérifier le nom du dossier

### Le jeu se lance puis retour immédiat au menu

* Le script se termine immédiatement
* Le jeu n’est pas lancé correctement

### Le menu reste bloqué après lancement du jeu

* Le jeu tourne toujours
* Vérifier qu’il y a une touche pour quitter
