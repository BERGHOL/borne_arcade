# Documentation technique — Borne d’arcade

## 1. Objectif du projet

Le projet consiste à maintenir et moderniser le logiciel de la borne d’arcade du département informatique.

Les objectifs principaux sont :

* Restaurer un projet dont le dépôt d’origine a été perdu.
* Automatiser la compilation et l’installation.
* Générer automatiquement la documentation.
* Permettre le déploiement automatique via Git.
* Rendre le système compatible avec des versions récentes de l’OS et de Java.

---

## 2. Architecture générale du projet

Structure principale du projet :

```
borne_arcade/
├── build/                → classes compilées du menu
├── build_mg2d/           → classes compilées de la bibliothèque MG2D
├── docs/                 → documentation Markdown
├── docs-site/            → documentation générée automatiquement
├── img/                  → images utilisées par le menu
├── fonts/                → polices utilisées par le menu
├── sound/                → sons et musiques
├── projet/               → dossiers des jeux
├── scripts/              → scripts d’automatisation
├── .githooks/            → hooks Git pour déploiement automatique
├── Main.java             → point d’entrée du menu
└── *.java                → code source du menu
```

---

## 3. Bibliothèque MG2D

Le menu de la borne utilise la bibliothèque graphique :

* **MG2D**

Cette bibliothèque est considérée comme **externe**.

### Règle imposée par l’enseignant

> Le code de MG2D ne doit pas être modifié.

Toutes les adaptations ont donc été faites **uniquement dans le code de la borne**.

---

## 4. Problème de compatibilité audio

Lors du passage à une version récente de Java (Java 21), le système audio de MG2D provoquait un crash au démarrage.

Erreur observée :

```
unable to load resource 'sfd.ser'
at MG2D.audio.decoder.SynthesisFilter
```

Cause :

* MG2D utilise JavaLayer pour lire les fichiers MP3.
* JavaLayer dépend d’une ressource interne : `sfd.ser`.
* Cette ressource n’est plus correctement chargée avec les versions récentes de Java.

### Contraintes

* MG2D ne doit pas être modifié.
* Il est donc impossible de corriger la bibliothèque directement.

### Solution de maintenance adoptée

* Désactivation de la musique de fond dans `Graphique.java`.
* Le menu fonctionne sans audio.
* Le système est stable sur les versions récentes de Java.

Cette solution est conforme à une démarche de maintenance logicielle.

---

## 5. Scripts d’automatisation

Tous les scripts se trouvent dans le dossier :

```
scripts/
```

### 5.1 install.sh

Installe les dépendances nécessaires :

* Java (OpenJDK)
* outils de base

Commande :

```
./scripts/install.sh
```

---

### 5.2 build.sh

Compile :

* la bibliothèque MG2D
* le menu de la borne

Commande :

```
./scripts/build.sh
```

---

### 5.3 run.sh

Lance le menu de la borne.

Commande :

```
./scripts/run.sh
```

---

### 5.4 test.sh

Effectue des tests de base :

* vérification des jeux
* compilation du projet

Commande :

```
./scripts/test.sh
```

---

### 5.5 update.sh

Script exécuté automatiquement après un `git pull`.

Fonctions :

* mise à jour du projet
* recompilation automatique
* redémarrage du service si nécessaire

Commande manuelle :

```
./scripts/update.sh
```

---

## 6. Génération automatique de la documentation

Script utilisé :

```
scripts/gen_docs.ps1
```

Fonctions :

* copie des fichiers Markdown
* génération de la Javadoc
* création du site de documentation dans :

```
docs-site/
```

Commande :

```
powershell -ExecutionPolicy Bypass -File scripts/gen_docs.ps1
```

---

## 7. Déploiement automatique via Git

Le projet contient un dossier :

```
.githooks/
```

Hooks utilisés :

* `post-merge`
* `post-checkout`

Ces hooks exécutent automatiquement :

```
scripts/update.sh
```

Après un :

```
git pull
```

La borne :

1. met à jour les fichiers
2. recompile le projet
3. redémarre le menu si nécessaire

---

## 8. Installation sur une borne ou une VM

Procédure :

### 1. Copier ou cloner le projet

```
git clone <repo>
cd borne_arcade
```

ou copier le dossier.

### 2. Installer les dépendances

```
./scripts/install.sh
```

### 3. Tester le projet

```
./scripts/test.sh
```

### 4. Lancer le menu

```
./scripts/run.sh
```

---

## 9. Tests réalisés

Les tests ont été effectués :

* sur une machine virtuelle Debian
* avec une version récente de Java

Tests validés :

* compilation automatique
* lancement du menu
* ajout d’un jeu
* génération de la documentation
* scripts d’installation et de test

---

## 10. Montée de version du système

Objectif :

* passer d’une ancienne version de Raspbian
* à une version récente de Raspberry Pi OS

Procédure :

1. Installation manuelle du nouvel OS (Raspberry Pi Imager).
2. Création de l’utilisateur `arcade`.
3. Installation automatique du projet avec `install.sh`.
4. Configuration du démarrage automatique.

---

## 11. Limites connues

* Audio désactivé à cause d’une incompatibilité MG2D / Java récent.
* MG2D non modifié conformément aux consignes.

---

## 12. Conclusion

Le projet a été :

* restauré
* automatisé
* documenté
* rendu compatible avec des systèmes modernes

La borne peut désormais être :

* installée automatiquement
* mise à jour via Git
* utilisée sur un OS récent
