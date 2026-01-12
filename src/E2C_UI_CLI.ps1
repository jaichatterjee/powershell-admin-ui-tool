# =====================================================
# LOAD REQUIRED ASSEMBLIES
# =====================================================
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# =====================================================
# FORM
# =====================================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "E2C Shared Mailbox Tool"
$form.Size = New-Object System.Drawing.Size(700,700)
$form.StartPosition = "CenterScreen"
$form.MaximizeBox = $false
$form.FormBorderStyle = 'FixedDialog'

# =====================================================
# HELPER UI FUNCTIONS
# =====================================================
function Add-Label($text,$x,$y){
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $text
    $lbl.Location = "$x,$y"
    $lbl.Size = '200,20'
    $lbl.Font = New-Object System.Drawing.Font ("Calibri" , 15, [System.Drawing.FontStyle]::Bold)
    $form.Controls.Add($lbl)
}

function Add-Textbox($x,$y){
    $txt = New-Object System.Windows.Forms.TextBox
    $txt.Location = "$x,$y"
    $txt.Width = 260
    $form.Controls.Add($txt)
    return $txt
}

# =====================================================
# UI CONTROL HELPERS
# =====================================================
function Set-Progress([int]$value){
    if ($value -gt 100) { $value = 100 }
    if ($value -lt 0) { $value = 0 }
    $progress.Value = $value
    $progress.Refresh()
}

function Lock-UI {
    $btnModule.Enabled  = $false
    $btnConnect.Enabled = $false
    $btnCheck.Enabled   = $false
    $btnCreate.Enabled  = $false
    $btnAddUser.Enabled = $false
}

function Unlock-UI {
    $btnModule.Enabled  = $true
    $btnConnect.Enabled = $true
    $btnCheck.Enabled   = $true
    $btnCreate.Enabled  = $true
    $btnAddUser.Enabled = $true
}

# =====================================================
# LABELS
# =====================================================

Add-Label "Shared Mailbox Name" 20 20
$txtMailbox = Add-Textbox 350 20

Add-Label "Mailbox Alias(-E2C)" 20 55
$txtAlias = Add-Textbox 350 55

Add-Label "Primary SMTP Address" 20 90
$txtSMTP = Add-Textbox 350 88

Add-Label "User Email Address" 20 125
$txtUser = Add-Textbox 350 123

# =====================================================
# PROGRESS BAR
# =====================================================
$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Location = '20,261'
$progress.Size = '540,20'
$progress.Minimum = 0
$progress.Maximum = 100
$form.Controls.Add($progress)

# =====================================================
# BUTTONS
# =====================================================
$btnConnect = New-Object System.Windows.Forms.Button
$btnConnect.Text = "Connect Exchange"
$btnConnect.Location = '20,165'
$btnConnect.Width = 140
$form.Controls.Add($btnConnect)

$btnCheck = New-Object System.Windows.Forms.Button
$btnCheck.Text = "Check Mailbox"
$btnCheck.Location = '20,225'
$btnCheck.Width = 140
$form.Controls.Add($btnCheck)

$btnCreate = New-Object System.Windows.Forms.Button
$btnCreate.Text = "Create E2C Mailbox"
$btnCreate.Location = '340,165'
$btnCreate.Width = 140
$form.Controls.Add($btnCreate)

$btnModule = New-Object System.Windows.Forms.Button
$btnModule.Text = "Check / Install Module"
$btnModule.Location = '340,225'
$btnModule.Width = 150
$form.Controls.Add($btnModule)

$btnAddUser = New-Object System.Windows.Forms.Button
$btnAddUser.Text = "Add User"
$btnAddUser.Location = '210,193'
$form.Controls.Add($btnAddUser)

# =====================================================
# CORE FUNCTION
# =====================================================
function Update-Module {
    if (-not (Get-Module ExchangeOnlineManagement -ListAvailable)) {
        Write-Log "Installing ExchangeOnlineManagement module..."
        Install-Module ExchangeOnlineManagement -Scope AllUsers -Force -AllowClobber
        Write-Log "Module installed successfully."
    } else {
        Write-Log "ExchangeOnlineManagement module already present."
    }
}

