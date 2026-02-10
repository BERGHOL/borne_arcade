# scripts/gen_docs.ps1
# Génère la doc: copie des .md + Javadoc (Windows)

$ErrorActionPreference = "Stop"

$PROJECT_DIR = Split-Path -Parent $PSScriptRoot
Set-Location $PROJECT_DIR

$OUT_DIR = Join-Path $PROJECT_DIR "docs-site"
$JAVADOC_DIR = Join-Path $OUT_DIR "javadoc"
$MD_DIR = Join-Path $OUT_DIR "markdown"

Write-Host "== Nettoyage =="
Remove-Item -Recurse -Force $OUT_DIR -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $JAVADOC_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $MD_DIR | Out-Null

Write-Host "== Copie docs Markdown =="
if (Test-Path (Join-Path $PROJECT_DIR "docs")) {
  Copy-Item (Join-Path $PROJECT_DIR "docs\*") $MD_DIR -Recurse -Force
} else {
  Get-ChildItem $PROJECT_DIR -Filter *.md | Copy-Item -Destination $MD_DIR -Force
}

Write-Host "== Génération Javadoc =="
$javaFiles = Get-ChildItem $PROJECT_DIR -Filter *.java -File | ForEach-Object FullName

# Vérifie que javadoc existe
$javadocCmd = Get-Command javadoc -ErrorAction SilentlyContinue
if (-not $javadocCmd) {
  Write-Host "ERREUR: 'javadoc' introuvable. Installe un JDK (pas seulement un JRE)."
  exit 1
}

javadoc -d $JAVADOC_DIR -encoding UTF-8 -charset UTF-8 -docencoding UTF-8 $javaFiles

Write-Host "OK: Documentation générée dans $OUT_DIR"
Write-Host "- Markdown: $MD_DIR"
Write-Host "- Javadoc:  $JAVADOC_DIR"
