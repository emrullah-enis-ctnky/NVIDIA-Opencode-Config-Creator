#!/usr/bin/env bash
# OpenCode NVIDIA API Setup - Professional Edition
# Supports: bash, zsh, fish

set -euo pipefail

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# CONFIGURATION
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONFIG_DIR="${HOME}/.config/opencode"
CONFIG_FILE="${CONFIG_DIR}/opencode.json"
TEMPLATE_FILE="$(dirname "${BASH_SOURCE[0]}")/opencode-template.json"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
VERSION="1.0.0"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# COLORS & STYLING (Truecolor support with fallback)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [[ -t 1 ]] && command -v tput >/dev/null 2>&1 && [[ $(tput colors 2>/dev/null || echo 0) -ge 8 ]]; then
    # Modern truecolor palette
    C_RESET=$'\033[0m'
    C_BOLD=$'\033[1m'
    C_DIM=$'\033[2m'
    C_ITALIC=$'\033[3m'
    C_UNDERLINE=$'\033[4m'
    
    # Primary brand colors (NVIDIA green theme)
    C_PRIMARY=$'\033[38;2;118;255;3m'    # #76FF03 - NVIDIA green
    C_SECONDARY=$'\033[38;2;0;200;150m'   # Teal accent
    C_ACCENT=$'\033[38;2;255;140;0m'      # Orange accent
    
    # Semantic colors
    C_SUCCESS=$'\033[38;2;76;217;100m'    # Green
    C_WARNING=$'\033[38;2;255;193;7m'     # Amber
    C_ERROR=$'\033[38;2;244;67;54m'       # Red
    C_INFO=$'\033[38;2;33;150;243m'       # Blue
    C_MUTED=$'\033[38;2;158;158;158m'     # Grey
    
    # Backgrounds
    BG_PRIMARY=$'\033[48;2;118;255;3m'
    BG_DARK=$'\033[48;2;30;30;40m'
    BG_CARD=$'\033[48;2;40;44;52m'
else
    # Fallback for basic terminals
    C_RESET=$'\033[0m'; C_BOLD=$'\033[1m'; C_DIM=$'\033[2m'
    C_PRIMARY=$'\033[32m'; C_SECONDARY=$'\033[36m'; C_ACCENT=$'\033[33m'
    C_SUCCESS=$'\033[32m'; C_WARNING=$'\033[33m'; C_ERROR=$'\033[31m'
    C_INFO=$'\033[34m'; C_MUTED=$'\033[90m'
    BG_PRIMARY=''; BG_DARK=''; BG_CARD=''
fi

# Unicode symbols (with ASCII fallback)
if [[ "${LANG:-}" =~ UTF-8 ]] && [[ "${TERM:-}" != "linux" ]]; then
    ICON_CHECK="✓"
    ICON_CROSS="✗"
    ICON_ARROW="→"
    ICON_STAR="★"
    ICON_GEAR="⚙"
    ICON_KEY="🔑"
    ICON_ROCKET="🚀"
    ICON_SPARKLES="✨"
    ICON_FOLDER="📁"
    ICON_FILE="📄"
    ICON_SHELL="🐚"
    ICON_WARNING="⚠"
    ICON_INFO="ℹ"
    BOX_TL="┌"; BOX_TR="┐"; BOX_BL="└"; BOX_BR="┘"
    BOX_H="─"; BOX_V="│"; BOX_L="├"; BOX_R="┤"
else
    ICON_CHECK="[OK]"; ICON_CROSS="[X]"; ICON_ARROW="->"
    ICON_STAR="*"; ICON_GEAR="[CFG]"; ICON_KEY="[KEY]"
    ICON_ROCKET="[>>]"; ICON_SPARKLES="*"; ICON_FOLDER="[DIR]"
    ICON_FILE="[FILE]"; ICON_SHELL="[SH]"; ICON_WARNING="[!]"
    ICON_INFO="[i]"; BOX_TL="+"; BOX_TR="+"; BOX_BL="+"; BOX_BR="+"
    BOX_H="-"; BOX_V="|"; BOX_L="+"; BOX_R="+"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# UTILITY FUNCTIONS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

