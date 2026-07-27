@echo off
REM OpenCode NVIDIA API Setup - Professional Edition for Windows (Batch/CMD)
REM Supports: cmd.exe, PowerShell (via profile detection)
REM Version: 1.0.0

setlocal enabledelayedexpansion

REM ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
REM CONFIGURATION
REM ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
set "SCRIPT_NAME=OpenCode NVIDIA Setup"
set "VERSION=1.0.0"

REM Config paths (Windows standard locations)
set "CONFIG_DIR=%APPDATA%\opencode"
set "CONFIG_FILE=%CONFIG_DIR%\opencode.json"
set "TEMPLATE_FILE=%~dp0opencode-template.json"

REM ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
REM COLORS (ANSI escape codes - Windows 10+ supports these)
REM ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
REM Enable ANSI processing (Windows 10 TH2+)
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

set "C_RESET=%ESC%[0m"
set "C_BOLD=%ESC%[1m"
set "C_DIM=%ESC%[2m"
set "C_PRIMARY=%ESC%[38;2;118;255;3m"     REM NVIDIA Green #76FF03
set "C_SECONDARY=%ESC%[38;2;0;200;150m"   REM Teal
set "C_ACCENT=%ESC%[38;2;255;140;0m"      REM Orange
set "C_SUCCESS=%ESC%[38;2;76;217;100m"    REM Green
set "C_WARNING=%ESC%[38;2;255;193;7m"     REM Amber
set "C_ERROR=%ESC%[38;2;244;67;54m"       REM Red
set "C_INFO=%ESC%[38;2;33;150;243m"       REM Blue
set "C_MUTED=%ESC%[38;2;158;158;158m"     REM Grey

set "ICON_CHECK=✓"
set "ICON_CROSS=✗"
set "ICON_ARROW=→"
set "ICON_STAR=★"
set "ICON_GEAR=⚙"
set "ICON_KEY=🔑"
set "ICON_ROCKET=🚀"
set "ICON_SPARKLE=✨"
set "ICON_FOLDER=📁"
set "ICON_FILE=📄"
set "ICON_SHELL=🐚"
set "ICON_WARNING=⚠"
set "ICON_INFO=ℹ"
set "BOX_TL=┌"
set "BOX_TR=┐"
set "BOX_BL=└"
set "BOX_BR=┘"
set "BOX_H=─"
set "BOX_V=│"
set "BOX_L=├"
set "BOX_R=┤"

REM ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
REM HELPER MACROS (using subroutines)
REM ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

REM Print header box
:PrintHeader
setlocal
set "TITLE=%~1"
set "SUBTITLE=%~2"
set "WIDTH=64"
set "TITLE_LEN=0"
for /f "delims=" %%a in ('powershell -noprofile -c "('%TITLE%').Length"') do set "TITLE_LEN=%%a"
set /a "PAD=(WIDTH - TITLE_LEN) / 2"
echo.
set "LINE="
for /l %%i in (1,1,%WIDTH%) do set "LINE=!LINE!%BOX_H%"
echo %C_PRIMARY%%BOX_TL%!LINE!%BOX_TR%%C_RESET%
set "PADDING="
for /l %%i in (1,1,%PAD%) do set "PADDING=!PADDING! "
set /a "RIGHT_PAD=WIDTH - PAD - TITLE_LEN"
set "RIGHT_PADDING="
for /l %%i in (1,1,%RIGHT_PAD%) do set "RIGHT_PADDING=!RIGHT_PADDING! "
echo %C_PRIMARY%%BOX_V%%C_RESET%!PADDING!%C_BOLD%%TITLE%%C_RESET%!RIGHT_PADDING!%C_PRIMARY%%BOX_V%%C_RESET%
if not "%SUBTITLE%"=="" (
    set "SUB_LEN=0"
    for /f "delims=" %%a in ('powershell -noprofile -c "('%SUBTITLE%').Length"') do set "SUB_LEN=%%a"
    set /a "SUB_PAD=(WIDTH - SUB_LEN) / 2"
    set "SUB_PADDING="
    for /l %%i in (1,1,%SUB_PAD%) do set "SUB_PADDING=!SUB_PADDING! "
    set /a "SUB_RIGHT=WIDTH - SUB_PAD - SUB_LEN"
    set "SUB_RIGHT_PADDING="
    for /l %%i in (1,1,%SUB_RIGHT%) do set "SUB_RIGHT_PADDING=!SUB_RIGHT_PADDING! "
    echo %C_PRIMARY%%BOX_V%%C_RESET%!SUB_PADDING!%C_DIM%%SUBTITLE%%C_RESET%!SUB_RIGHT_PADDING!%C_PRIMARY%%BOX_V%%C_RESET%
)
echo %C_PRIMARY%%BOX_BL%!LINE!%BOX_BR%%C_RESET%
echo.
endlocal
goto :eof

