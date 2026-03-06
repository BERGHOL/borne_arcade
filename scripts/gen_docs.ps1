# scripts/gen_docs.ps1
# Build documentation on Windows: Javadoc + Markdown copy + MkDocs site when available.

$ErrorActionPreference = "Stop"

$PROJECT_DIR = Split-Path -Parent $PSScriptRoot
Set-Location $PROJECT_DIR

$OUT_DIR = Join-Path $PROJECT_DIR "docs-site"
$JAVADOC_DIR = Join-Path $OUT_DIR "javadoc"
$MD_DIR = Join-Path $OUT_DIR "markdown"
$SITE_DIR = Join-Path $OUT_DIR "site"

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

Write-Host "== Generation Javadoc =="
$javaFiles = Get-ChildItem $PROJECT_DIR -Filter *.java -File | ForEach-Object FullName
$javadocCmd = Get-Command javadoc -ErrorAction SilentlyContinue
if (-not $javadocCmd) {
  Write-Host "ERREUR: 'javadoc' introuvable. Installe un JDK (pas seulement un JRE)."
  exit 1
}

javadoc -d $JAVADOC_DIR -encoding UTF-8 -charset UTF-8 -docencoding UTF-8 $javaFiles

Write-Host "== Generation MkDocs (optionnel sous Windows) =="
$mkdocsCmd = Get-Command mkdocs -ErrorAction SilentlyContinue
if ($mkdocsCmd) {
  mkdocs build --site-dir $SITE_DIR
  Write-Host "OK: site MkDocs genere dans $SITE_DIR"
} else {
  Write-Host "Info: mkdocs non installe, generation du site ignoree."
}

Write-Host "OK: documentation generee dans $OUT_DIR"
Write-Host "- Markdown: $MD_DIR"
Write-Host "- Javadoc:  $JAVADOC_DIR"