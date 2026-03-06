# Documentation du projet

Cette page explique comment verifier et generer la documentation.

## Fichiers inclus

- `INSTALLATION.md`
- `DOCUMENTATION_TECHNIQUE.md`
- `UTILISATEUR.md`
- `AJOUT_JEU.md`
- `DEPLOIEMENT_GIT.md`
- `STYLE_GUIDE.md`

## Verification locale

Depuis la racine du projet:

```bash
bash scripts/check_docs.sh
```

Ce script:
- verifie la presence des pages obligatoires,
- regenere la documentation (`scripts/gen_docs.sh`),
- verifie la sortie MkDocs (`docs-site/site/index.html`).

## Generation manuelle

```bash
bash scripts/gen_docs.sh
```

Sorties attendues:
- `docs-site/site` (site MkDocs)
- `docs-site/javadoc` (API Java)

## Bonnes pratiques

- Mettre a jour la doc dans la meme PR que le code.
- Executer `check_docs.sh` avant push.
- Utiliser `docs/STYLE_GUIDE.md` pour garder un style coherent.