REM Print step
:PrintStep
setlocal
set "NUM=%~1"
set "TITLE=%~2"
set "DESC=%~3"
echo   %C_PRIMARY%%BOX_V%%C_RESET% %C_BOLD%Step %NUM%%C_RESET% %C_DIM%%TITLE%%C_RESET%
if not "%DESC%"=="" echo   %C_PRIMARY%%BOX_V%%C_RESET%   %C_MUTED%%DESC%%C_RESET%
endlocal
goto :eof

REM Print status
:PrintStatus
setlocal
set "STATUS=%~1"
set "MSG=%~2"
if "%STATUS%"=="ok"    echo   %C_SUCCESS%%ICON_CHECK%%C_RESET% %MSG%
if "%STATUS%"=="warn"  echo   %C_WARNING%%ICON_WARNING%%C_RESET% %MSG%
if "%STATUS%"=="error" echo   %C_ERROR%%ICON_CROSS%%C_RESET% %MSG%
if "%STATUS%"=="info"  echo   %C_INFO%%ICON_INFO%%C_RESET% %MSG%
if "%STATUS%"=="step"  echo   %C_ACCENT%%ICON_ARROW%%C_RESET% %MSG%
endlocal
goto :eof

REM Print key-value
:PrintKV
setlocal
set "KEY=%~1"
set "VAL=%~2"
echo   %C_DIM%%KEY%%C_RESET% %C_BOLD%%VAL%%C_RESET%
endlocal
goto :eof

REM ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
REM CORE LOGIC
REM ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

REM Detect shell
:DetectShell
REM Check for PowerShell profile first (most common on Windows)
if exist "%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" (
    set "CURRENT_SHELL=powershell"
    goto :EOF
)
if exist "%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" (
    set "CURRENT_SHELL=pwsh"
    goto :EOF
)
REM Check for common Unix-like shells on Windows
if not "%ProgramFiles%\Git\bin\bash.exe"=="" if exist "%ProgramFiles%\Git\bin\bash.exe" (
    set "CURRENT_SHELL=bash"
    goto :EOF
)
if not "%ProgramFiles%\Git\usr\bin\bash.exe"=="" if exist "%ProgramFiles%\Git\usr\bin\bash.exe" (
    set "CURRENT_SHELL=bash"
    goto :EOF
)
if not "%LOCALAPPDATA%\Microsoft\WindowsApps\bash.exe"=="" if exist "%LOCALAPPDATA%\Microsoft\WindowsApps\bash.exe" (
    set "CURRENT_SHELL=bash"
    goto :EOF
)
REM Default to PowerShell (available on all modern Windows)
set "CURRENT_SHELL=powershell"
goto :EOF

REM Get shell profile path
:GetShellProfile
setlocal
set "SHELL_TYPE=%~1"
if "%SHELL_TYPE%"=="powershell" set "PROFILE_PATH=%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
if "%SHELL_TYPE%"=="pwsh"      set "PROFILE_PATH=%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
if "%SHELL_TYPE%"=="bash"      set "PROFILE_PATH=%USERPROFILE%\.bashrc"
if "%SHELL_TYPE%"=="zsh"       set "PROFILE_PATH=%USERPROFILE%\.zshrc"
if "%SHELL_TYPE%"=="fish"      set "PROFILE_PATH=%APPDATA%\fish\config.fish"
endlocal & set "SHELL_PROFILE=%PROFILE_PATH%"
goto :EOF

