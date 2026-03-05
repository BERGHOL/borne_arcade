# Documentation technique — Borne d’arcade

## 1. Objectif du projet

Le projet consiste à maintenir et moderniser le logiciel de la borne d’arcade du département informatique.

Les objectifs principaux sont :

- Restaurer un projet dont le dépôt d’origine a été perdu.
- Automatiser la compilation et l’installation.
- Générer automatiquement la documentation.
- Permettre le déploiement automatique via Git.
- Rendre le système compatible avec des versions récentes de Raspberry Pi OS et de Java.
- Garantir une maintenance durable et autonome dans le temps.

---

## 2. Architecture générale du projet

Structure principale :

borne_arcade/
├── build/                → classes compilées du menu
├── build_mg2d/           → classes compilées de la bibliothèque MG2D
├── docs/                 → documentation Markdown
├── docs-site/            → documentation générée automatiquement
├── img/                  → images du menu
├── fonts/                → polices utilisées
├── sound/                → sons et musiques
├── projet/               → dossiers des jeux
├── scripts/              → scripts d’automatisation
├── .githooks/            → hooks Git (auto update)
├── Main.java             → point d’entrée du menu
└── autres fichiers .java → code source du menu

---

## 3. Bibliothèque MG2D

Le menu utilise la bibliothèque graphique MG2D.

Règle imposée :
Le code de MG2D ne doit pas être modifié.

Toutes les adaptations ont été réalisées uniquement dans le code de la borne.

MG2D est clonée automatiquement lors de l’installation si elle n’est pas présente.

---

## 4. Problème de compatibilité audio (Java récent)

Lors du passage à Java 21, une erreur empêchait le lancement :

unable to load resource 'sfd.ser'
at MG2D.audio.decoder.SynthesisFilter

Cause :

- MG2D utilise JavaLayer pour lire les fichiers MP3.
- JavaLayer dépend d’une ressource interne (sfd.ser) qui n’est plus correctement chargée avec les versions modernes de Java.

Contraintes :

- MG2D ne doit pas être modifiée.
- La bibliothèque est considérée comme externe.

Solution adoptée :

- Désactivation de la musique de fond dans Graphique.java.
- Suppression de l’initialisation audio problématique.
- Le menu fonctionne sans musique.

Cette solution respecte la consigne et assure la stabilité.

---

## 5. Scripts d’automatisation

Tous les scripts se trouvent dans :

scripts/

### 5.1 install.sh

Installe automatiquement :

- OpenJDK
- Python3
- Love2D
- xdotool
- Git
- Clonage automatique de MG2D
- Compilation du projet

Commande :

./scripts/install.sh

---

### 5.2 build.sh

Compile :

- MG2D
- Le menu de la borne

Commande :

./scripts/build.sh

---

### 5.3 run.sh

Lance le menu principal.

Commande :

./scripts/run.sh

---

### 5.4 check_games.sh

Vérifie :

- Présence des scripts .sh pour chaque jeu
- Cohérence des dépendances

Commande :

./scripts/check_games.sh

---

### 5.5 update.sh

Exécuté automatiquement après un git pull.

Fonctions :

- Vérification MG2D
- Réapplication des permissions (chmod +x)
- Rebuild automatique
- Génération documentation
- Redémarrage du service systemd

Commande manuelle :

./scripts/update.sh

---

## 6. Génération automatique de la documentation

Script utilisé :

scripts/gen_docs.sh

Fonctions :

- Génération Javadoc
- Construction du site MkDocs
- Copie des fichiers Markdown

Documentation générée dans :

docs-site/

Commande :

./scripts/gen_docs.sh

---

## 7. Déploiement automatique via Git

Le projet contient :

.githooks/

Hooks utilisés :

- post-merge
- post-checkout

Ces hooks exécutent automatiquement :

scripts/update.sh

Après un :

git pull

La borne :

1. Met à jour les fichiers
2. Recompile automatiquement
3. Régénère la documentation
4. Redémarre le service

---

## 8. Service systemd

Un service Linux permet le lancement automatique au démarrage.

Fichier :

/etc/systemd/system/borne-arcade.service

Caractéristiques :

- Type=simple
- Restart=on-failure
- WorkingDirectory défini
- ExecStart=./scripts/run.sh

Avantages :

- Démarrage automatique
- Redémarrage en cas de crash
- Intégration native au système Linux

---

## 9. Cycle complet d’automatisation

Au démarrage de la borne :

1. systemd lance le service.
2. Vérification des mises à jour Git.
3. Si mise à jour :
   - exécution de update.sh
   - recompilation
   - génération documentation
4. Lancement du menu.

En cas de crash :
- systemd redémarre automatiquement le service.

Le système est autonome et auto-réparable.

---

## 10. Gestion des permissions

Après un git pull, certaines permissions peuvent être perdues.

Le script update.sh applique automatiquement :

- chmod +x sur scripts/
- chmod +x sur .githooks/
- chmod +x sur les scripts de jeux

Cela évite les erreurs de type :

Permission denied

---

## 11. Tests réalisés

Tests effectués sur :

- Machine virtuelle Debian
- Java 21
- Environnement Raspberry simulé

Tests validés :

- Compilation automatique
- Lancement du menu
- Ajout d’un jeu
- Génération documentation
- Update automatique via Git
- Redémarrage automatique systemd

---

## 12. Montée de version du système

Objectif :

- Migration depuis ancienne version Raspbian
- Passage vers Raspberry Pi OS récent

Procédure :

1. Installation propre du nouvel OS
2. Création utilisateur arcade
3. Clonage du projet
4. Exécution de install.sh
5. Activation du service systemd

Le projet fonctionne sur un OS moderne.

---

## 13. Justification des choix techniques

Hooks Git :
Permettent une mise à jour automatique sans intervention humaine.

systemd :
Solution native Linux fiable pour services persistants.

Désactivation audio :
Respect de la contrainte de ne pas modifier MG2D.

Scripts bash :
Solution portable et maintenable sur Raspberry Pi OS.

---

## 14. Limites connues

- Audio désactivé (incompatibilité MG2D / Java récent).
- Dépendance à la bibliothèque externe MG2D.
- Certains jeux peuvent nécessiter des dépendances spécifiques.

---

## 15. Conclusion

Le projet a été :

- Restauré
- Automatisé
- Documenté
- Rendu compatible avec des systèmes modernes

La borne peut désormais être :

- Installée automatiquement
- Mise à jour via Git
- Relancée automatiquement en cas de crash
- Maintenue durablement dans le temps