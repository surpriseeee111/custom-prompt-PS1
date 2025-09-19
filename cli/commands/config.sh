#!/usr/bin/env bash
# Config command for prompt-cli

# Source required functions
PROMPT_DIR="${HOME}/.custom-prompt"
CONFIG_FILE="${HOME}/.config/custom-prompt/config"

if [[ -f "$PROMPT_DIR/loader.sh" ]] && [[ -z "$CUSTOM_PROMPT_LOADED" ]]; then
    CUSTOM_PROMPT_LOADED=1  # Prevent message
    source "$PROMPT_DIR/loader.sh" 2>/dev/null
fi

# Use plain colors for output
RED="${RED_PLAIN:-\033[0;31m}"
GREEN="${GREEN_PLAIN:-\033[0;32m}"
YELLOW="${YELLOW_PLAIN:-\033[1;33m}"
BLUE="${BLUE_PLAIN:-\033[0;34m}"
NC="${NC:-\033[0m}"

# Print functions
print_info() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Show config help
function show_config_help() {
    cat << EOF
Config Command - Manage prompt configuration

Usage: prompt-cli config [subcommand] [options]

Subcommands:
  list              List all configuration settings
  get <key>         Get a configuration value
  set <key> <val>   Set a configuration value
  reset             Reset to default configuration
  edit              Open config file in editor

Configuration Keys:
  SHOW_GIT          Show git information (true/false)
  SHOW_USER         Show username (true/false)
  SHOW_HOST         Show hostname (true/false)
  SHOW_PATH         Show current path (true/false)
  SHOW_TIME         Show time in prompt (true/false)
  SHOW_EXIT_CODE    Show exit code on error (true/false)
  PATH_STYLE        Path display style (full/short/basename)
  THEME             Color theme (default/ocean/forest/minimal/dracula)
  GIT_SHOW_STATUS   Show git status symbols (true/false)

Examples:
  prompt-cli config list
  prompt-cli config get SHOW_TIME
  prompt-cli config set SHOW_TIME true
  prompt-cli config set PATH_STYLE basename
  prompt-cli config reset
EOF
}

# List all config
function config_list() {
    echo "Current Configuration:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if [[ -f "$CONFIG_FILE" ]]; then
        # Display with formatting
        while IFS='=' read -r key value; do
            # Skip comments and empty lines
            [[ "$key" =~ ^#.*$ ]] && continue
            [[ -z "$key" ]] && continue

            # Clean whitespace
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs)

            # Format output based on value
            case "$value" in
                true)
                    printf "  %-20s : ${GREEN}%s${NC}\n" "$key" "$value"
                    ;;
                false)
                    printf "  %-20s : ${YELLOW}%s${NC}\n" "$key" "$value"
                    ;;
                *)
                    printf "  %-20s : ${BLUE}%s${NC}\n" "$key" "$value"
                    ;;
            esac
        done < "$CONFIG_FILE"
    else
        print_warning "Config file not found at: $CONFIG_FILE"
        echo "Run 'prompt-cli install' first"
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Get config value
function config_get() {
    local key=$1

    if [[ -z "$key" ]]; then
        print_error "No key specified"
        echo "Usage: prompt-cli config get <key>"
        return 1
    fi

    if type get_config &>/dev/null; then
        local value=$(get_config "$key")
        if [[ -n "$value" ]]; then
            echo "$key = $value"
        else
            print_error "Key not found: $key"
            return 1
        fi
    else
        # Fallback to reading file directly
        if [[ -f "$CONFIG_FILE" ]]; then
            local value=$(grep "^${key}=" "$CONFIG_FILE" 2>/dev/null | cut -d'=' -f2 | xargs)
            if [[ -n "$value" ]]; then
                echo "$key = $value"
            else
                print_error "Key not found: $key"
                return 1
            fi
        else
            print_error "Config file not found"
            return 1
        fi
    fi
}

# Set config value
function config_set() {
    local key=$1
    local value=$2

    if [[ -z "$key" ]] || [[ -z "$value" ]]; then
        print_error "Missing arguments"
        echo "Usage: prompt-cli config set <key> <value>"
        return 1
    fi

    # Validate boolean values
    case "$key" in
        SHOW_GIT|SHOW_USER|SHOW_HOST|SHOW_PATH|SHOW_TIME|SHOW_EXIT_CODE|GIT_SHOW_STATUS)
            if [[ "$value" != "true" ]] && [[ "$value" != "false" ]]; then
                print_error "Value for $key must be 'true' or 'false'"
                return 1
            fi
            ;;
        PATH_STYLE)
            if [[ "$value" != "full" ]] && [[ "$value" != "short" ]] && [[ "$value" != "basename" ]]; then
                print_error "Value for PATH_STYLE must be 'full', 'short', or 'basename'"
                return 1
            fi
            ;;
        THEME)
            valid_themes="forest ocean classic minimal dracula sunset matrix nord"
            if [[ ! " $valid_themes " =~ " $value " ]]; then
                print_error "Unknown theme: $value"
                echo "Available themes: $valid_themes"
                return 1
            fi
            ;;
    esac

    if type set_config &>/dev/null; then
        set_config "$key" "$value"
        print_info "Set $key = $value"
        echo "Run 'prompt-cli reload' to apply changes"
    else
        print_error "Configuration system not loaded"
        return 1
    fi
}

# Reset config
function config_reset() {
    print_warning "This will reset all configuration to defaults"
    read -p "Are you sure? (y/n): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ -f "$CONFIG_FILE" ]]; then
            rm "$CONFIG_FILE"
        fi

        if type init_config &>/dev/null; then
            init_config
            load_config
            print_info "Configuration reset to defaults"
        else
            print_error "Configuration system not loaded"
            return 1
        fi
    else
        print_info "Reset cancelled"
    fi
}

# Edit config file
function config_edit() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        print_error "Config file not found: $CONFIG_FILE"
        echo "Run 'prompt-cli install' first"
        return 1
    fi

    # Detect editor
    local editor="${EDITOR:-${VISUAL:-nano}}"

    if command -v "$editor" &>/dev/null; then
        "$editor" "$CONFIG_FILE"
        print_info "Config file edited. Run 'prompt-cli reload' to apply changes"
    else
        print_error "Editor not found: $editor"
        echo "Set EDITOR environment variable or install nano"
        return 1
    fi
}

# Main config command handler
function config_command() {
    local subcommand=$1
    shift

    case "$subcommand" in
        list)
            config_list
            ;;
        get)
            config_get "$@"
            ;;
        set)
            config_set "$@"
            ;;
        reset)
            config_reset
            ;;
        edit)
            config_edit
            ;;
        help|--help|-h|"")
            show_config_help
            ;;
        *)
            print_error "Unknown subcommand: $subcommand"
            echo "Run: prompt-cli config help"
            return 1
            ;;
    esac
}

# If script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    config_command "$@"
fi