REM Get shell display name
:GetShellDisplayName
setlocal
set "SHELL_TYPE=%~1"
if "%SHELL_TYPE%"=="powershell" set "DISPLAY_NAME=Windows PowerShell"
if "%SHELL_TYPE%"=="pwsh"       set "DISPLAY_NAME=PowerShell 7+"
if "%SHELL_TYPE%"=="bash"       set "DISPLAY_NAME=Git Bash / WSL Bash"
if "%SHELL_TYPE%"=="zsh"        set "DISPLAY_NAME=Zsh"
if "%SHELL_TYPE%"=="fish"       set "DISPLAY_NAME=Fish"
endlocal & set "SHELL_DISPLAY_NAME=%DISPLAY_NAME%"
goto :EOF

REM Validate API key format
:ValidateApiKey
setlocal
set "KEY=%~1"
echo %KEY% | findstr /r "^nvapi-[A-Za-z0-9_-][A-Za-z0-9_-]*$" >nul
if %errorlevel% equ 0 (
    REM Check length (at least 20 chars after nvapi-)
    set "SUFFIX=%KEY:~6%"
    powershell -noprofile -c "exit (!('%SUFFIX%'.Length -ge 20))" && exit /b 1 || exit /b 0
) else (
    exit /b 1
)
endlocal
goto :EOF

REM Read API key (masked input using PowerShell)
:ReadApiKey
setlocal
set "ATTEMPTS=0"
set "MAX_ATTEMPTS=3"
set "API_KEY="

:ReadApiKey_Loop
if %ATTEMPTS% gtr 0 (
    call :PrintStatus warn "Invalid format. NVIDIA keys start with 'nvapi-' followed by 20+ chars."
)
echo.
call :PrintKV "%C_PRIMARY%%ICON_KEY%%C_RESET% %C_BOLD%Enter your NVIDIA API Key:%C_RESET%" ""
call :PrintKV "%C_DIM%(Get one at: https://build.nvidia.com/explore/discover)%C_RESET%" ""
set /p "= %C_PRIMARY%%ICON_ARROW%%C_RESET% " <nul

REM Use PowerShell for secure masked input
for /f "delims=" %%a in ('powershell -noprofile -c "$secure = Read-Host -AsSecureString; [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)).Trim()"') do set "API_KEY=%%a"

echo.
if "%API_KEY%"=="" (
    call :PrintStatus error "API key cannot be empty."
    set /a "ATTEMPTS+=1"
    goto :ReadApiKey_Loop
)

call :ValidateApiKey "%API_KEY%"
if %errorlevel% neq 0 (
    set /a "ATTEMPTS+=1"
    if %ATTEMPTS% geq %MAX_ATTEMPTS% (
        echo.
        call :PrintStatus warn "Key format unusual. Continue anyway? [y/N] "
        set /p "CONFIRM= "
        if /i "%CONFIRM%"=="y" (
            endlocal & set "RESULT_KEY=%API_KEY%" & goto :EOF
        )
        set "API_KEY="
        set "ATTEMPTS=0"
    )
    goto :ReadApiKey_Loop
)

endlocal & set "RESULT_KEY=%API_KEY%"
goto :EOF

REM Update config file using PowerShell JSON
:UpdateConfigFile
setlocal
set "API_KEY=%~1"

REM Create config directory
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%" >nul 2>&1

REM Copy template if config doesn't exist
if not exist "%CONFIG_FILE%" (
    if not exist "%TEMPLATE_FILE%" (
        call :PrintStatus error "Template not found: %TEMPLATE_FILE%"
        exit /b 1
    )
    copy /y "%TEMPLATE_FILE%" "%CONFIG_FILE%" >nul
)

REM Update JSON using PowerShell
powershell -noprofile -c ^
    "$json = Get-Content '%CONFIG_FILE%' -Raw | ConvertFrom-Json; " ^
    "$json.provider.nvidia.options.apiKey = '%API_KEY%'; " ^
    "$json | ConvertTo-Json -Depth 10 | Set-Content '%CONFIG_FILE%' -Encoding UTF8"

