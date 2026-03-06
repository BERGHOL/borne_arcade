# Ajouter et deployer un nouveau jeu

Ce guide explique comment integrer un jeu dans la borne.

## 1) Regle de detection

Le menu detecte les jeux avec cette convention:
- un dossier dans `projet/NomJeu/`
- un script de lancement `NomJeu.sh` a la racine du depot

Les deux noms doivent etre identiques.

## 2) Structure minimale

Exemple pour `MonJeu`:

```text
projet/MonJeu/
MonJeu.sh
```

## 3) Script de lancement attendu

Le script doit:
- lancer le jeu,
- rester actif tant que le jeu tourne,
- se terminer proprement quand le jeu se ferme.

Exemple minimal de test:

```bash
#!/usr/bin/env bash
set -euo pipefail
echo "MonJeu demarre"
sleep 2
echo "MonJeu termine"
```

## 4) Exemple Java

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
MG2D_DIR="$(cd "$ROOT_DIR/../MG2D" && pwd)"

cd "$ROOT_DIR/projet/MonJeu"
java -cp ".:$MG2D_DIR" Main
```

## 5) Exemple Python

```bash
#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/projet/MonJeu"
python3 main.py
```

## 6) Verification obligatoire

```bash
bash scripts/check_games.sh
bash scripts/test.sh
```

Resultat attendu: aucun jeu sans script associe.

## 7) Deploiement sur la borne

1. Commit de la branche du jeu.
2. PR avec mise a jour doc associee.
3. Merge apres validation CI + review humaine.
4. `git pull` sur la borne (ou autoupdate).

## 8) Checklist PR jeu

- [ ] dossier `projet/NomJeu/` ajoute
- [ ] script `NomJeu.sh` ajoute et executable
- [ ] dependances documentees
- [ ] impact utilisateur documente (guide utilisateur)
- [ ] tests scripts passes