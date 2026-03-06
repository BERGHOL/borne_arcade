# Deploiement Git et Docs-as-Code

Objectif: automatiser verification, generation et publication de la documentation, sans supprimer la validation humaine.

## 1) Principe cle

Docs-as-Code:
- la doc vit dans le depot,
- la doc suit le meme cycle que le code (commit, PR, review, CI),
- la doc est publiee automatiquement sur `main`.

Regle d'or:
- l'IA propose,
- l'humain valide,
- aucun merge sans checks et review.

## 2) Workflow CI cible

Declencheurs:
- `pull_request`: verification docs + rapport IA.
- `push` sur `main`: verification + publication docs.
- `schedule` nightly: passe de controle documentaire.

Garde-fous:
- hooks locaux (`pre-commit`, `post-merge`, `post-checkout`),
- template de PR avec checklist documentation,
- regles de branche (approvals obligatoires, checks obligatoires).

## 3) Role exact de l'IA

### Usage 1: Doc patch PR

Entrees minimales:
- diff git,
- pages docs impactees,
- style guide.

Sorties:
- patch de documentation propose,
- resume de changements et points a relire.

### Usage 2: Doc coverage

Detection des trous:
- changement script/code sans mise a jour doc,
- How-to manquant,
- incoherence entre doc et implementation.

### Usage 3: Release notes

A chaque tag:
- extraction commits,
- classement par type,
- reformulation en notes lisibles.

## 4) Activation locale des hooks

```bash
bash scripts/setup_git_hooks.sh
```

Hooks utilises:
- `.githooks/pre-commit`
- `.githooks/post-merge`
- `.githooks/post-checkout`

## 5) Verification locale avant PR

```bash
bash scripts/test.sh
bash scripts/check_docs.sh
```

## 6) Publication

La publication de la doc est faite par workflow GitHub Actions sur `main`.