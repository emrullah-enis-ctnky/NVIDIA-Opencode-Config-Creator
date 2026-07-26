#!/usr/bin/env bash
# OpenCode NVIDIA API Global Setup Script
# Supports: bash, zsh, fish

set -euo pipefail

CONFIG_DIR="$HOME/.config/opencode"
CONFIG_FILE="$CONFIG_DIR/opencode.json"
TEMPLATE_FILE="$(dirname "$0")/opencode-template.json"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

detect_shell() {
    case "${SHELL##*/}" in
        bash) echo "bash" ;;
        zsh) echo "zsh" ;;
        fish) echo "fish" ;;
        *) echo "unknown" ;;
    esac
}

get_shell_rc() {
    local shell="$1"
    case "$shell" in
        bash) echo "$HOME/.bashrc" ;;
        zsh) echo "$HOME/.zshrc" ;;
        fish) echo "$HOME/.config/fish/config.fish" ;;
        *) echo "" ;;
    esac
}

set_env_var() {
    local shell="$1"
    local var_name="$2"
    local var_value="$3"
    local rc_file
    rc_file=$(get_shell_rc "$shell")

    case "$shell" in
        bash|zsh)
            if ! grep -q "export $var_name=" "$rc_file" 2>/dev/null; then
                echo "export $var_name=\"$var_value\"" >> "$rc_file"
                log_success "Added to $rc_file"
            else
                sed -i "s|export $var_name=.*|export $var_name=\"$var_value\"|" "$rc_file"
                log_success "Updated in $rc_file"
            fi
            ;;
        fish)
            mkdir -p "$(dirname "$rc_file")"
            if ! grep -q "set -Ux $var_name" "$rc_file" 2>/dev/null; then
                echo "set -Ux $var_name \"$var_value\"" >> "$rc_file"
                log_success "Added to $rc_file"
            else
                sed -i "s|set -Ux $var_name.*|set -Ux $var_name \"$var_value\"|" "$rc_file"
                log_success "Updated in $rc_file"
            fi
            ;;
        *)
            log_error "Unsupported shell: $shell"
            return 1
            ;;
    esac
}

prompt_api_key() {
    echo
    log_info "NVIDIA API Key girin (nvapi- ile başlar):"
    read -rp "API Key: " api_key
    if [[ ! "$api_key" =~ ^nvapi- ]]; then
        log_warn "Key nvapi- ile başlamıyor, yine de devam ediliyor..."
    fi
    echo "$api_key"
}

main() {
    local current_shell
    current_shell=$(detect_shell)

    log_info "Detected shell: $current_shell"

    if [[ "$current_shell" == "unknown" ]]; then
        log_error "Desteklenmeyen shell. Sadece bash, zsh, fish desteklenir."
        exit 1
    fi

    # 1. Create config directory
    mkdir -p "$CONFIG_DIR"
    log_success "Config dizini oluşturuldu: $CONFIG_DIR"

    # 2. Copy template if not exists
    if [[ ! -f "$CONFIG_FILE" ]]; then
        if [[ -f "$TEMPLATE_FILE" ]]; then
            cp "$TEMPLATE_FILE" "$CONFIG_FILE"
            log_success "Template kopyalandı: $CONFIG_FILE"
        else
            log_error "Template bulunamadı: $TEMPLATE_FILE"
            exit 1
        fi
    else
        log_info "Config zaten var: $CONFIG_FILE"
    fi

    # 3. Prompt for API key and update config
    local api_key
    api_key=$(prompt_api_key)

    # Update API key in config using sed with different delimiter
    sed -i "s|nvapi-SENIN_KEYIN_BURAYA|${api_key//\//\\/}|" "$CONFIG_FILE"
    log_success "API Key config'e yazıldı"

    # 4. Set environment variable
    log_info "OPENCODE_CONFIG_FILE ortam değişkeni ayarlanıyor..."
    set_env_var "$current_shell" "OPENCODE_CONFIG_FILE" "$CONFIG_FILE"

    echo
    log_success "Kurulum tamamlandı!"
    echo
    log_info "Yapılanlar:"
    echo "  1. Config: $CONFIG_FILE"
    echo "  2. ENV var: OPENCODE_CONFIG_FILE=$CONFIG_FILE"
    echo "  3. Shell RC güncellendi: $(get_shell_rc "$current_shell")"
    echo
    log_warn "Değişiklikler için shell'i yeniden başlatın veya:"
    case "$current_shell" in
        bash|zsh) echo "  source $(get_shell_rc "$current_shell")" ;;
        fish) echo "  source $(get_shell_rc "$current_shell")" ;;
    esac
    echo
    log_info "Test için: opencode"
}

main "$@"