# Intune / SCCM Detection Logic

Typical detection strategies used for deployment:

## File Detection
- Application folder existence
- Version file presence

## Registry Detection (Optional)
- Application registry key
- Version comparison

## Exit Codes
- Install.ps1 returns success/failure codes
- Uninstall.ps1 confirms clean removal

