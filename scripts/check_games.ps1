# scripts/check_games.ps1
# Validate that each game directory has a matching launcher script.

$ErrorActionPreference = "Stop"

$PROJECT_DIR = Split-Path -Parent $PSScriptRoot
Set-Location $PROJECT_DIR

Write-Host "== Verification des jeux =="

if (!(Test-Path ".\projet")) {
  Write-Host "ERREUR: dossier 'projet/' introuvable"
  exit 1
}

$fail = $false

Get-ChildItem ".\projet" -Directory | ForEach-Object {
  $game = $_.Name
  $script = ".\$game.sh"
  if (!(Test-Path $script)) {
    Write-Host "ERREUR: script manquant pour le jeu '$game' (attendu: $script)"
    $fail = $true
  }
}

if ($fail) {
  Write-Host "KO: certains jeux n'ont pas de script .sh"
  exit 1
}

Write-Host "OK: tous les jeux ont un script .sh"