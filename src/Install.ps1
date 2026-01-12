# ---- Admin Check ----
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Please run Install.ps1 as Administrator"
    exit 1
}

# ---- Load Version Info ----
$VersionInfo = Get-Content "$PSScriptRoot\version.json" | ConvertFrom-Json
$InstallPath = $VersionInfo.InstallPath
$AppName     = $VersionInfo.AppName

# ---- Logging ----
$LogPath = "$env:ProgramData\$AppName\install.log"
New-Item -ItemType Directory -Path (Split-Path $LogPath) -Force | Out-Null
Start-Transcript -Path $LogPath -Append

Write-Host "Installing $AppName to $InstallPath"

# ---- Create Install Directory ----
New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null

# ---- Copy Application Files ----
Copy-Item "$PSScriptRoot\App\*" $InstallPath -Recurse -Force

# ---- Create Start Menu Shortcut ----
$ShortcutPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\$AppName.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "pwsh.exe"
$Shortcut.Arguments  = "-STA -ExecutionPolicy Bypass -File `"$InstallPath\Main.ps1`""
$Shortcut.WorkingDirectory = $InstallPath
$Shortcut.IconLocation = "powershell.exe"
$Shortcut.Save()

Write-Host "$AppName installation completed successfully"

Stop-Transcript