# =====================================================
# LOG WINDOW
# =====================================================
$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Location = '20,300'
$logBox.Size = '540,320'
$logBox.Multiline = $true
$logBox.ScrollBars = "Vertical"
$logBox.ReadOnly = $true
$logBox.Font = New-Object System.Drawing.Font("Consolas", 13, [System.Drawing.FontStyle]::Regular)
$form.Controls.Add($logBox)

# =====================================================
# EVENTS
# =====================================================

$btnModule.Add_Click({
    try {
        Lock-UI
        Set-Progress 20
        Update-Module
        Set-Progress 100
    } catch {
        Write-Log "ERROR: $_"
    } finally {
        Set-Progress 0
        Unlock-UI
    }
})

$btnConnect.Add_Click({
    try {
        Lock-UI
        Set-Progress 30
        Write-Log "Connecting to Exchange Online..."
        Import-Module ExchangeOnlineManagement -ErrorAction Stop
        Connect-ExchangeOnline -ShowBanner:$false
        Set-Progress 100
        Write-Log "Connected to Exchange Online."
    } catch {
        Write-Log "ERROR: $_"
    } finally {
        Set-Progress 0
        Unlock-UI
    }
})

$btnCheck.Add_Click({
    try {
        Lock-UI
        Set-Progress 30
        

        $name = $txtMailbox.Text.Trim()
        if (-not $name) { throw "Mailbox name is required." }

        $mbx = Get-Mailbox -Identity $name -ErrorAction SilentlyContinue
        Set-Progress 100

        if ($mbx) {
            Write-Log "Mailbox exists: $($mbx.PrimarySmtpAddress)"
        } else {
            Write-Log "Mailbox not found."
        }
    } catch {
        Write-Log "ERROR: $_"
    } finally {
        Set-Progress 0
        Unlock-UI
    }
})

$btnCreate.Add_Click({
    try {
        Lock-UI
        Set-Progress 30
        

        $name  = $txtMailbox.Text.Trim()
        $alias = $txtAlias.Text.Trim()
        $smtp  = $txtSMTP.Text.Trim()

        if ($alias -notmatch "-E2C$") { throw "Alias must end with -E2C." }
        if ($smtp -notmatch "^[^@\s]+@[^@\s]+\.[^@\s]+$") { throw "Invalid SMTP address." }

        if (Get-Mailbox -Identity $name -ErrorAction SilentlyContinue) {
            throw "Mailbox already exists."
        }

        Set-Progress 70
        New-Mailbox -Shared `
            -Name $name `
            -DisplayName $name `
            -Alias $alias `
            -PrimarySmtpAddress $smtp

        Set-Progress 100
        Write-Log "Shared mailbox '$name' created successfully."
    } catch {
        Write-Log "ERROR: $_"
    } finally {
        Set-Progress 0
        Unlock-UI
    }
})

$btnAddUser.Add_Click({
    try {
        Lock-UI
        Set-Progress 20
        

        $SharedMailboxName = $txtMailbox.Text.Trim()
        $UserName          = $txtUser.Text.Trim()

        if (-not $SharedMailboxName -or -not $UserName) {
            throw "Shared mailbox name and user email are required."
        }

        $mailbox = Get-Mailbox -Identity $SharedMailboxName -ErrorAction SilentlyContinue
        if (-not $mailbox) {
            throw "Shared mailbox '$SharedMailboxName' does not exist."
        }

        Set-Progress 60

        $existingPermission = Get-MailboxPermission -Identity $SharedMailboxName |
            Where-Object {
                $_.User -like "*$UserName*" -and
                $_.AccessRights -contains "FullAccess"
            }

        if ($existingPermission) {
            Write-Log "User '$UserName' already has FullAccess on '$SharedMailboxName'."
            return
        }

        Set-Progress 80

        Add-MailboxPermission `
            -Identity $SharedMailboxName `
            -User $UserName `
            -AccessRights FullAccess `
            -AutoMapping:$false `
            -Confirm:$false

        Set-Progress 100
        Write-Log "User '$UserName' added to mailbox '$SharedMailboxName' successfully."
    } catch {
        Write-Log "ERROR while adding user: $_"
    } finally {
        Set-Progress 0
        Unlock-UI
    }
})

function Write-Log {
    param($msg)
    $logBox.AppendText("[$(Get-Date -Format HH:mm:ss)] $msg`r`n")
}

# ================= RUN =================
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
