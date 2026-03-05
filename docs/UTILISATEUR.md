# Documentation utilisateur — Borne d’arcade

Cette borne d’arcade permet de sélectionner et lancer différents jeux via un menu principal.

---

## 1) Démarrage de la borne

Lorsque la borne est allumée :

- Le système démarre automatiquement.
- Une vérification des mises à jour est effectuée.
- Le menu principal s’affiche.

Aucune manipulation clavier n’est nécessaire au démarrage.

---

## 2) Menu principal

Le menu liste automatiquement tous les jeux disponibles.

Un jeu apparaît dans le menu si :
- Un dossier existe dans `projet/`
- Un script de lancement `NomDuJeu.sh` existe à la racine

Le jeu sélectionné est visuellement mis en évidence.

---

## 3) Navigation dans le menu

- Utiliser le joystick du joueur 1 pour monter et descendre.
- Le bouton **A (J1)** permet de sélectionner un jeu.

---

## 4) Lancer un jeu

- Sélectionner un jeu avec le joystick.
- Appuyer sur **A (J1)** pour lancer le jeu.

Le menu :

- Exécute le script correspondant (`./NomDuJeu.sh`)
- Attend que le jeu se termine
- Revient automatiquement au menu principal

---

## 5) Quitter un jeu

Chaque jeu doit proposer une touche de sortie (souvent ESC).

Lorsque le joueur quitte le jeu :

- Le jeu se ferme
- Le script se termine
- Retour automatique au menu

Si un jeu ne propose pas de sortie, le menu peut sembler bloqué.

---

## 6) Quitter la borne

Depuis le menu principal :

- Appuyer sur **Z (J1)** pour demander la fermeture.
- Une confirmation s’affiche.
- Appuyer sur **A (J1)** pour confirmer.

Selon la configuration :

- L’application peut simplement se fermer
- Ou le système peut s’éteindre complètement

---

## 7) Mise à jour automatique

À chaque démarrage :

- La borne vérifie les mises à jour du projet
- Si une mise à jour est disponible :
  - Le projet est recompilé
  - La documentation est régénérée
  - Le service est redémarré automatiquement

La borne fonctionne de manière autonome.

---

## 8) Problèmes possibles

### Un jeu ne se lance pas

Vérifier :

- Le dossier `projet/NomDuJeu/` existe
- Le script `NomDuJeu.sh` existe
- Le script est exécutable :

    chmod +x NomDuJeu.sh

---

### Le menu semble bloqué

- Le jeu est encore en cours d’exécution
- Vérifier qu’il existe une touche de sortie dans le jeu

---

## 9) Utilisateur avancé

- Les contrôles peuvent dépendre du mapping clavier de la borne
- Les jeux peuvent utiliser Java, Python ou Love2D
- Le menu attend la fin complète du jeu avant de reprendre la main