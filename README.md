# OpenCode NVIDIA API Integration

Professional setup script for configuring [OpenCode](https://opencode.ai) with NVIDIA's API models (Nemotron, Nemotron 3 Ultra, Nemotron 4 Ultra, Nemotron 3 Ultra Instruct, etc.) via the OpenAI-compatible API endpoint.

## Features

- **Cross-shell support**: Bash, Zsh, Fish
- **Professional UI**: Truecolor output, Unicode icons, animated spinners
- **Secure API key input**: Hidden input with format validation (`nvapi-...`)
- **Idempotent**: Safe to run multiple times
- **Robust JSON handling**: Uses `jq` when available, pure bash fallback
- **Shell integration**: Automatically updates `.bashrc`, `.zshrc`, or `config.fish`
- **Dry-run mode**: Preview changes without applying
- **Pre-configured models**: Nemotron 3 Ultra, Nemotron 4 Ultra, Nemotron 3 Ultra Instruct

## Quick Start

```bash
# Clone the repository
git clone https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator.git
cd NVIDIA-Opencode-Config-Creator

# Make script executable and run
chmod +x setup-opencode.sh
./setup-opencode.sh
```

## Prerequisites

| Requirement | Version | Notes |
|-------------|---------|-------|
| Bash | 4.0+ | Default on most Linux/macOS |
| curl | Any | For downloading (not required for script) |
| jq | 1.6+ | Optional but recommended for JSON handling |
| NVIDIA API Key | - | Get from [build.nvidia.com](https://build.nvidia.com/explore/discover) |

### Shell Support

| Shell | Config File | Status |
|-------|-------------|--------|
| Bash | `~/.bashrc` | ✅ Full support |
| Zsh | `~/.zshrc` | ✅ Full support |
| Fish | `~/.config/fish/config.fish` | ✅ Full support |

## Installation

### Option 1: Direct Script (Recommended)

```bash
# Download and run in one line
curl -fsSL https://raw.githubusercontent.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator/main/setup-opencode.sh | bash
```

### Option 2: Clone and Run

```bash
git clone https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator.git
cd NVIDIA-Opencode-Config-Creator
chmod +x setup-opencode.sh
./setup-opencode.sh
```

### Option 3: Dry Run First

```bash
./setup-opencode.sh --dry-run
```

## Configuration

### NVIDIA API Key

Get your API key from [NVIDIA Build](https://build.nvidia.com/explore/discover):

1. Sign in with NVIDIA account
2. Navigate to **Explore Models**
3. Select a model (e.g., Nemotron 3 Ultra)
4. Click **Get API Key**
5. Copy the key (format: `nvapi-...`)

The script validates the key format (`nvapi-` prefix + 20+ characters).

### Pre-configured Models

| Model ID | Display Name | Description |
|----------|--------------|-------------|
| `nvidia/nemotron-3-ultra` | Nemotron 3 Ultra | 53B parameter general-purpose model |
| `nvidia/nemotron-4-ultra` | Nemotron 4 Ultra | Latest flagship model |
| `nvidia/nemotron-3-ultra-instruct` | Nemotron 3 Ultra Instruct | Instruction-tuned variant |

*Models are configured in `opencode-template.json` and can be customized.*

## What the Script Does

1. **Detects your shell** (bash/zsh/fish)
2. **Creates config directory**: `~/.config/opencode/`
3. **Copies template** to `~/.config/opencode/opencode.json`
4. **Prompts for API key** (hidden input)
5. **Updates config** with your API key
6. **Sets environment variable** `OPENCODE_CONFIG_FILE` in your shell RC file
7. **Shows summary** with restart instructions

## Post-Installation

Restart your shell or source the config:

```bash
# Bash/Zsh
source ~/.bashrc    # or ~/.zshrc

# Fish
source ~/.config/fish/config.fish
```

Then launch OpenCode:

```bash
opencode
```

## Manual Configuration (Alternative)

If you prefer manual setup:

### 1. Create Config Directory

```bash
mkdir -p ~/.config/opencode
```

### 2. Copy Template

```bash
cp opencode-template.json ~/.config/opencode/opencode.json
```

### 3. Edit API Key

```bash
# Using sed (replace placeholder)
sed -i 's|nvapi-YOUR_API_KEY_HERE|nvapi-YOUR_ACTUAL_KEY|' ~/.config/opencode/opencode.json

# Or use your preferred editor
nano ~/.config/opencode/opencode.json
```

### 4. Set Environment Variable

**Bash/Zsh** (`~/.bashrc` or `~/.zshrc`):
```bash
export OPENCODE_CONFIG_FILE="$HOME/.config/opencode/opencode.json"
```

**Fish** (`~/.config/fish/config.fish`):
```fish
set -Ux OPENCODE_CONFIG_FILE "$HOME/.config/opencode/opencode.json"
```

### 5. Reload Shell

```bash
source ~/.bashrc  # or source ~/.zshrc / source ~/.config/fish/config.fish
```

## Usage with OpenCode

Once configured, OpenCode will automatically use the NVIDIA provider:

```bash
# Start OpenCode
opencode

# List available models
opencode models list

# Use a specific model
opencode --model nvidia/nemotron-3-ultra
```

## Customizing Models

Edit `opencode-template.json` before running the script, or edit `~/.config/opencode/opencode.json` after:

```json
{
  "provider": {
    "nvidia": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "NVIDIA",
      "options": {
        "baseURL": "https://integrate.api.nvidia.com/v1",
        "apiKey": "nvapi-YOUR_KEY"
      },
      "models": {
        "nvidia/nemotron-3-ultra": { "name": "Nemotron 3 Ultra" },
        "nvidia/nemotron-4-ultra": { "name": "Nemotron 4 Ultra" },
        "nvidia/nemotron-3-ultra-instruct": { "name": "Nemotron 3 Ultra Instruct" }
      }
    }
  }
}
```

Add any model available at [NVIDIA Build](https://build.nvidia.com/explore/discover) using the model ID format.

## Script Options

```bash
./setup-opencode.sh [OPTIONS]

Options:
  -h, --help      Show help message
  --dry-run       Validate without making changes
  --version       Show version
```

## Troubleshooting

### API Key Invalid
```
Error: Invalid API key format
```
- Ensure key starts with `nvapi-`
- Key should be 20+ characters after prefix
- Get a new key from [NVIDIA Build](https://build.nvidia.com)

### Shell Not Supported
```
Error: Unsupported shell: fish
```
- Only bash, zsh, and fish are supported
- For other shells, use manual configuration

### jq Not Found
```
Warning: jq not found, using sed fallback
```
- Install jq for more robust JSON handling:
  - Ubuntu/Debian: `sudo apt install jq`
  - macOS: `brew install jq`
  - Arch: `sudo pacman -S jq`

### Config Not Loading
```bash
# Verify environment variable
echo $OPENCODE_CONFIG_FILE

# Verify config file exists
cat ~/.config/opencode/opencode.json

# Test OpenCode
opencode --version
```

### Permission Denied
```bash
chmod +x setup-opencode.sh
```

## File Structure

```
.
├── README.md                 # This file
├── opencode-template.json    # OpenCode config template
└── setup-opencode.sh         # Main setup script
```

## Template Configuration

`opencode-template.json` uses the OpenAI-compatible provider:

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
        "nvidia/nemotron-3-ultra": { "name": "Nemotron 3 Ultra" },
        "nvidia/nemotron-4-ultra": { "name": "Nemotron 4 Ultra" },
        "nvidia/nemotron-3-ultra-instruct": { "name": "Nemotron 3 Ultra Instruct" }
      }
    }
  }
}
```

## Requirements

- **OpenCode** installed (`npm install -g opencode-ai` or via [install script](https://opencode.ai/docs/installation))
- **Node.js** 18+ (required by OpenCode)
- **NVIDIA API Key** from [build.nvidia.com](https://build.nvidia.com)

## Links

- [OpenCode Documentation](https://opencode.ai/docs)
- [NVIDIA Build Models](https://build.nvidia.com/explore/discover)
- [OpenAI-Compatible Provider](https://sdk.vercel.ai/providers/ai-sdk-providers/openai-compatible)
- [Nemotron Model Cards](https://huggingface.co/nvidia)

## License

MIT License - Feel free to use, modify, and distribute.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a Pull Request

## Support

- Open an [issue](https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator/issues) for bugs
- Check [OpenCode Discord](https://discord.gg/opencode) for OpenCode help
- Visit [NVIDIA Developer Forums](https://forums.developer.nvidia.com/) for API questions