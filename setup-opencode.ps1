<#
.SYNOPSIS
    OpenCode NVIDIA API Setup - Professional Edition for Windows (PowerShell)
.DESCRIPTION
    Configures OpenCode with NVIDIA API models via OpenAI-compatible endpoint.
    Supports PowerShell 5.1+, PowerShell 7+ (pwsh), Git Bash, WSL Bash, Zsh, Fish.
.NOTES
    Version: 1.0.0
    Requires: OpenCode installed, NVIDIA API Key from build.nvidia.com
#>

#Requires -Version 5.1

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# CONFIGURATION
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$ScriptName = "OpenCode NVIDIA Setup"
$Version = "1.0.0"

# Windows standard config location: %APPDATA%\opencode\
$ConfigDir = Join-Path $env:APPDATA "opencode"
$ConfigFile = Join-Path $ConfigDir "opencode.json"
$TemplateFile = Join-Path $PSScriptRoot "opencode-template.json"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# COLORS & STYLING (ANSI with fallback)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$SupportsAnsi = ($PSVersionTable.PSEdition -eq 'Core') -or ([System.Console]::OutputEncoding.CodePage -eq 65001)
if ($SupportsAnsi) {
    $C = @{
        Reset     = "`e[0m"; Bold = "`e[1m"; Dim = "`e[2m"
        Primary   = "`e[38;2;118;255;3m"     # NVIDIA Green #76FF03
        Secondary = "`e[38;2;0;200;150m"     # Teal
        Accent    = "`e[38;2;255;140;0m"     # Orange
        Success   = "`e[38;2;76;217;100m"    # Green
        Warning   = "`e[38;2;255;193;7m"     # Amber
        Error     = "`e[38;2;244;67;54m"     # Red
        Info      = "`e[38;2;33;150;243m"    # Blue
        Muted     = "`e[38;2;158;158;158m"   # Grey
    }
    $Icon = @{
        Check   = "✓"; Cross = "✗"; Arrow = "→"; Star = "★"; Gear = "⚙"
        Key = "🔑"; Rocket = "🚀"; Sparkle = "✨"; Folder = "📁"; File = "📄"
        Shell = "🐚"; Warning = "⚠"; Info = "ℹ"
        BoxTL = "┌"; BoxTR = "┐"; BoxBL = "└"; BoxBR = "┘"
        BoxH = "─"; BoxV = "│"; BoxL = "├"; BoxR = "┤"
    }
} else {
    $C = @{ Reset=""; Bold=""; Dim=""; Primary=""; Secondary=""; Accent=""; Success=""; Warning=""; Error=""; Info=""; Muted="" }
    $Icon = @{ Check="[OK]"; Cross="[X]"; Arrow="->"; Star="*"; Gear="[CFG]"; Key="[KEY]"; Rocket="[>>]"; Sparkle="*"
        Folder="[DIR]"; File="[FILE]"; Shell="[SH]"; Warning="[!]"; Info="[i]"
        BoxTL="+"; BoxTR="+"; BoxBL="+"; BoxBR="+"; BoxH="-"; BoxV="|"; BoxL="+"; BoxR="+"
    }
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# UTILITY FUNCTIONS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

function Write-Header {
    param([string]$Title, [string]$Subtitle = "")
    $width = 64
    $pad = [math]::Floor(($width - $Title.Length) / 2)
    Write-Host ""
    Write-Host ($C.Primary + $Icon.BoxTL + ($Icon.BoxH * $width) + $Icon.BoxTR + $C.Reset)
    Write-Host ($C.Primary + $Icon.BoxV + $C.Reset + (" " * $pad) + $C.Bold + $Title + $C.Reset + (" " * ($width - $pad - $Title.Length)) + $C.Primary + $Icon.BoxV + $C.Reset)
    if ($Subtitle) {
        $subPad = [math]::Floor(($width - $Subtitle.Length) / 2)
        Write-Host ($C.Primary + $Icon.BoxV + $C.Reset + (" " * $subPad) + $C.Dim + $Subtitle + $C.Reset + (" " * ($width - $subPad - $Subtitle.Length)) + $C.Primary + $Icon.BoxV + $C.Reset)
    }
    Write-Host ($C.Primary + $Icon.BoxBL + ($Icon.BoxH * $width) + $Icon.BoxBR + $C.Reset)
    Write-Host ""
}

function Write-Step {
    param([int]$Num, [string]$Title, [string]$Desc = "")
    Write-Host ("  {0}{1}{2} {3}{4}{5} {6}{7}{8}" -f $C.Primary, $Icon.BoxV, $C.Reset, $C.Bold, "Step $Num", $C.Reset, $C.Dim, $Title, $C.Reset)
    if ($Desc) { Write-Host ("  {0}{1}{2}   {3}{4}{5}" -f $C.Primary, $Icon.BoxV, $C.Reset, $C.Muted, $Desc, $C.Reset) }
}

function Write-Status {
    param([ValidateSet('Ok','Warn','Error','Info','Step')][string]$Status, [string]$Msg)
    switch ($Status) {
        'Ok'    { Write-Host ("  {0}{1}{2} {3}" -f $C.Success, $Icon.Check, $C.Reset, $Msg) }
        'Warn'  { Write-Host ("  {0}{1}{2} {3}" -f $C.Warning, $Icon.Warning, $C.Reset, $Msg) }
        'Error' { Write-Host ("  {0}{1}{2} {3}" -f $C.Error, $Icon.Cross, $C.Reset, $Msg) }
        'Info'  { Write-Host ("  {0}{1}{2} {3}" -f $C.Info, $Icon.Info, $C.Reset, $Msg) }
        'Step'  { Write-Host ("  {0}{1}{2} {3}" -f $C.Accent, $Icon.Arrow, $C.Reset, $Msg) }
    }
}

function Write-KV {
    param([string]$Key, [string]$Val)
    Write-Host ("  {0}{1}{2} {3}{4}{5}" -f $C.Dim, $Key, $C.Reset, $C.Bold, $Val, $C.Reset)
}

function Show-Spinner {
    param([ScriptBlock]$Action, [string]$Message = "Working...")
    $spinner = '⠋','⠙','⠹','⠸','⠼','⠴','⠦','⠧','⠇','⠏'
    $i = 0
    $job = Start-Job -ScriptBlock $Action
    Write-Host -NoNewline ("  {0}{1}{2} {3}" -f $C.Primary, $spinner[0], $C.Reset, $Message)
    while ($job.State -eq 'Running') {
        Start-Sleep -Milliseconds 80
        $i = ($i + 1) % $spinner.Count
        Write-Host -NoNewline ("`r  {0}{1}{2} {3}" -f $C.Primary, $spinner[$i], $C.Reset, $Message)
    }
    $result = Receive-Job -Job $job
    Remove-Job -Job $job
    Write-Host ("`r  {0}{1}{2} {3}" -f $C.Success, $Icon.Check, $C.Reset, $Message)
    return $result
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# CORE LOGIC
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

function Detect-Shell {
    # Detect current shell from $PSHOME, $SHELL, or process name
    $hostName = (Get-Item $PSHOME).Name.ToLower()
    if ($hostName -like 'pwsh*') { return 'pwsh' }
    if ($hostName -like 'powershell*') { return 'powershell' }
    if ($env:SHELL -like '*bash*') { return 'bash' }
    if ($env:SHELL -like '*zsh*') { return 'zsh' }
    if ($env:SHELL -like '*fish*') { return 'fish' }
    # Check parent process for Git Bash / WSL
    $parent = Get-CimInstance Win32_Process -Filter "ProcessId = $PID" | Select-Object -ExpandProperty ParentProcessId
    if ($parent) {
        $pname = (Get-CimInstance Win32_Process -Filter "ProcessId = $parent").Name.ToLower()
        if ($pname -like '*bash*') { return 'bash' }
        if ($pname -like '*zsh*') { return 'zsh' }
        if ($pname -like '*fish*') { return 'fish' }
    }
    return 'powershell'
}

function Get-ShellProfile {
    param([string]$Shell)
    switch ($Shell) {
        'powershell' { return $PROFILE.CurrentUserAllHosts }  # Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
        'pwsh'       { return $PROFILE.CurrentUserAllHosts }   # ~/.config/powershell/Microsoft.PowerShell_profile.ps1
        'bash'       { return Join-Path $env:USERPROFILE '.bashrc' }
        'zsh'        { return Join-Path $env:USERPROFILE '.zshrc' }
        'fish'       { return Join-Path $env:APPDATA 'fish\config.fish' }
        default      { return $null }
    }
}

function Get-ShellDisplayName {
    param([string]$Shell)
    switch ($Shell) {
        'powershell' { return 'Windows PowerShell' }
        'pwsh'       { return 'PowerShell 7+' }
        'bash'       { return 'Git Bash / WSL Bash' }
        'zsh'        { return 'Zsh' }
        'fish'       { return 'Fish' }
        default      { return 'Unknown' }
    }
}

function Test-ApiKeyFormat {
    param([string]$Key)
    return $Key -match '^nvapi-[A-Za-z0-9_-]{20,}$'
}

function Read-ApiKey {
    $attempts = 0
    $maxAttempts = 3
    $key = ""

    while (-not $key) {
        if ($attempts -gt 0) {
            Write-Status 'Warn' "Invalid format. NVIDIA keys start with 'nvapi-' followed by 20+ chars."
        }
        Write-Host ""
        Write-Host ("  {0}{1}{2} {3}{4}{5}" -f $C.Primary, $Icon.Key, $C.Reset, $C.Bold, "Enter your NVIDIA API Key:", $C.Reset)
        Write-Host ("  {0}(Get one at: https://build.nvidia.com/explore/discover){1}" -f $C.Dim, $C.Reset)
        Write-Host -NoNewline ("  {0}{1}{2} " -f $C.Primary, $Icon.Arrow, $C.Reset)

        # Secure read (masked input)
        $secureKey = Read-Host -AsSecureString
        $key = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey)
        ).Trim()

        if (-not $key) {
            Write-Status 'Error' "API key cannot be empty."
            $attempts++
            continue
        }

        if (-not (Test-ApiKeyFormat $key)) {
            $attempts++
            if ($attempts -ge $maxAttempts) {
                Write-Host ""
                Write-Status 'Warn' "Key format unusual. Continue anyway? [y/N] "
                $confirm = Read-Host
                if ($confirm -match '^[Yy]$') { break }
                $key = ""
                $attempts = 0
            }
        } else {
            break
        }
    }
    return $key
}

