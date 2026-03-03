# Documentation utilisateur — Borne d’arcade

Cette borne affiche un menu permettant de lancer différents jeux.

---

## 1) Démarrage

- La borne démarre sur le menu principal.
- Le menu liste les jeux disponibles (ceux présents dans le dossier `projet/`).

---

## 2) Navigation dans le menu

- Utiliser le joystick du joueur 1 pour monter/descendre dans la liste.
- Le jeu sélectionné est mis en évidence.

---

## 3) Lancer un jeu

- Appuyer sur le bouton **A (J1)** pour lancer le jeu sélectionné.
- Le menu lance alors un script `./NomDuJeu.sh` et attend que le jeu se termine.
- Quand le jeu se ferme correctement, retour automatique au menu.

---

## 4) Quitter la borne (fermer le menu)

- Appuyer sur **Z (J1)** pour demander la fermeture.
- Une confirmation s’affiche.
- Appuyer sur **A (J1)** pour confirmer.

Selon la configuration, la fermeture peut :
- quitter uniquement l’application, ou
- provoquer l’arrêt du système (si le script de lancement le fait).

---

## 5) Si un jeu ne se lance pas

Vérifier :
- que le dossier du jeu existe : `projet/NomDuJeu/`
- que le script existe à la racine : `NomDuJeu.sh`
- sur Raspberry Pi / Linux : que le script est exécutable :
  - `chmod +x NomDuJeu.sh`

---

## 6) Remarques techniques (utile pour l’utilisateur avancé)

- Les commandes joystick/boutons peuvent dépendre du mapping clavier “borne”.
- Le menu attend la fin du jeu : si un jeu ne propose pas de sortie, il peut sembler bloqué.