print_header() {
    local title="$1"
    local subtitle="${2:-}"
    local width=64
    local title_len=${#title}
    local pad=$(( (width - title_len) / 2 ))
    
    echo
    printf "${C_PRIMARY}${BOX_TL}%${width}s${BOX_TR}${C_RESET}\n" | sed "s/ /${BOX_H}/g"
    printf "${C_PRIMARY}${BOX_V}${C_RESET}%*s${C_BOLD}%s${C_RESET}%*s${C_PRIMARY}${BOX_V}${C_RESET}\n" \
        $pad "" "$title" $((width - pad - title_len)) ""
    if [[ -n "$subtitle" ]]; then
        local sub_len=${#subtitle}
        local sub_pad=$(( (width - sub_len) / 2 ))
        printf "${C_PRIMARY}${BOX_V}${C_RESET}%*s${C_DIM}%s${C_RESET}%*s${C_PRIMARY}${BOX_V}${C_RESET}\n" \
            $sub_pad "" "$subtitle" $((width - sub_pad - sub_len)) ""
    fi
    printf "${C_PRIMARY}${BOX_BL}%${width}s${BOX_BR}${C_RESET}\n" | sed "s/ /${BOX_H}/g"
    echo
}

print_step() {
    local num="$1"
    local title="$2"
    local desc="${3:-}"
    printf "  ${C_PRIMARY}${BOX_V}${C_RESET} ${C_BOLD}%s${C_RESET} ${C_DIM}%s${C_RESET}\n" "Step $num" "$title"
    [[ -n "$desc" ]] && printf "  ${C_PRIMARY}${BOX_V}${C_RESET}   ${C_MUTED}%s${C_RESET}\n" "$desc"
}

print_status() {
    local status="$1"
    local msg="$2"
    case "$status" in
        ok)     printf "  ${C_SUCCESS}${ICON_CHECK}${C_RESET} %s\n" "$msg" ;;
        warn)   printf "  ${C_WARNING}${ICON_WARNING}${C_RESET} %s\n" "$msg" ;;
        error)  printf "  ${C_ERROR}${ICON_CROSS}${C_RESET} %s\n" "$msg" ;;
        info)   printf "  ${C_INFO}${ICON_INFO}${C_RESET} %s\n" "$msg" ;;
        step)   printf "  ${C_ACCENT}${ICON_ARROW}${C_RESET} %s\n" "$msg" ;;
    esac
}

print_kv() {
    local key="$1"
    local val="$2"
    printf "  ${C_DIM}%s${C_RESET} ${C_BOLD}%s${C_RESET}\n" "$key" "$val"
}

spinner() {
    local pid=$1
    local msg="${2:-Working...}"
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    tput civis 2>/dev/null || true
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r  ${C_PRIMARY}%s${C_RESET} %s" "${spin:i++%${#spin}:1}" "$msg"
        sleep 0.08
    done
    tput cnorm 2>/dev/null || true
    wait "$pid" 2>/dev/null
    local exit_code=$?
    printf "\r  ${C_SUCCESS}${ICON_CHECK}${C_RESET} %s\n" "$msg"
    return $exit_code
}

run_with_spinner() {
    local msg="$1"; shift
    ("$@") &
    spinner $! "$msg"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# CORE LOGIC
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

detect_shell() {
    local shell_name="${SHELL##*/}"
    case "$shell_name" in
        bash|zsh|fish) echo "$shell_name" ;;
        *) echo "unknown" ;;
    esac
}

get_shell_rc() {
    case "$1" in
        bash) echo "${HOME}/.bashrc" ;;
        zsh)  echo "${HOME}/.zshrc" ;;
        fish) echo "${HOME}/.config/fish/config.fish" ;;
        *)    echo "" ;;
    esac
}

shell_name_pretty() {
    case "$1" in
        bash) echo "Bash" ;;
        zsh)  echo "Zsh" ;;
        fish) echo "Fish" ;;
        *)    echo "Unknown" ;;
    esac
}

validate_api_key() {
    local key="$1"
    [[ "$key" =~ ^nvapi-[A-Za-z0-9_-]{20,}$ ]]
}

