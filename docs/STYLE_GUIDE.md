# Style Guide Documentation

Ce guide definit les regles de redaction pour la documentation du projet.

## Objectif

- Aider a ecrire une doc claire, maintenable et utile.
- Assurer une coherence entre toutes les pages `docs/`.
- Garder la documentation alignee avec le code et les scripts.

## Regles de redaction

- Ecrire en francais simple et direct.
- Faire des phrases courtes.
- Une idee principale par paragraphe.
- Expliquer le contexte avant la commande.
- Donner un resultat attendu quand c'est possible.

## Regles de structure

Chaque page technique devrait contenir:
- un objectif,
- les prerequis,
- les etapes,
- les erreurs courantes,
- la commande de verification.

## Regles pour les commandes

- Toujours utiliser des blocs de code.
- Eviter les chemins absolus specifiques machine.
- Preferer des chemins relatifs au depot.
- Indiquer si la commande doit etre lancee depuis la racine du projet.

## Regles Docs-as-Code

- Toute modification de script ou workflow doit verifier l'impact doc.
- Les pages a verifier en priorite sont:
  - `docs/INSTALLATION.md`
  - `docs/DOCUMENTATION_TECHNIQUE.md`
  - `docs/UTILISATEUR.md`
  - `docs/AJOUT_JEU.md`
  - `docs/DEPLOIEMENT_GIT.md`
- Le merge est bloque tant que checks CI + review humaine ne sont pas valides.

## IA et validation

- L'IA peut proposer du contenu, des correctifs, des reformulations.
- L'IA ne valide jamais seule.
- La validation finale est humaine.