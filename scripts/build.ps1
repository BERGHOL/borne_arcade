# scripts/build.ps1
# Compile MG2D + le menu de la borne (Windows)

$ErrorActionPreference = "Stop"

# Se placer à la racine du projet (borne_arcade)
$PROJECT_DIR = Split-Path -Parent $PSScriptRoot
Set-Location $PROJECT_DIR

$MG2D_SRC = Join-Path $PROJECT_DIR "..\MG2D\MG2D"
$MG2D_OUT = Join-Path $PROJECT_DIR "build_mg2d"
$OUT      = Join-Path $PROJECT_DIR "build"

if (!(Test-Path $MG2D_SRC)) {
  Write-Host "ERREUR: MG2D introuvable à: $MG2D_SRC"
  Write-Host "Attendu: ...\SAE_06_A_Maintenance\MG2D\MG2D"
  exit 1
}

Write-Host "== Nettoyage des dossiers build =="
Remove-Item -Recurse -Force $MG2D_OUT -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force $OUT -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $MG2D_OUT | Out-Null
New-Item -ItemType Directory -Force -Path $OUT      | Out-Null

Write-Host "== Compilation MG2D =="
$mg2dFiles = Get-ChildItem $MG2D_SRC -Recurse -Filter *.java | ForEach-Object FullName
javac -d $MG2D_OUT $mg2dFiles

Write-Host "== Compilation du menu (borne_arcade) =="
$menuFiles = Get-ChildItem $PROJECT_DIR -Filter *.java | ForEach-Object FullName
javac -cp ".;$MG2D_OUT" -d $OUT $menuFiles

Write-Host "OK: Build terminé."
