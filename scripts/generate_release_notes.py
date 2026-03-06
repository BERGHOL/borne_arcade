#!/usr/bin/env python3
"""Generate draft release notes from recent commit messages.

Conventional commits are grouped by type, then a generic section stores the rest.
"""

from __future__ import annotations

from collections import defaultdict
from pathlib import Path
import re
import subprocess

OUT = Path("docs-site/release-notes-draft.md")

TYPE_LABELS = {
    "feat": "Nouveautes",
    "fix": "Corrections",
    "docs": "Documentation",
    "refactor": "Refactoring",
    "perf": "Performance",
    "test": "Tests",
    "build": "Build",
    "ci": "CI",
    "chore": "Maintenance",
}

CONVENTIONAL_RE = re.compile(r"^(?P<type>[a-z]+)(\([^)]+\))?!?:\s*(?P<msg>.+)$")


def run(cmd: list[str]) -> str:
    """Execute command and return stripped stdout."""
    return subprocess.check_output(cmd, text=True).strip()


def main() -> None:
    OUT.parent.mkdir(parents=True, exist_ok=True)

    try:
        # Last 100 commits usually covers one release window.
        log = run(["git", "log", "--pretty=format:%h%x09%s", "-100"])
    except subprocess.CalledProcessError:
        OUT.write_text("# Release notes\n\nImpossible de recuperer les commits.\n", encoding="utf-8")
        return

    grouped: dict[str, list[tuple[str, str]]] = defaultdict(list)
    other: list[tuple[str, str]] = []

    for line in log.splitlines():
        if "\t" not in line:
            continue
        sha, subject = line.split("\t", 1)
        match = CONVENTIONAL_RE.match(subject)
        if not match:
            other.append((sha, subject))
            continue
        ctype = match.group("type")
        msg = match.group("msg").strip()
        grouped[ctype].append((sha, msg))

    lines: list[str] = [
        "# Brouillon de release notes",
        "",
        "Notes generees automatiquement a partir de l'historique Git.",
        "Validation humaine obligatoire avant publication.",
        "",
    ]

    ordered_types = ["feat", "fix", "docs", "refactor", "perf", "test", "build", "ci", "chore"]
    for ctype in ordered_types:
        entries = grouped.get(ctype)
        if not entries:
            continue
        lines.append(f"## {TYPE_LABELS.get(ctype, ctype)}")
        lines.append("")
        for sha, msg in entries:
            lines.append(f"- {msg} (`{sha}`)")
        lines.append("")

    if other:
        lines.append("## Autres changements")
        lines.append("")
        for sha, msg in other:
            lines.append(f"- {msg} (`{sha}`)")
        lines.append("")

    OUT.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()