prompt_api_key() {
    local key=""
    local attempts=0
    local max_attempts=3
    
    while [[ -z "$key" ]]; do
        if [[ $attempts -gt 0 ]]; then
            print_status warn "Invalid format. NVIDIA keys start with 'nvapi-' followed by 20+ chars." >&2
        fi
        
        echo >&2
        printf "  ${C_PRIMARY}${ICON_KEY}${C_RESET} ${C_BOLD}Enter your NVIDIA API Key:${C_RESET}\n" >&2
        printf "  ${C_DIM}(Get one at: https://build.nvidia.com/explore/discover)${C_RESET}\n" >&2
        printf "  ${C_PRIMARY}${ICON_ARROW}${C_RESET} " >&2
        
        # Hide input for security
        if [[ -t 0 ]]; then
            read -rs key
            echo >&2
        else
            read -r key
        fi
        
        key="${key//[$'\t\r\n ']/}" # trim whitespace
        
        if [[ -z "$key" ]]; then
            print_status error "API key cannot be empty." >&2
            ((attempts++))
            continue
        fi
        
        if ! validate_api_key "$key"; then
            ((attempts++))
            if [[ $attempts -ge $max_attempts ]]; then
                printf "\n" >&2
                print_status warn "Key format unusual. Continue anyway? [y/N] " >&2
                read -r confirm
                [[ "$confirm" =~ ^[Yy]$ ]] && break
                key=""
                attempts=0
            fi
        else
            break
        fi
    done
    
    echo "$key"
}

update_config_file() {
    local api_key="$1"
    
    # Create config directory
    mkdir -p "$CONFIG_DIR"
    
    # Copy template if needed
    if [[ ! -f "$CONFIG_FILE" ]]; then
        if [[ ! -f "$TEMPLATE_FILE" ]]; then
            print_status error "Template not found: $TEMPLATE_FILE"
            return 1
        fi
        cp "$TEMPLATE_FILE" "$CONFIG_FILE"
    fi
    
    # Use jq for robust JSON manipulation (standard on most systems)
    if command -v jq >/dev/null 2>&1; then
        jq --arg key "$api_key" '.provider.nvidia.options.apiKey = $key' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    else
        # Pure bash fallback using sed with proper escaping
        # Escape special chars for sed replacement
        local escaped_key
        escaped_key=$(printf '%s\n' "$api_key" | sed 's/[[\.*^$()+?{|\\]/\\&/g')
        sed -i "s|nvapi-YOUR_API_KEY_HERE|$escaped_key|" "$CONFIG_FILE"
    fi
}

set_env_variable() {
    local shell="$1"
    local var_name="$2"
    local var_value="$3"
    local rc_file
    rc_file=$(get_shell_rc "$shell")
    
    [[ -z "$rc_file" ]] && return 1
    
    mkdir -p "$(dirname "$rc_file")"
    
    case "$shell" in
        bash|zsh)
            # Check if already exists
            if grep -qE "^export ${var_name}=" "$rc_file" 2>/dev/null; then
                sed -i "s|^export ${var_name}=.*|export ${var_name}=\"${var_value}\"|" "$rc_file"
                print_status ok "Updated ${var_name} in $(basename "$rc_file")"
            else
                echo "export ${var_name}=\"${var_value}\"" >> "$rc_file"
                print_status ok "Added ${var_name} to $(basename "$rc_file")"
            fi
            ;;
        fish)
            if grep -qE "^set -Ux ${var_name} " "$rc_file" 2>/dev/null; then
                sed -i "s|^set -Ux ${var_name} .*|set -Ux ${var_name} \"${var_value}\"|" "$rc_file"
                print_status ok "Updated ${var_name} in config.fish"
            else
                echo "set -Ux ${var_name} \"${var_value}\"" >> "$rc_file"
                print_status ok "Added ${var_name} to config.fish"
            fi
            ;;
    esac
}

