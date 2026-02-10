# Déploiement automatique via Git

Objectif : après un `git pull` sur la borne, le projet se recompile et se met à jour automatiquement.

## Principe
On utilise des Git hooks versionnés dans `.githooks/` :
- `post-merge` : déclenché après `git pull`
- `post-checkout` : déclenché après `git checkout`

Ces hooks appellent :
- `scripts/update.sh` (rebuild + relance si service systemd configuré)

## Activation (à faire une seule fois sur la borne)
Dans le dossier du dépôt :

```bash
chmod +x scripts/setup_git_hooks.sh
./scripts/setup_git_hooks.sh
