$path = "C:\Program Files\SalesforceE2C"

Start-Process pwsh.exe `
    -ArgumentList "-STA -ExecutionPolicy Bypass -File `"$InstallPath\Main.ps1`"" `
    -WorkingDirectory $InstallPath `
    -WindowStyle Hidden