print_summary() {
    local shell="$1"
    local rc_file
    rc_file=$(get_shell_rc "$shell")
    
    echo
    print_header "SETUP COMPLETE" "${ICON_SPARKLES} Ready to use OpenCode with NVIDIA"
    
    print_step 1 "Configuration" "OpenCode config file created"
    print_kv "Location:" "$CONFIG_FILE"
    
    print_step 2 "Environment" "OPENCODE_CONFIG_FILE exported"
    print_kv "Variable:" "OPENCODE_CONFIG_FILE=$CONFIG_FILE"
    print_kv "Shell RC:" "$rc_file"
    
    print_step 3 "Models Available" "Pre-configured NVIDIA models"
    print_kv "MiniMax M2.7" "minimaxai/minimax-m2.7"
    print_kv "Qwen3 Coder 480B" "qwen/qwen3-coder-480b-a35b-instruct"
    print_kv "DeepSeek V3.2" "deepseek-ai/deepseek-v3.2"
    
    echo
    print_status warn "Restart your shell or run:"
    case "$shell" in
        bash|zsh) printf "  ${C_INFO}source %s${C_RESET}\n" "$rc_file" ;;
        fish)     printf "  ${C_INFO}source %s${C_RESET}\n" "$rc_file" ;;
    esac
    
    echo
    print_status info "Test with: ${C_BOLD}opencode${C_RESET}"
    echo
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# MAIN
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

main() {
    # Parse arguments
    local show_help=false
    local dry_run=false
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help) show_help=true ;;
            --dry-run) dry_run=true ;;
            --version) echo "OpenCode NVIDIA Setup v$VERSION"; exit 0 ;;
            *) print_status error "Unknown option: $1"; show_help=true ;;
        esac
        shift
    done
    
    if [[ "$show_help" == true ]]; then
        print_header "OPENCODE NVIDIA SETUP" "v$VERSION - Configure NVIDIA API for OpenCode"
        echo "Usage: $SCRIPT_NAME [options]"
        echo
        echo "Options:"
        print_kv "-h, --help"     "Show this help message"
        print_kv "--dry-run"      "Validate without making changes"
        print_kv "--version"      "Show version"
        echo
        echo "This script will:"
        print_step 1 "Detect your shell" "(bash, zsh, or fish)"
        print_step 2 "Create config" "~/.config/opencode/opencode.json"
        print_step 3 "Prompt for API key" "Secure input (hidden)"
        print_step 4 "Set environment variable" "OPENCODE_CONFIG_FILE in shell RC"
        echo
        exit 0
    fi
    
    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    # EXECUTION
    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    print_header "OPENCODE NVIDIA SETUP" "v$VERSION - Professional Configuration"
    
    # Step 1: Detect shell
    print_step 1 "Shell Detection" "Identifying your shell environment"
    local current_shell
    current_shell=$(detect_shell)
    
    if [[ "$current_shell" == "unknown" ]]; then
        print_status error "Unsupported shell: ${SHELL##*/}"
        print_status info "Supported: bash, zsh, fish"
        exit 1
    fi
    
    print_status ok "Detected: $(shell_name_pretty "$current_shell") (${SHELL})"
    
    if [[ "$dry_run" == true ]]; then
        print_status info "Dry run mode - no changes will be made"
        exit 0
    fi
    
    # Step 2: Create config directory
    print_step 2 "Config Directory" "Creating ~/.config/opencode"
    run_with_spinner "Creating config directory..." mkdir -p "$CONFIG_DIR"
    print_status ok "Directory ready: $CONFIG_DIR"
    
    # Step 3: Get API key
    print_step 3 "API Key" "Secure input for NVIDIA API key"
    local api_key
    api_key=$(prompt_api_key)
    
    # Step 4: Update config
    print_step 4 "Configuration" "Writing API key to config file"
    run_with_spinner "Updating config file..." update_config_file "$api_key"
    print_status ok "Config written: $CONFIG_FILE"
    
    # Step 5: Set environment variable
    print_step 5 "Environment" "Setting OPENCODE_CONFIG_FILE in shell RC"
    run_with_spinner "Updating shell configuration..." set_env_variable "$current_shell" "OPENCODE_CONFIG_FILE" "$CONFIG_FILE"
    
    # Summary
    print_summary "$current_shell"
}

# Trap errors
trap 'print_status error "Setup failed at line $LINENO"; exit 1' ERR

# Run main
main "$@"