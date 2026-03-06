# scripts/test.ps1
# Windows test entrypoint: build, check game layout, then run Java tests.

$ErrorActionPreference = "Stop"

$PROJECT_DIR = Split-Path -Parent $PSScriptRoot
Set-Location $PROJECT_DIR

Write-Host "== Build =="
powershell -ExecutionPolicy Bypass -File .\scripts\build.ps1

Write-Host "== Test structure jeux =="
powershell -ExecutionPolicy Bypass -File .\scripts\check_games.ps1

Write-Host "== Tests Java (execution des classes de test) =="

# Classpath = compiled menu classes + compiled MG2D classes.
$cp = ".\build;.\build_mg2d"

Write-Host "-- TestHighScore --"
java -cp $cp TestHighScore
if ($LASTEXITCODE -ne 0) { throw "TestHighScore a echoue (code $LASTEXITCODE)" }

Write-Host "-- TestClavierBorneArcade --"
java -cp $cp TestClavierBorneArcade
if ($LASTEXITCODE -ne 0) { throw "TestClavierBorneArcade a echoue (code $LASTEXITCODE)" }

Write-Host "OK: tests termines"