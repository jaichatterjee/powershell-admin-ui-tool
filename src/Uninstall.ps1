# ---- Admin Check ----
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Please run Uninstall.ps1 as Administrator"
    exit 1
}

# ---- Load Version Info ----
$VersionInfo = Get-Content "$PSScriptRoot\version.json" | ConvertFrom-Json
$InstallPath = $VersionInfo.InstallPath
$AppName     = $VersionInfo.AppName

# ---- Logging ----
$LogPath = "$env:ProgramData\$AppName\uninstall.log"
Start-Transcript -Path $LogPath -Append

Write-Host "Uninstalling $AppName"

# ---- Remove Files ----
Remove-Item $InstallPath -Recurse -Force -ErrorAction SilentlyContinue

# ---- Remove Shortcut ----
Remove-Item "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\$AppName.lnk" `
    -Force -ErrorAction SilentlyContinue

Write-Host "$AppName uninstalled successfully"

Stop-Transcript

