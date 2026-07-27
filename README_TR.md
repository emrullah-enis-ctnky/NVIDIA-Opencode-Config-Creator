# OpenCode NVIDIA API Entegrasyonu

[NVIDIA API modelleri](https://build.nvidia.com/explore/discover) (Nemotron 3 Ultra, Nemotron 4 Ultra, Nemotron 3 Ultra Instruct, MiniMax, Qwen, DeepSeek vb.) ile [OpenCode](https://opencode.ai) kullanımı için profesyonel kurulum scriptleri.

[🇬🇧 English](../README.md) | [🇩🇪 Deutsch](README_DE.md)

## Özellikler

- **Çapraz platform**: Linux, macOS, Windows (WSL, PowerShell, CMD)
- **Çoklu shell desteği**: Bash, Zsh, Fish, PowerShell 5.1+, pwsh 7+, Git Bash, WSL
- **Profesyonel arayüz**: Truecolor çıktı, Unicode ikonlar, animasyonlu spinner
- **Güvenli API key girişi**: Gizli input + format doğrulama (`nvapi-...`)
- **İdempotent**: Birden fazla güvenli çalıştırma
- **Sağlam JSON işleme**: Native JSON (PowerShell) / `jq` + `sed` fallback (Bash)
- **Shell entegrasyonu**: `.bashrc`, `.zshrc`, `config.fish`, PowerShell profile otomatik güncelleme
- **Dry-run modu**: Değişiklik öncesi önizleme
- **Önceden yapılandırılmış modeller**: MiniMax M2.7, Qwen3 Coder 480B, DeepSeek V3.2

## Hızlı Başlangıç

### Linux / macOS / WSL (Bash/Zsh/Fish)

```bash
# Depoyu klonla
git clone https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator.git
cd NVIDIA-Opencode-Config-Creator

# Scripti çalıştırılabilir yap ve çalıştır
chmod +x setup-opencode.sh
./setup-opencode.sh
```

### Windows (PowerShell 5.1+ / pwsh 7+)

```powershell
# Depoyu klonla
git clone https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator.git
cd NVIDIA-Opencode-Config-Creator

# PowerShell scriptini çalıştır
.\setup-opencode.ps1
```

### Windows (CMD / Batch)

```cmd
git clone https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator.git
cd NVIDIA-Opencode-Config-Creator
setup-opencode.bat
```

### Tek Satır Kurulum (Linux/macOS/WSL)

```bash
curl -fsSL https://raw.githubusercontent.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator/main/setup-opencode.sh | bash
```

### Önce Test Et (Dry Run)

```bash
# Linux/macOS/WSL
./setup-opencode.sh --dry-run

# Windows PowerShell
.\setup-opencode.ps1 -DryRun

# Windows CMD
setup-opencode.bat --dry-run
```

## Ön Koşullar

| Gereksinim | Versiyon | Notlar |
|------------|----------|--------|
| Bash | 4.0+ | Linux/macOS/WSL için |
| PowerShell | 5.1+ | Windows için (varsayılan) |
| pwsh | 7+ | Windows için (önerilen - truecolor, Unicode) |
| curl | Herhangi | İndirme için (script için gerekli değil) |
| jq | 1.6+ | **Önerilir** - Linux/macOS'ta JSON işleme için |
| NVIDIA API Key | - | [build.nvidia.com](https://build.nvidia.com/explore/discover) adresinden alın |

### Shell Desteği

| Platform | Shell | Config Dosyası | Durum |
|----------|-------|----------------|-------|
| Linux/macOS/WSL | Bash | `~/.bashrc` | ✅ Tam destek |
| Linux/macOS/WSL | Zsh | `~/.zshrc` | ✅ Tam destek |
| Linux/macOS/WSL | Fish | `~/.config/fish/config.fish` | ✅ Tam destek |
| Windows | PowerShell 5.1 | `Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` | ✅ Tam destek |
| Windows | pwsh 7+ | `Documents\PowerShell\Microsoft.PowerShell_profile.ps1` | ✅ Tam destek |
| Windows | Git Bash | `~/.bashrc` | ✅ Tam destek |
| Windows | WSL Bash | `~/.bashrc` | ✅ Tam destek |
| Windows | Fish | `%APPDATA%\fish\config.fish` | ✅ Tam destek |
| Windows | CMD | PowerShell profil üzerinden | ✅ Desteklenir |

## NVIDIA API Key Alma

1. [NVIDIA Build](https://build.nvidia.com/explore/discover) adresine gidin
2. NVIDIA hesabıyla giriş yapın
3. **Explore Models** bölümüne gidin
4. Bir model seçin (örn. Nemotron 3 Ultra)
5. **Get API Key** butonuna tıklayın
6. Key'i kopyalayın (format: `nvapi-...`)

Script key formatını doğrular (`nvapi-` prefix + 20+ karakter).

## Script Ne Yapar?

1. **Shell tespiti** (bash/zsh/fish/powershell/pwsh/git bash/wsl/fish)
2. **Config dizini oluşturur**:
   - Linux/macOS/WSL: `~/.config/opencode/`
   - Windows: `%APPDATA%\opencode\`
3. **Şablonu kopyalar** `opencode.json` olarak
4. **API key ister** (gizli input - PowerShell'de masked, Bash'de hidden)
5. **Config'i günceller** API key ile
6. **Environment variable** set eder: `OPENCODE_CONFIG_FILE` shell RC/profile dosyasında
7. **Özet gösterir** yeniden başlatma talimatlarıyla

## Kurulum Sonrası

### Linux / macOS / WSL

Shell'i yeniden başlatın veya source edin:

```bash
# Bash/Zsh
source ~/.bashrc    # veya ~/.zshrc

# Fish
source ~/.config/fish/config.fish
```

Sonra OpenCode'u başlatın:

```bash
opencode
```

### Windows (PowerShell)

```powershell
# Profil'i yeniden yükle
. $PROFILE

# OpenCode test et
opencode
```

### Windows (CMD)

```cmd
REM Terminali yeniden başlatın veya:
powershell -ExecutionPolicy Bypass -File $PROFILE

REM OpenCode test et
opencode
```

## Manuel Konfigürasyon (Alternatif)

Script kullanmak istemezseniz:

### 1. Config Dizini Oluşturun

```bash
mkdir -p ~/.config/opencode
```

### 2. Şablonu Kopyalayın

```bash
cp opencode-template.json ~/.config/opencode/opencode.json
```

### 3. API Key'i Düzenleyin

```bash
# sed ile (placeholder'ı değiştirin)
sed -i 's|nvapi-YOUR_API_KEY_HERE|nvapi-SIZIN_KEYINIZ|' ~/.config/opencode/opencode.json

# veya editor ile
nano ~/.config/opencode/opencode.json
```

### 4. Environment Variable Ayarlayın

**Bash/Zsh** (`~/.bashrc` veya `~/.zshrc`):
```bash
export OPENCODE_CONFIG_FILE="$HOME/.config/opencode/opencode.json"
```

**Fish** (`~/.config/fish/config.fish`):
```fish
set -Ux OPENCODE_CONFIG_FILE "$HOME/.config/opencode/opencode.json"
```

### 5. Shell'i Yeniden Yükleyin

```bash
source ~/.bashrc  # veya ~/.zshrc / ~/.config/fish/config.fish
```

## OpenCode Kullanımı

Yapılandırma sonrası OpenCode otomatik olarak NVIDIA provider'ı kullanır:

```bash
# OpenCode başlat
opencode

# Modelleri listele
opencode models list

# Belirli model kullan
opencode --model nvidia/nemotron-3-ultra
```

## Model Özelleştirme

`opencode-template.json` dosyasını script çalıştırmadan önce, veya `~/.config/opencode/opencode.json` dosyasını sonrasında düzenleyin:

```json
{
  "provider": {
    "nvidia": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "NVIDIA",
      "options": {
        "baseURL": "https://integrate.api.nvidia.com/v1",
        "apiKey": "nvapi-SIZIN_KEYINIZ"
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

[NVIDIA Build](https://build.nvidia.com/explore/discover) adresinde bulunan herhangi bir modeli, model ID formatında ekleyebilirsiniz.

## Script Seçenekleri

```bash
./setup-opencode.sh [SEÇENEKLER]

Seçenekler:
  -h, --help      Yardım mesajını göster
  --dry-run       Değişiklik yapmadan doğrula
  --version       Versiyon göster
```

## Sorun Giderme

### API Key Geçersiz
```
Error: Invalid API key format
```
- Key `nvapi-` ile başlamalı
- Prefix sonrası 20+ karakter olmalı
- Yeni key için [NVIDIA Build](https://build.nvidia.com)

### Desteklenmeyen Shell
```
Error: Unsupported shell: fish
```
- Sadece bash, zsh, fish desteklenir
- Diğer shell'ler için manuel konfigürasyon kullanın

### jq Bulunamadı
```
Warning: jq not found, using sed fallback
```
- jq kurun daha sağlam JSON işleme için:
  - Ubuntu/Debian: `sudo apt install jq`
  - macOS: `brew install jq`
  - Arch: `sudo pacman -S jq`

### Config Yüklenmiyor
```bash
# Environment variable kontrol
echo $OPENCODE_CONFIG_FILE

# Config dosyası var mı?
cat ~/.config/opencode/opencode.json

# OpenCode test
opencode --version
```

### Permission Denied
```bash
chmod +x setup-opencode.sh
```

## Dosya Yapısı

```
.
├── README.md                 # English version
├── README_TR.md              # Bu dosya (Türkçe)
├── README_DE.md              # Almanca versiyon
├── opencode-template.json    # OpenCode config şablonu
├── setup-opencode.sh         # Ana kurulum scripti (Linux/macOS/WSL: bash/zsh/fish)
├── setup-opencode.ps1        # PowerShell kurulum scripti (Windows: PowerShell 5.1+, pwsh 7+)
└── setup-opencode.bat        # Batch/CMD kurulum scripti (Windows: cmd.exe)
```

## Şablon Konfigürasyonu

`opencode-template.json` OpenAI-uyumlu provider kullanır, NVIDIA Build'da mevcut modellerle önceden yapılandırılmış:

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

Script çalıştırmadan önce `opencode-template.json` dosyasını, veya sonrasında `~/.config/opencode/opencode.json` (Linux/macOS) / `%APPDATA%\opencode\opencode.json` (Windows) dosyasını düzenleyin:

[NVIDIA Build](https://build.nvidia.com/explore/discover) adresinde bulunan herhangi bir modeli, model ID formatında ekleyebilirsiniz.

## Gereksinimler

- **OpenCode** kurulu (`npm install -g opencode-ai` veya [kurulum scripti](https://opencode.ai/docs/installation))
- **Node.js** 18+ (OpenCode tarafından gereklidir)
- **NVIDIA API Key** [build.nvidia.com](https://build.nvidia.com) adresinden

## Bağlantılar

- [OpenCode Dokümantasyonu](https://opencode.ai/docs)
- [NVIDIA Build Modelleri](https://build.nvidia.com/explore/discover)
- [OpenAI-Compatible Provider](https://sdk.vercel.ai/providers/ai-sdk-providers/openai-compatible)
- [Nemotron Model Kartları](https://huggingface.co/nvidia)

## Lisans

MIT License - Serbest kullanım, değiştirme ve dağıtım.

## Katkıda Bulunma

1. Repository'yi fork edin
2. Feature branch oluşturun
3. Değişikliklerinizi yapın
4. Pull Request gönderin

## Destek

- **Bug raporu**: [GitHub Issues](https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator/issues)
- **OpenCode yardım**: [OpenCode Discord](https://discord.gg/opencode)
- **NVIDIA API soruları**: [NVIDIA Developer Forums](https://forums.developer.nvidia.com/)