if %errorlevel% neq 0 (
    call :PrintStatus error "Failed to update config file"
    exit /b 1
)
exit /b 0

REM Set environment variable in shell profile
:SetEnvVariable
setlocal
set "SHELL_TYPE=%~1"
set "VAR_NAME=%~2"
set "VAR_VALUE=%~3"

call :GetShellProfile "%SHELL_TYPE%"
set "PROFILE_PATH=%SHELL_PROFILE%"

REM Ensure profile directory exists
for %%f in ("%PROFILE_PATH%") do set "PROFILE_DIR=%%~dpf"
if not exist "%PROFILE_DIR%" mkdir "%PROFILE_DIR%" >nul 2>&1

REM Build variable line
if "%SHELL_TYPE%"=="powershell" set "VAR_LINE=$env:%VAR_NAME% = ""%VAR_VALUE%"""
if "%SHELL_TYPE%"=="pwsh"       set "VAR_LINE=$env:%VAR_NAME% = ""%VAR_VALUE%"""
if "%SHELL_TYPE%"=="bash"       set "VAR_LINE=export %VAR_NAME%=%VAR_VALUE%"
if "%SHELL_TYPE%"=="zsh"        set "VAR_LINE=export %VAR_NAME%=%VAR_VALUE%"
if "%SHELL_TYPE%"=="fish"       set "VAR_LINE=set -Ux %VAR_NAME% %VAR_VALUE%"

REM Check if already exists
set "EXISTS=0"
if exist "%PROFILE_PATH%" (
    findstr /r /c:"%VAR_NAME%" "%PROFILE_PATH%" >nul 2>&1
    if %errorlevel% equ 0 set "EXISTS=1"
)

if %EXISTS% equ 1 (
    REM Replace existing line using PowerShell
    powershell -noprofile -c ^
        "(Get-Content '%PROFILE_PATH%' -Raw) -replace '(?m)^.*%VAR_NAME%.*$', '%VAR_LINE%' | Set-Content '%PROFILE_PATH%' -Encoding UTF8"
    call :PrintStatus ok "Updated $%VAR_NAME% in profile"
) else (
    echo.>> "%PROFILE_PATH%"
    echo %VAR_LINE%>> "%PROFILE_PATH%"
    call :PrintStatus ok "Added $%VAR_NAME% to profile"
)
endlocal
goto :EOF

REM Print summary
:PrintSummary
setlocal
set "SHELL_TYPE=%~1"
call :GetShellProfile "%SHELL_TYPE%"
set "PROFILE_PATH=%SHELL_PROFILE%"
call :GetShellDisplayName "%SHELL_TYPE%"
set "SHELL_DISPLAY=%SHELL_DISPLAY_NAME%"

call :PrintHeader "SETUP COMPLETE" "%ICON_SPARKLE% Ready to use OpenCode with NVIDIA"

call :PrintStep 1 "Configuration" "OpenCode config file created"
call :PrintKV "Location:" "%CONFIG_FILE%"

call :PrintStep 2 "Environment" "OPENCODE_CONFIG_FILE exported"
call :PrintKV "Variable:" "OPENCODE_CONFIG_FILE=%CONFIG_FILE%"
call :PrintKV "Shell Profile:" "%PROFILE_PATH%"

call :PrintStep 3 "Models Available" "Pre-configured NVIDIA models"
call :PrintKV "MiniMax M2.7"       "minimaxai/minimax-m2.7"
call :PrintKV "Qwen3 Coder 480B"   "qwen/qwen3-coder-480b-a35b-instruct"
call :PrintKV "DeepSeek V3.2"      "deepseek-ai/deepseek-v3.2"