function Update-ConfigFile {
    param([string]$ApiKey)

    # Create config directory
    if (-not (Test-Path $ConfigDir)) {
        New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
    }

    # Copy template if config doesn't exist
    if (-not (Test-Path $ConfigFile)) {
        if (-not (Test-Path $TemplateFile)) {
            Write-Status 'Error' "Template not found: $TemplateFile"
            return $false
        }
        Copy-Item $TemplateFile $ConfigFile -Force
    }

    # Update JSON using PowerShell native JSON
    try {
        $json = Get-Content $ConfigFile -Raw | ConvertFrom-Json
        $json.provider.nvidia.options.apiKey = $ApiKey
        $json | ConvertTo-Json -Depth 10 | Set-Content $ConfigFile -Encoding UTF8
        return $true
    } catch {
        Write-Status 'Error' "Failed to update config: $($_.Exception.Message)"
        return $false
    }
}

function Set-EnvVariable {
    param([string]$Shell, [string]$VarName, [string]$VarValue)
    $profilePath = Get-ShellProfile -Shell $Shell
    if (-not $profilePath) { return $false }

    # Ensure profile directory exists
    $profileDir = Split-Path $profilePath -Parent
    if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force | Out-Null }

    $varLine = switch ($Shell) {
        'powershell' { "`$env:$VarName = `"$VarValue`"" }
        'pwsh'       { "`$env:$VarName = `"$VarValue`"" }
        'bash'       { "export $VarName=`"$VarValue`"" }
        'zsh'        { "export $VarName=`"$VarValue`"" }
        'fish'       { "set -Ux $VarName `"$VarValue`"" }
        default      { return $false }
    }

    $existing = $false
    if (Test-Path $profilePath) {
        $content = Get-Content $profilePath -Raw
        if ($content -match [regex]::Escape($VarName)) {
            $existing = $true
            $newContent = $content -replace "(?m)^.*$([regex]::Escape($VarName)).*$", $varLine
            Set-Content $profilePath -Value $newContent -Encoding UTF8
            Write-Status 'Ok' "Updated `$VarName in $(Split-Path $profilePath -Leaf)"
        }
    }

    if (-not $existing) {
        Add-Content $profilePath -Value "`n$varLine" -Encoding UTF8
        Write-Status 'Ok' "Added `$VarName to $(Split-Path $profilePath -Leaf)"
    }
    return $true
}

