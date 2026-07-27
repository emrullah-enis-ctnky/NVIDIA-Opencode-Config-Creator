[🇬🇧 English](README.md) | [🇹🇷 Türkçe](README_TR.md) | [🇩🇪 Deutsch](README_DE.md)

# OpenCode NVIDIA API Integration

Professionelle Setup-Skripte zur Konfiguration von [OpenCode](https://opencode.ai) mit NVIDIA API-Modellen (Nemotron, MiniMax, Qwen, DeepSeek, etc.) über den OpenAI-kompatiblen API-Endpunkt.

## Funktionen

- **Cross-Plattform**: Linux, macOS, Windows (WSL, PowerShell, CMD)
- **Cross-Shell Support**: Bash, Zsh, Fish, PowerShell 5.1+, pwsh 7+, Git Bash, WSL
- **Professionelle UI**: Truecolor-Ausgabe, Unicode-Icons, animierte Spinner
- **Sichere API-Key-Eingabe**: Versteckte Eingabe mit Format-Validierung (`nvapi-...`)
- **Idempotent**: Mehrfach ausführbar ohne Probleme
- **Robuste JSON-Verarbeitung**: Native JSON (PowerShell) / `jq` mit `sed`-Fallback (Bash)
- **Intelligente Shell-RC-Updates**: Idempotente export/set-Operationen
- **Dry-Run, Help, Version Flags**
- **Schöne Zusammenfassung** mit Neustart-Anweisungen
- **Vor konfigurierte Modelle**: MiniMax M2.7, Qwen3 Coder 480B, DeepSeek V3.2

## Schnellstart

### Linux / macOS / WSL (Bash/Zsh/Fish)

```bash
# Repository klonen
git clone https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator.git
cd NVIDIA-Opencode-Config-Creator

# Skript ausführbar machen
chmod +x setup-opencode.sh

# Setup ausführen
./setup-opencode.sh
```

### Windows (PowerShell 5.1+ / PowerShell 7+)

```powershell
# Repository klonen
git clone https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator.git
cd NVIDIA-Opencode-Config-Creator

# Setup ausführen
.\setup-opencode.ps1
```

### Windows (Command Prompt / CMD)

```cmd
git clone https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator.git
cd NVIDIA-Opencode-Config-Creator
setup-opencode.bat
```

Das Skript:
1. Erkennt Ihre Shell (bash/zsh/fish/powershell/pwsh/git bash/wsl/fish)
2. Erstellt `~/.config/opencode/opencode.json` (Linux/macOS) oder `%APPDATA%\opencode\opencode.json` (Windows)
3. Fragt NVIDIA API Key ab (sichere versteckte Eingabe)
4. Setzt `OPENCODE_CONFIG_FILE` in Ihrer Shell-RC/Profil-Datei
5. Zeigt Zusammenfassung mit Neustart-Anweisungen

## Voraussetzungen

- **OpenCode** installiert (`npm install -g opencode-ai` oder [Install-Skript](https://opencode.ai/docs/installation))
- **Node.js** 18+ (von OpenCode benötigt)
- **NVIDIA API Key** von [build.nvidia.com](https://build.nvidia.com)
- **jq** (optional, aber empfohlen für robuste JSON-Verarbeitung auf Linux/macOS)

### Shell-Unterstützung

| Plattform | Shell | Config-Datei | Status |
|-----------|-------|--------------|--------|
| Linux/macOS/WSL | Bash | `~/.bashrc` | ✅ Voll |
| Linux/macOS/WSL | Zsh | `~/.zshrc` | ✅ Voll |
| Linux/macOS/WSL | Fish | `~/.config/fish/config.fish` | ✅ Voll |
| Windows | PowerShell 5.1 | `Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` | ✅ Voll |
| Windows | pwsh 7+ | `Documents\PowerShell\Microsoft.PowerShell_profile.ps1` | ✅ Voll |
| Windows | Git Bash | `~/.bashrc` | ✅ Voll |
| Windows | WSL Bash | `~/.bashrc` | ✅ Voll |
| Windows | Fish | `%APPDATA%\fish\config.fish` | ✅ Voll |
| Windows | CMD | PowerShell Profil | ✅ Unterstützt |

## Skript-Optionen

```bash
./setup-opencode.sh [Optionen]

Optionen:
  -h, --help      Hilfe anzeigen
  --dry-run       Nur validieren, keine Änderungen
  --version       Version anzeigen
```

## Erstellte Dateien

### Config-Datei

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
        "apiKey": "nvapi-IHR_ECHTER_KEY"
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

### Shell RC / Profil Update

```bash
# Bash/Zsh (~/.bashrc, ~/.zshrc)
export OPENCODE_CONFIG_FILE="$HOME/.config/opencode/opencode.json"

# Fish (~/.config/fish/config.fish)
set -Ux OPENCODE_CONFIG_FILE "$HOME/.config/opencode/opencode.json"
```

```powershell
# PowerShell 5.1 (~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1)
$env:OPENCODE_CONFIG_FILE = "$env:APPDATA\opencode\opencode.json"

# PowerShell 7+ (~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1)
$env:OPENCODE_CONFIG_FILE = "$env:APPDATA\opencode\opencode.json"
```

## Nach der Installation

### Linux / macOS / WSL

```bash
# Shell neu starten oder RC-Datei laden
source ~/.bashrc        # bash
source ~/.zshrc         # zsh
source ~/.config/fish/config.fish  # fish

# OpenCode testen
opencode
```

### Windows (PowerShell)

```powershell
# Shell neu starten oder Profil laden
. $PROFILE

# OpenCode testen
opencode
```

### Windows (CMD)

```cmd
REM Terminal neu starten oder:
powershell -ExecutionPolicy Bypass -File $PROFILE

REM OpenCode testen
opencode
```

## Enthaltene Modelle

| Model ID | Anzeigename |
|----------|-------------|
| `minimaxai/minimax-m2.7` | MiniMax M2.7 |
| `qwen/qwen3-coder-480b-a35b-instruct` | Qwen3 Coder 480B |
| `deepseek-ai/deepseek-v3.2` | DeepSeek V3.2 |

Weitere Modelle: `~/.config/opencode/opencode.json` (Linux/macOS) oder `%APPDATA%\opencode\opencode.json` (Windows) bearbeiten und [NVIDIA Build](https://build.nvidia.com/explore/discover) nach Model-IDs durchsuchen.

## NVIDIA API Key erhalten

1. Gehen Sie zu [build.nvidia.com](https://build.nvidia.com)
2. Anmelden / Konto erstellen
3. "API Keys" oder "My API Keys" aufrufen
4. Neuen Key erstellen (beginnt mit `nvapi-`)
5. Kopieren und beim Setup-Skript einfügen

## Fehlerbehebung

### Ungültiges API-Key-Format
```
Error: Invalid API key format
```
- Key muss mit `nvapi-` beginnen
- Mindestens 20 Zeichen nach Präfix
- Neuen Key bei [build.nvidia.com](https://build.nvidia.com) erstellen

### Nicht unterstützte Shell
```
Error: Unsupported shell: fish
```
- Nur bash, zsh, fish unterstützt
- Für andere Shells: `OPENCODE_CONFIG_FILE` manuell in RC-Datei eintragen

### jq nicht gefunden
```
Warning: jq not found, using sed fallback
```
- jq installieren für robustere JSON-Verarbeitung:
  - Ubuntu/Debian: `sudo apt install jq`
  - macOS: `brew install jq`
  - Arch: `sudo pacman -S jq`

### Config wird nicht geladen
```bash
# Environment Variable prüfen
echo $OPENCODE_CONFIG_FILE

# Config-Datei existiert?
cat ~/.config/opencode/opencode.json

# OpenCode testen
opencode --version
```

### Permission Denied
```bash
chmod +x setup-opencode.sh
```

## Manuelle Konfiguration

Falls Sie manuell konfigurieren möchten:

### Linux / macOS / WSL

1. **Template kopieren**:
   ```bash
   mkdir -p ~/.config/opencode
   cp opencode-template.json ~/.config/opencode/opencode.json
   ```

2. **API Key eintragen** in `~/.config/opencode/opencode.json`

3. **Shell RC erweitern**:
   ```bash
   # bash/zsh
   echo 'export OPENCODE_CONFIG_FILE="$HOME/.config/opencode/opencode.json"' >> ~/.bashrc
   
   # fish
   echo 'set -Ux OPENCODE_CONFIG_FILE "$HOME/.config/opencode/opencode.json"' >> ~/.config/fish/config.fish
   ```

4. **Shell neu starten** und mit `opencode` testen

### Windows (PowerShell)

1. **Template kopieren**:
   ```powershell
   New-Item -ItemType Directory -Force -Path "$env:APPDATA\opencode"
   Copy-Item opencode-template.json "$env:APPDATA\opencode\opencode.json"
   ```

2. **API Key eintragen** in `%APPDATA%\opencode\opencode.json`

3. **PowerShell Profil erweitern**:
   ```powershell
   # PowerShell 5.1
   Add-Content $PROFILE.CurrentUserAllHosts "`$env:OPENCODE_CONFIG_FILE = `"$env:APPDATA\opencode\opencode.json`""
   
   # PowerShell 7+ (pwsh)
   Add-Content $PROFILE.CurrentUserAllHosts "`$env:OPENCODE_CONFIG_FILE = `"$env:APPDATA\opencode\opencode.json`""
   ```

4. **Shell neu starten** und mit `opencode` testen

## Dateistruktur

```
.
├── README.md                 # Diese Datei (Englisch)
├── README_TR.md              # Türkische Version
├── README_DE.md              # Deutsche Version
├── opencode-template.json    # OpenCode Config Template
├── setup-opencode.sh         # Haupt-Setup-Skript (Linux/macOS/WSL: bash/zsh/fish)
├── setup-opencode.ps1        # PowerShell Setup-Skript (Windows: PowerShell 5.1+, pwsh 7+)
└── setup-opencode.bat        # Batch/CMD Setup-Skript (Windows: cmd.exe)
```

## Template-Konfiguration

Die `opencode-template.json` nutzt den OpenAI-kompatiblen Provider mit vorkonfigurierten Modellen von NVIDIA Build:

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

## Links

- [OpenCode Dokumentation](https://opencode.ai/docs)
- [NVIDIA Build Modelle](https://build.nvidia.com/explore/discover)
- [OpenAI-kompatibler Provider](https://sdk.vercel.ai/providers/ai-sdk-providers/openai-compatible)
- [Nemotron Model Cards](https://huggingface.co/nvidia)

## Lizenz

MIT License - Freie Nutzung, Änderung und Verbreitung.

## Beitragen

1. Repository forken
2. Feature-Branch erstellen
3. Änderungen vornehmen
4. Pull Request erstellen

## Support

- **Bug Reports**: [GitHub Issues](https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator/issues)
- **OpenCode Hilfe**: [OpenCode Discord](https://discord.gg/opencode)
- **NVIDIA API Fragen**: [NVIDIA Developer Forums](https://forums.developer.nvidia.com/)