echo.
call :PrintStatus warn "Restart your shell or run:"
if "%SHELL_TYPE%"=="powershell" echo   %C_INFO%. %PROFILE_PATH%%C_RESET%
if "%SHELL_TYPE%"=="pwsh"       echo   %C_INFO%. %PROFILE_PATH%%C_RESET%
if "%SHELL_TYPE%"=="bash"       echo   %C_INFO%source %PROFILE_PATH%%C_RESET%
if "%SHELL_TYPE%"=="zsh"        echo   %C_INFO%source %PROFILE_PATH%%C_RESET%
if "%SHELL_TYPE%"=="fish"       echo   %C_INFO%source %PROFILE_PATH%%C_RESET%

echo.
call :PrintStatus info "Test with: %C_BOLD%opencode%C_RESET%"
echo.
endlocal
goto :EOF

REM ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
REM MAIN
REM ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

REM Parse arguments
set "SHOW_HELP=0"
set "DRY_RUN=0"
set "SHOW_VERSION=0"

:ParseArgs
if "%~1"=="" goto :ParseArgsDone
if /i "%~1"=="-h"     set "SHOW_HELP=1"
if /i "%~1"=="-help"  set "SHOW_HELP=1"
if /i "%~1"=="-?"     set "SHOW_HELP=1"
if /i "%~1"=="--help" set "SHOW_HELP=1"
if /i "%~1"=="--dry-run" set "DRY_RUN=1"
if /i "%~1"=="-v"     set "SHOW_VERSION=1"
if /i "%~1"=="--version" set "SHOW_VERSION=1"
shift
goto :ParseArgs

:ParseArgsDone
if %SHOW_VERSION% equ 1 (
    echo OpenCode NVIDIA Setup v%VERSION%
    exit /b 0
)

if %SHOW_HELP% equ 1 (
    call :PrintHeader "OPENCODE NVIDIA SETUP" "v%VERSION% - Configure NVIDIA API for OpenCode"
    echo Usage: %~nx0 [options]
    echo.
    echo Options:
    call :PrintKV "-h, -help, -?, --help" "Show this help message"
    call :PrintKV "--dry-run"             "Validate without making changes"
    call :PrintKV "-v, --version"         "Show version"
    echo.
    echo This script will:
    call :PrintStep 1 "Detect your shell" "(PowerShell, pwsh, Git Bash, WSL, Fish)"
    call :PrintStep 2 "Create config"    "%APPDATA%\opencode\opencode.json"
    call :PrintStep 3 "Prompt for API key" "Secure masked input (PowerShell)"
    call :PrintStep 4 "Set env variable" "OPENCODE_CONFIG_FILE in shell profile"
    echo.
    exit /b 0
)

REM ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
REM EXECUTION
REM ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

call :PrintHeader "OPENCODE NVIDIA SETUP" "v%VERSION% - Professional Configuration"

REM Step 1: Detect shell
call :PrintStep 1 "Shell Detection" "Identifying your shell environment"
call :DetectShell
call :GetShellDisplayName "%CURRENT_SHELL%"
echo   %C_SUCCESS%%ICON_CHECK%%C_RESET% Detected: %SHELL_DISPLAY_NAME%

if %DRY_RUN% equ 1 (
    call :PrintStatus info "Dry run mode - no changes will be made"
    exit /b 0
)

REM Step 2: Create config directory
call :PrintStep 2 "Config Directory" "Creating %APPDATA%\opencode"
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%" >nul 2>&1
call :PrintStatus ok "Directory ready: %CONFIG_DIR%"

REM Step 3: Get API key
call :PrintStep 3 "API Key" "Secure input for NVIDIA API key"
call :ReadApiKey
set "API_KEY=%RESULT_KEY%"

REM Step 4: Update config
call :PrintStep 4 "Configuration" "Writing API key to config file"
call :UpdateConfigFile "%API_KEY%"
if %errorlevel% neq 0 exit /b 1
call :PrintStatus ok "Config written: %CONFIG_FILE%"

REM Step 5: Set environment variable
call :PrintStep 5 "Environment" "Setting OPENCODE_CONFIG_FILE in shell profile"
call :SetEnvVariable "%CURRENT_SHELL%" "OPENCODE_CONFIG_FILE" "%CONFIG_FILE%"

REM Summary
call :PrintSummary "%CURRENT_SHELL%"

exit /b 0