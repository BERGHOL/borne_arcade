#!/usr/bin/env python3
from pathlib import Path
import subprocess

REPORT = Path("docs-site/ai-doc-review.md")

def run(cmd: str) -> str:
    try:
        return subprocess.check_output(cmd, shell=True, text=True).strip()
    except:
        return "Impossible de récupérer le diff."

def main():
    REPORT.parent.mkdir(parents=True, exist_ok=True)

    diff = run("git diff HEAD~1 HEAD")

    report = f"""
# Rapport IA documentation

## Diff analysé
{diff}

## Actions recommandées

- Vérifier INSTALLATION.md
- Vérifier DOCUMENTATION_TECHNIQUE.md
- Vérifier AJOUT_JEU.md
- Vérifier UTILISATEUR.md

Règle : L'IA propose, l'humain valide.
"""

    REPORT.write_text(report)

if __name__ == "__main__":
    main()
