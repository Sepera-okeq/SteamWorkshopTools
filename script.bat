@echo off
:: Check if pwsh exists
where /q pwsh
if errorlevel 1 (
  :: If pwsh doesn't exist, run with PowerShell
  Powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\SteamManager.ps1
) else (
  :: If pwsh exists, run with pwsh
  pwsh.exe .\scripts\SteamManager.ps1
)