function Write-Summary {
    param([string]$Shell)
    $profilePath = Get-ShellProfile -Shell $Shell
    $shellName = Get-ShellDisplayName -Shell $Shell

    Write-Header "SETUP COMPLETE" "$($Icon.Sparkle) Ready to use OpenCode with NVIDIA"

    Write-Step 1 "Configuration" "OpenCode config file created"
    Write-KV "Location:" $ConfigFile

    Write-Step 2 "Environment" "OPENCODE_CONFIG_FILE exported"
    Write-KV "Variable:" "OPENCODE_CONFIG_FILE=$ConfigFile"
    Write-KV "Shell Profile:" $profilePath

    Write-Step 3 "Models Available" "Pre-configured NVIDIA models"
    Write-KV "MiniMax M2.7"       "minimaxai/minimax-m2.7"
    Write-KV "Qwen3 Coder 480B"   "qwen/qwen3-coder-480b-a35b-instruct"
    Write-KV "DeepSeek V3.2"      "deepseek-ai/deepseek-v3.2"

    Write-Host ""
    Write-Status 'Warn' "Restart your shell or run:"
    switch ($Shell) {
        'powershell' { Write-Host ("  {0}. {1}{2}" -f $C.Info, $profilePath, $C.Reset) }
        'pwsh'       { Write-Host ("  {0}. {1}{2}" -f $C.Info, $profilePath, $C.Reset) }
        'bash'       { Write-Host ("  {0}source {1}{2}" -f $C.Info, $profilePath, $C.Reset) }
        'zsh'        { Write-Host ("  {0}source {1}{2}" -f $C.Info, $profilePath, $C.Reset) }
        'fish'       { Write-Host ("  {0}source {1}{2}" -f $C.Info, $profilePath, $C.Reset) }
    }

    Write-Host ""
    Write-Status 'Info' "Test with: ${C.Bold}opencode${C.Reset}"
    Write-Host ""
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# MAIN
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

function Show-Help {
    Write-Header "OPENCODE NVIDIA SETUP" "v$Version - Configure NVIDIA API for OpenCode"
    Write-Host "Usage: .\setup-opencode.ps1 [options]"
    Write-Host ""
    Write-Host "Options:"
    Write-KV "-Help, -?"      "Show this help message"
    Write-KV "-DryRun"        "Validate without making changes"
    Write-KV "-Version"       "Show version"
    Write-Host ""
    Write-Host "This script will:"
    Write-Step 1 "Detect your shell" "(PowerShell, pwsh, Git Bash, WSL, Fish)"
    Write-Step 2 "Create config"    "$env:APPDATA\opencode\opencode.json"
    Write-Step 3 "Prompt for API key" "Secure masked input"
    Write-Step 4 "Set env variable" "OPENCODE_CONFIG_FILE in shell profile"
    Write-Host ""
}

# Parse arguments
$ShowHelp = $false
$DryRun = $false
$ShowVersion = $false

$args | ForEach-Object {
    switch -Wildcard ($_ ) {
        '-h*'  { $ShowHelp = $true }
        '-help' { $ShowHelp = $true }
        '-?'   { $ShowHelp = $true }
        '-dry*' { $DryRun = $true }
        '-v*'  { $ShowVersion = $true }
    }
}

if ($ShowVersion) { Write-Host "OpenCode NVIDIA Setup v$Version"; exit 0 }
if ($ShowHelp) { Show-Help; exit 0 }

# Execution
Write-Header "OPENCODE NVIDIA SETUP" "v$Version - Professional Configuration"

# Step 1: Detect shell
Write-Step 1 "Shell Detection" "Identifying your shell environment"
$currentShell = Detect-Shell
if ($currentShell -eq 'unknown') {
    Write-Status 'Error' "Unsupported shell. Supported: PowerShell, pwsh, Git Bash, WSL, Fish"
    exit 1
}
Write-Status 'Ok' "Detected: $(Get-ShellDisplayName -Shell $currentShell)"

if ($DryRun) {
    Write-Status 'Info' "Dry run mode - no changes will be made"
    exit 0
}

# Step 2: Create config directory
Write-Step 2 "Config Directory" "Creating $env:APPDATA\opencode"
Show-Spinner -Action { New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null } -Message "Creating config directory..."
Write-Status 'Ok' "Directory ready: $ConfigDir"

# Step 3: Get API key
Write-Step 3 "API Key" "Secure input for NVIDIA API key"
$apiKey = Read-ApiKey

# Step 4: Update config
Write-Step 4 "Configuration" "Writing API key to config file"
Show-Spinner -Action { Update-ConfigFile -ApiKey $apiKey } -Message "Updating config file..."
Write-Status 'Ok' "Config written: $ConfigFile"

# Step 5: Set environment variable
Write-Step 5 "Environment" "Setting OPENCODE_CONFIG_FILE in shell profile"
Show-Spinner -Action { Set-EnvVariable -Shell $currentShell -VarName "OPENCODE_CONFIG_FILE" -VarValue $ConfigFile } -Message "Updating shell configuration..."

# Summary
Write-Summary -Shell $currentShell