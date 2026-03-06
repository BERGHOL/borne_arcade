# Installation de la borne arcade

Ce guide couvre l'installation complete sur Raspberry Pi OS / Debian.

## 1) Prerequis

- Raspberry Pi 3 ou plus recent (recommande).
- Raspberry Pi OS (ou Debian) avec acces Internet.
- Utilisateur avec droits sudo.
- Depot `borne_arcade` clone localement.

## 2) Preparation systeme

Depuis un terminal:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y git
```

## 3) Cloner le projet

```bash
git clone https://github.com/BERGHOL/borne_arcade.git
cd borne_arcade
```

## 4) Installation automatique

Lancer:

```bash
bash scripts/install.sh
```

Le script:
- installe Java, Python, Love2D, MkDocs et utilitaires,
- verifie/clone MG2D,
- applique les permissions sur les scripts,
- configure les hooks git si disponibles,
- compile le projet,
- tente de generer la documentation.

## 5) Demarrage automatique du menu

Option A (recommandee): provisionnement complet (installe aussi un service user)

```bash
bash scripts/provision.sh
```

Option B: lancement manuel

```bash
bash scripts/run.sh
```

## 6) Verification apres installation

Verifier les points suivants:
- build present (`build/` et `build_mg2d/`),
- menu lancable,
- documentation generable.

Commandes utiles:

```bash
bash scripts/test.sh
bash scripts/check_docs.sh
bash scripts/run.sh
```

## 7) Mise a jour

En local:

```bash
git pull
```

Si les hooks sont actifs, `scripts/update.sh` est execute automatiquement.

## 8) Problemes frequents

### MG2D introuvable

- Verifier que `../MG2D/MG2D` existe.
- Relancer `bash scripts/install.sh`.

### mkdocs introuvable

- Installer: `sudo apt install -y mkdocs`

### Echec de build Java

- Verifier la version Java installee.
- Relancer `bash scripts/build.sh` et lire l'erreur complete.