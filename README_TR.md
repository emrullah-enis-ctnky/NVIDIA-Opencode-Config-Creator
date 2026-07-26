# OpenCode NVIDIA API Entegrasyonu

[NVIDIA API modelleri](https://build.nvidia.com/explore/discover) (Nemotron 3 Ultra, Nemotron 4 Ultra, Nemotron 3 Ultra Instruct vb.) ile [OpenCode](https://opencode.ai) kullanımı için profesyonel kurulum scripti.

[🇬🇧 English](../README.md) | [🇩🇪 Deutsch](README_DE.md)

## Özellikler

- **Çoklu shell desteği**: Bash, Zsh, Fish
- **Profesyonel arayüz**: Truecolor çıktı, Unicode ikonlar, animasyonlu spinner
- **Güvenli API key girişi**: Gizli input + format doğrulama (`nvapi-...`)
- **İdempotent**: Birden fazla güvenli çalıştırma
- **Sağlam JSON işleme**: `jq` varsa kullanır, yoksa bash fallback
- **Shell entegrasyonu**: `.bashrc`, `.zshrc`, `config.fish` otomatik güncelleme
- **Dry-run modu**: Değişiklik öncesi önizleme
- **Önceden yapılandırılmış modeller**: Nemotron 3 Ultra, Nemotron 4 Ultra, Nemotron 3 Ultra Instruct

## Hızlı Başlangıç

```bash
# Depoyu klonla
git clone https://github.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator.git
cd NVIDIA-Opencode-Config-Creator

# Scripti çalıştırılabilir yap ve çalıştır
chmod +x setup-opencode.sh
./setup-opencode.sh
```

### Tek Satır Kurulum

```bash
curl -fsSL https://raw.githubusercontent.com/emrullah-enis-ctnky/NVIDIA-Opencode-Config-Creator/main/setup-opencode.sh | bash
```

### Önce Test Et (Dry Run)

```bash
./setup-opencode.sh --dry-run
```

## Ön Koşullar

| Gereksinim | Versiyon | Notlar |
|------------|----------|--------|
| Bash | 4.0+ | Çoğu Linux/macOS'ta varsayılan |
| curl | Herhangi | İndirme için (script için gerekli değil) |
| jq | 1.6+ | **Önerilir** - JSON işleme için |
| NVIDIA API Key | - | [build.nvidia.com](https://build.nvidia.com/explore/discover) adresinden alın |

### Shell Desteği

| Shell | Config Dosyası | Durum |
|-------|----------------|-------|
| Bash | `~/.bashrc` | ✅ Tam destek |
| Zsh | `~/.zshrc` | ✅ Tam destek |
| Fish | `~/.config/fish/config.fish` | ✅ Tam destek |

## NVIDIA API Key Alma

1. [NVIDIA Build](https://build.nvidia.com/explore/discover) adresine gidin
2. NVIDIA hesabıyla giriş yapın
3. **Explore Models** bölümüne gidin
4. Bir model seçin (örn. Nemotron 3 Ultra)
5. **Get API Key** butonuna tıklayın
6. Key'i kopyalayın (format: `nvapi-...`)

Script key formatını doğrular (`nvapi-` prefix + 20+ karakter).

## Script Ne Yapar?

1. **Shell tespiti** (bash/zsh/fish)
2. **Config dizini oluşturur**: `~/.config/opencode/`
3. **Şablonu kopyalar** `~/.config/opencode/opencode.json` olarak
4. **API key ister** (gizli input)
5. **Config'i günceller** API key ile
6. **Environment variable** set eder: `OPENCODE_CONFIG_FILE` shell RC dosyasında
7. **Özet gösterir** yeniden başlatma talimatlarıyla

## Kurulum Sonrası

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
├── README.md                 # Bu dosya
├── README_DE.md              # Almanca versiyon
├── opencode-template.json    # OpenCode config şablonu
└── setup-opencode.sh         # Ana kurulum scripti
```

## Şablon Konfigürasyonu

`opencode-template.json` OpenAI-uyumlu provider kullanır:

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