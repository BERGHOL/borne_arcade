# Documentation technique

Vue technique du projet `borne_arcade`: architecture, scripts, CI et limites.

## 1) Objectif du projet

Le projet maintient un menu de borne d'arcade multi-jeux et son outillage.
Objectifs:
- installation reproductible,
- build automatique,
- documentation versionnee,
- deploiement simple sur borne.

## 2) Architecture generale

Elements principaux:
- `*.java` a la racine: menu principal.
- `projet/`: jeux (un dossier par jeu).
- `NomJeu.sh` a la racine: lanceur associe a `projet/NomJeu/`.
- `scripts/`: installation, build, tests, docs, maintenance.
- `docs/`: documentation source markdown.
- `docs-site/`: artefacts generes (site + javadoc).
- `.githooks/`: hooks versionnes.

## 3) Pipeline execution locale

Flux classique:
1. `scripts/build.sh` compile MG2D puis menu.
2. `scripts/test.sh` verifie structure jeux et tests Java.
3. `scripts/check_docs.sh` valide et regenere la doc.
4. `scripts/run.sh` lance le menu Java.

## 4) Scripts importants

- `install.sh`: installation dependances + build initial.
- `provision.sh`: provisionnement post-install OS.
- `update.sh`: sequence post pull (permissions, build, doc, restart service).
- `check_games.sh`: verifie dossier jeu <-> script de lancement.
- `gen_docs.sh`: genere javadoc + site MkDocs.
- `ai_doc_review.py`: produit un rapport IA de verification documentaire.
- `generate_release_notes.py`: brouillon de release notes base commit logs.

## 5) Documentation et IA

La doc suit un modele Docs-as-Code:
- pages dans `docs/`,
- validation CI,
- publication auto sur `main`.

L'IA sert d'assistant:
- analyse diff,
- propose des ajouts/corrections,
- genere un rapport.

Validation finale: humaine.

## 6) CI/CD

Workflows GitHub:
- `docs.yml`: checks doc sur PR, nightly, publication sur main.
- `release-notes.yml`: brouillon notes de version sur tag `v*`.

## 7) Service et exploitation

Selon la cible, le menu peut etre lance:
- manuellement (`scripts/run.sh`),
- via systemd (`borne-arcade.service` ou service user `borne.service`).

`update.sh` tente un restart service si un service compatible est detecte.

## 8) Limites connues

- Environnement Windows local: `bash`/WSL peut manquer.
- Publication docs depend de la configuration GitHub Pages du repo.
- Qualite release notes depend de la discipline de message commit.

## 9) Recommandations maintenance

- Garder les scripts commentes et idempotents.
- Eviter les chemins absolus machine.
- Garder `docs/` synchronise avec les changements scripts/workflows.
- Exiger review humaine avant merge.