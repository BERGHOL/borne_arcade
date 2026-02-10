# scripts/test.ps1
$ErrorActionPreference = "Stop"

$PROJECT_DIR = Split-Path -Parent $PSScriptRoot
Set-Location $PROJECT_DIR

Write-Host "== Build =="
powershell -ExecutionPolicy Bypass -File .\scripts\build.ps1

Write-Host "== Test structure jeux =="
powershell -ExecutionPolicy Bypass -File .\scripts\check_games.ps1

Write-Host "== Tests Java (exécution des classes de test) =="

# Classpath = classes du menu compilées + MG2D compilé
$cp = ".\build;.\build_mg2d"

# Test HighScore
Write-Host "-- TestHighScore --"
java -cp $cp TestHighScore

# Test Clavier (peut nécessiter une interaction selon le code)
Write-Host "-- TestClavierBorneArcade --"
java -cp $cp TestClavierBorneArcade

Write-Host "OK: tests terminés"
