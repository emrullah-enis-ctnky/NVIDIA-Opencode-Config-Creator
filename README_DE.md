[🇬🇧 English](README.md) | [🇹🇷 Türkçe](README_TR.md) | [🇩🇪 Deutsch](README_DE.md)

# OpenCode NVIDIA API Integration

Professionelles Setup-Skript zur Konfiguration von [OpenCode](https://opencode.ai) mit NVIDIA API-Modellen (Nemotron 3 Ultra, Nemotron 4 Ultra, Nemotron 3 Ultra Instruct, etc.) über den OpenAI-kompatiblen API-Endpunkt.

## Funktionen

- **Cross-Shell Support**: Bash, Zsh, Fish
- **Professionelle UI**: Truecolor-Ausgabe, Unicode-Icons, animierte Spinner
- **Sichere API-Key-Eingabe**: Versteckte Eingabe mit Format-Validierung (`nvapi-...`)
- **Idempotent**: Mehrfach ausführbar ohne Probleme
- **Robuste JSON-Verarbeitung**: Nutzt `jq` mit `sed`-Fallback
- **Intelligente Shell-RC-Updates**: Idempotente export/set-Operationen
- **Dry-Run, Help, Version Flags**
- **Schöne Zusammenfassung** mit Neustart-Anweisungen

## Schnellstart

```bash
# Repository klonen
git clone https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator.git
cd NVIDIA-Opencode-Config-Creator

# Skript ausführbar machen
chmod +x setup-opencode.sh

# Setup ausführen
./setup-opencode.sh
```

Das Skript:
1. Erkennt Ihre Shell (bash/zsh/fish)
2. Erstellt `~/.config/opencode/opencode.json` aus Template
3. Fragt NVIDIA API Key ab (sichere versteckte Eingabe)
4. Setzt `OPENCODE_CONFIG_FILE` in Ihrer Shell-RC-Datei
5. Zeigt Zusammenfassung mit Neustart-Anweisungen

## Voraussetzungen

- **OpenCode** installiert (`npm install -g opencode-ai` oder [Install-Skript](https://opencode.ai/docs/installation))
- **Node.js** 18+ (von OpenCode benötigt)
- **NVIDIA API Key** von [build.nvidia.com](https://build.nvidia.com)
- **jq** (optional, aber empfohlen für robuste JSON-Verarbeitung)

## Skript-Optionen

```bash
./setup-opencode.sh [Optionen]

Optionen:
  -h, --help      Hilfe anzeigen
  --dry-run       Nur validieren, keine Änderungen
  --version       Version anzeigen
```

## Erstellte Dateien

### Config: `~/.config/opencode/opencode.json`
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
        "nvidia/nemotron-3-ultra": { "name": "Nemotron 3 Ultra" },
        "nvidia/nemotron-4-ultra": { "name": "Nemotron 4 Ultra" },
        "nvidia/nemotron-3-ultra-instruct": { "name": "Nemotron 3 Ultra Instruct" }
      }
    }
  }
}
```

### Shell RC Update
```bash
# Bash/Zsh (~/.bashrc, ~/.zshrc)
export OPENCODE_CONFIG_FILE="$HOME/.config/opencode/opencode.json"

# Fish (~/.config/fish/config.fish)
set -Ux OPENCODE_CONFIG_FILE "$HOME/.config/opencode/opencode.json"
```

## Nach der Installation

```bash
# Shell neu starten oder RC-Datei laden
source ~/.bashrc        # bash
source ~/.zshrc         # zsh
source ~/.config/fish/config.fish  # fish

# OpenCode testen
opencode
```

## Enthaltene Modelle

| Model ID | Anzeigename |
|----------|-------------|
| `nvidia/nemotron-3-ultra` | Nemotron 3 Ultra |
| `nvidia/nemotron-4-ultra` | Nemotron 4 Ultra |
| `nvidia/nemotron-3-ultra-instruct` | Nemotron 3 Ultra Instruct |

Weitere Modelle: `~/.config/opencode/opencode.json` bearbeiten und [NVIDIA Build](https://build.nvidia.com/explore/discover) nach Model-IDs durchsuchen.

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

## Dateistruktur

```
.
├── README.md                 # Diese Datei (Englisch)
├── README_TR.md              # Türkische Version
├── README_DE.md              # Deutsche Version
├── opencode-template.json    # OpenCode Config Template
└── setup-opencode.sh         # Haupt-Setup-Skript
```

## Template-Konfiguration

Die `opencode-template.json` nutzt den OpenAI-kompatiblen Provider:

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