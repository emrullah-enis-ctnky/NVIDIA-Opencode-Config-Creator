[🇬🇧 English](README.md) | [🇹🇷 Türkçe](README_TR.md) | [🇩🇪 Deutsch](README_DE.md)

# OpenCode NVIDIA API Integration

Professional setup script for configuring [OpenCode](https://opencode.ai) with NVIDIA's API models (Nemotron 3 Ultra, Nemotron 4 Ultra, Nemotron 3 Ultra Instruct, etc.) via the OpenAI-compatible API endpoint.

## Features

- **Cross-platform support**: Linux, macOS, Windows (WSL, PowerShell, CMD)
- **Cross-shell support**: Bash, Zsh, Fish, PowerShell 5.1+, pwsh 7+, CMD
- **Professional UI**: Truecolor output, Unicode icons, animated spinners
- **Secure API key input**: Hidden input with format validation (`nvapi-...`)
- **Idempotent**: Safe to run multiple times
- **Robust JSON handling**: Uses `jq` with `sed` fallback (Linux/macOS), native PowerShell JSON (Windows)
- **Smart shell RC updates**: Idempotent export/set operations
- **Dry-run, help, version flags**
- **Beautiful summary output** with restart instructions

## Quick Start

### Linux / macOS / WSL (Bash/Zsh/Fish)

```bash
# Clone the repository
git clone https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator.git
cd NVIDIA-Opencode-Config-Creator

# Make script executable
chmod +x setup-opencode.sh

# Run setup
./setup-opencode.sh
```

### Windows (PowerShell 5.1+ / PowerShell 7+)

```powershell
# Clone the repository
git clone https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator.git
cd NVIDIA-Opencode-Config-Creator

# Run setup (execution policy may need bypass)
powershell -ExecutionPolicy Bypass -File setup-opencode.ps1

# Or from within PowerShell:
.\setup-opencode.ps1
```

### Windows (Command Prompt / CMD)

```cmd
# Clone the repository
git clone https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator.git
cd NVIDIA-Opencode-Config-Creator

# Run setup
setup-opencode.bat
```

The script will:
1. Detect your shell (bash/zsh/fish/powershell/pwsh/cmd)
2. Create `~/.config/opencode/opencode.json` (Linux/macOS) or `%APPDATA%\opencode\opencode.json` (Windows)
3. Prompt for NVIDIA API key (secure hidden input)
4. Set `OPENCODE_CONFIG_FILE` in your shell profile/RC file
5. Show summary with restart instructions

## Requirements

- **OpenCode** installed (`npm install -g opencode-ai` or [install script](https://opencode.ai/docs/installation))
- **Node.js** 18+ (required by OpenCode)
- **NVIDIA API Key** from [build.nvidia.com](https://build.nvidia.com)
- **jq** (optional but recommended for robust JSON handling on Linux/macOS)

### Shell Support

| Shell | Config File | Platform | Status |
|-------|-------------|----------|--------|
| Bash | `~/.bashrc` | Linux/macOS/WSL/Git Bash | ✅ Full |
| Zsh | `~/.zshrc` | Linux/macOS/WSL | ✅ Full |
| Fish | `~/.config/fish/config.fish` | Linux/macOS/WSL | ✅ Full |
| PowerShell 5.1 | `~/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1` | Windows | ✅ Full |
| PowerShell 7+ (pwsh) | `~/.config/powershell/Microsoft.PowerShell_profile.ps1` | Windows/Linux/macOS | ✅ Full |
| CMD | N/A (uses PowerShell for profile) | Windows | ✅ Full |

## Script Options

```bash
./setup-opencode.sh [options]

Options:
  -h, --help      Show help message
  --dry-run       Validate without making changes
  --version       Show version
```

## What Gets Created

### Config File

**Linux/macOS/WSL:** `~/.config/opencode/opencode.json`
**Windows:** `%APPDATA%\opencode\opencode.json`

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "nvidia": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "NVIDIA",
      "options": {
        "baseURL": "https://integrate.api.nvidia.com/v1",
        "apiKey": "nvapi-YOUR_ACTUAL_KEY"
      },
      "models": {
        "minimaxai/minimax-m2.7": { "name": "MiniMax M2.7" },
        "qwen/qwen3-coder-480b-a35b-instruct": { "name": "Qwen3 Coder 480B" },
        "deepseek-ai/deepseek-v3.2": { "name": "DeepSeek V3.2" }
      }
    }
  }
}
```

### Shell RC / Profile Update

```bash
# Bash/Zsh (~/.bashrc, ~/.zshrc)
export OPENCODE_CONFIG_FILE="$HOME/.config/opencode/opencode.json"

# Fish (~/.config/fish/config.fish)
set -Ux OPENCODE_CONFIG_FILE "$HOME/.config/opencode/opencode.json"
```

```powershell
# PowerShell 5.1 (~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1)
$env:OPENCODE_CONFIG_FILE = "$env:APPDATA\opencode\opencode.json"

# PowerShell 7+ (~\AppData\Local\Microsoft\PowerShell\Microsoft.PowerShell_profile.ps1)
$env:OPENCODE_CONFIG_FILE = "$env:APPDATA\opencode\opencode.json"
```

## After Installation

### Linux / macOS / WSL

```bash
# Restart shell or source RC file
source ~/.bashrc      # bash
source ~/.zshrc       # zsh
source ~/.config/fish/config.fish  # fish

# Test OpenCode
opencode
```

### Windows (PowerShell)

```powershell
# Restart shell or source profile
. $PROFILE

# Test OpenCode
opencode
```

### Windows (CMD)

```cmd
REM Restart terminal or run:
powershell -ExecutionPolicy Bypass -File $PROFILE

REM Test OpenCode
opencode
```

## Models Included

| Model ID | Display Name |
|----------|-------------|
| `nvidia/nemotron-3-ultra` | Nemotron 3 Ultra |
| `nvidia/nemotron-4-ultra` | Nemotron 4 Ultra |
| `nvidia/nemotron-3-ultra-instruct` | Nemotron 3 Ultra Instruct |

To add more models, edit `~/.config/opencode/opencode.json` and check [NVIDIA Build](https://build.nvidia.com/explore/discover) for available model IDs.

## Getting NVIDIA API Key

1. Go to [build.nvidia.com](https://build.nvidia.com)
2. Sign in / create account
3. Navigate to "API Keys" or "My API Keys"
4. Create new key (starts with `nvapi-`)
5. Copy and paste when prompted by setup script

## Troubleshooting

### Invalid API Key Format
```
Error: Invalid API key format
```
- Key must start with `nvapi-`
- Must be 20+ characters after prefix
- Get new key at [build.nvidia.com](https://build.nvidia.com)

### Unsupported Shell
```
Error: Unsupported shell: fish
```
- Only bash, zsh, fish supported
- For other shells, manually add `OPENCODE_CONFIG_FILE` to your RC file

### jq Not Found
```
Warning: jq not found, using sed fallback
```
- Install jq for robust JSON handling:
  - Ubuntu/Debian: `sudo apt install jq`
  - macOS: `brew install jq`
  - Arch: `sudo pacman -S jq`

### Config Not Loading
```bash
# Check environment variable
echo $OPENCODE_CONFIG_FILE

# Check config file exists
cat ~/.config/opencode/opencode.json

# Test OpenCode
opencode --version
```

### Permission Denied
```bash
chmod +x setup-opencode.sh
```

## Manual Configuration

If you prefer manual setup:

### Linux / macOS / WSL

1. **Copy template**:
   ```bash
   mkdir -p ~/.config/opencode
   cp opencode-template.json ~/.config/opencode/opencode.json
   ```

2. **Edit API key** in `~/.config/opencode/opencode.json`

3. **Add to shell RC**:
   ```bash
   # bash/zsh
   echo 'export OPENCODE_CONFIG_FILE="$HOME/.config/opencode/opencode.json"' >> ~/.bashrc
   
   # fish
   echo 'set -Ux OPENCODE_CONFIG_FILE "$HOME/.config/opencode/opencode.json"' >> ~/.config/fish/config.fish
   ```

4. **Restart shell** and test with `opencode`

### Windows (PowerShell)

1. **Copy template**:
   ```powershell
   New-Item -ItemType Directory -Force -Path "$env:APPDATA\opencode"
   Copy-Item opencode-template.json "$env:APPDATA\opencode\opencode.json"
   ```

2. **Edit API key** in `%APPDATA%\opencode\opencode.json`

3. **Add to PowerShell profile**:
   ```powershell
   # PowerShell 5.1
   Add-Content $PROFILE.CurrentUserAllHosts "`$env:OPENCODE_CONFIG_FILE = `"$env:APPDATA\opencode\opencode.json`""
   
   # PowerShell 7+ (pwsh)
   Add-Content $PROFILE.CurrentUserAllHosts "`$env:OPENCODE_CONFIG_FILE = `"$env:APPDATA\opencode\opencode.json`""
   ```

4. **Restart shell** and test with `opencode`

## File Structure

```
.
├── README.md                 # This file (English)
├── README_TR.md              # Turkish version
├── README_DE.md              # German version
├── opencode-template.json    # OpenCode config template
├── setup-opencode.sh         # Main setup script (Linux/macOS/WSL: bash/zsh/fish)
├── setup-opencode.ps1        # PowerShell setup script (Windows: PowerShell 5.1+, pwsh 7+)
└── setup-opencode.bat        # Batch/CMD setup script (Windows: cmd.exe)
```

## Template Configuration

The `opencode-template.json` uses the OpenAI-compatible provider with pre-configured models available on NVIDIA Build:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "nvidia": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "NVIDIA",
      "options": {
        "baseURL": "https://integrate.api.nvidia.com/v1",
        "apiKey": "nvapi-YOUR_API_KEY_HERE"
      },
      "models": {
        "minimaxai/minimax-m2.7": { "name": "MiniMax M2.7" },
        "qwen/qwen3-coder-480b-a35b-instruct": { "name": "Qwen3 Coder 480B" },
        "deepseek-ai/deepseek-v3.2": { "name": "DeepSeek V3.2" }
      }
    }
  }
}
```

To add more models, edit `~/.config/opencode/opencode.json` (Linux/macOS) or `%APPDATA%\opencode\opencode.json` (Windows) and check [NVIDIA Build](https://build.nvidia.com/explore/discover) for available model IDs.

## Links

- [OpenCode Documentation](https://opencode.ai/docs)
- [NVIDIA Build Models](https://build.nvidia.com/explore/discover)
- [OpenAI-Compatible Provider](https://sdk.vercel.ai/providers/ai-sdk-providers/openai-compatible)
- [Nemotron Model Cards](https://huggingface.co/nvidia)

## License

MIT License - Free to use, modify, and distribute.

## Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Submit Pull Request

## Support

- **Bug reports**: [GitHub Issues](https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator/issues)
- **OpenCode help**: [OpenCode Discord](https://discord.gg/opencode)
- **NVIDIA API questions**: [NVIDIA Developer Forums](https://forums.developer.nvidia.com/)