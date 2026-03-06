#!/usr/bin/env python3
"""Generate a lightweight AI-assisted documentation review report.

This script intentionally analyzes only a small, local diff to avoid data leaks.
Output is a markdown report consumed by CI artifacts.
"""

from pathlib import Path
import subprocess

REPORT = Path("docs-site/ai-doc-review.md")


def run(cmd: str) -> str:
    """Run a shell command and return stdout, or a fallback message."""
    try:
        return subprocess.check_output(cmd, shell=True, text=True).strip()
    except Exception:
        return "Impossible de recuperer le diff."


def main() -> None:
    # Ensure output folder exists even when docs-site is missing.
    REPORT.parent.mkdir(parents=True, exist_ok=True)

    # Keep scope minimal: only the last commit delta.
    diff = run("git diff HEAD~1 HEAD")

    report = f"""
# Rapport IA documentation

## Diff analyse
{diff}

## Actions recommandees

- Verifier INSTALLATION.md
- Verifier DOCUMENTATION_TECHNIQUE.md
- Verifier AJOUT_JEU.md
- Verifier UTILISATEUR.md

Regle: l'IA propose, l'humain valide.
"""

    REPORT.write_text(report, encoding="utf-8")


if __name__ == "__main__":
    main()