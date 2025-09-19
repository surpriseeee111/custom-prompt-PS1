#!/usr/bin/env bash
# Theme command for prompt-cli

# Source required functions
PROMPT_DIR="${HOME}/.custom-prompt"
if [[ -f "$PROMPT_DIR/loader.sh" ]]; then
    source "$PROMPT_DIR/loader.sh" 2>/dev/null
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Print functions
print_info() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Show theme help
function show_theme_help() {
    cat << EOF
Theme Command - Manage prompt themes

Usage: prompt-cli theme [subcommand] [options]

Subcommands:
  list              List all available themes
  set <theme>       Set a theme
  show              Show current theme
  preview <theme>   Preview a theme without applying

Available Themes:
  default   - Classic colors (green/yellow/blue)
  ocean     - Blue/cyan theme
  forest    - Green theme
  minimal   - Monochrome
  dracula   - Purple/dark theme

Examples:
  prompt-cli theme list
  prompt-cli theme set ocean
  prompt-cli theme preview forest
  prompt-cli theme show
EOF
}

# List themes
function theme_list() {
    echo "Available themes:"
    echo ""
    echo -e "  ${GREEN}●${NC} default  - Classic colors"
    echo -e "  ${CYAN}●${NC} ocean    - Blue/cyan theme"
    echo -e "  ${GREEN}●${NC} forest   - Green nature theme"
    echo -e "  ${NC}●${NC} minimal  - Monochrome/simple"
    echo -e "  ${PURPLE}●${NC} dracula  - Purple/dark theme"
    echo ""

    local current_theme=$(get_config THEME 2>/dev/null || echo "default")
    echo "Current theme: ${GREEN}${current_theme}${NC}"
}

# Set theme
function theme_set() {
    local theme=$1

    if [[ -z "$theme" ]]; then
        print_error "No theme specified"
        echo "Usage: prompt-cli theme set <theme>"
        echo "Run 'prompt-cli theme list' to see available themes"
        return 1
    fi

    # Validate theme
    case "$theme" in
        default|ocean|forest|minimal|dracula)
            if type set_config &>/dev/null; then
                set_config THEME "$theme"

                # Reload theme colors
                if type load_theme_colors &>/dev/null; then
                    load_theme_colors "$theme"
                fi

                print_info "Theme set to: $theme"
                echo "Theme will apply to new prompt lines"

                # Show preview
                echo ""
                theme_preview "$theme"
            else
                print_error "Configuration system not loaded"
                return 1
            fi
            ;;
        *)
            print_error "Unknown theme: $theme"
            echo "Available themes: default, ocean, forest, minimal, dracula"
            return 1
            ;;
    esac
}

# Show current theme
function theme_show() {
    local current_theme=$(get_config THEME 2>/dev/null || echo "default")
    echo "Current theme: ${GREEN}${current_theme}${NC}"
    echo ""
    theme_preview "$current_theme"
}

# Preview theme
function theme_preview() {
    local theme="${1:-default}"

    # Check if theme exists
    case "$theme" in
        default|ocean|forest|minimal|dracula)
            ;;
        *)
            print_error "Unknown theme: $theme"
            return 1
            ;;
    esac

    echo "Preview of '${theme}' theme:"
    echo ""

    # Create sample prompt based on theme
    case "$theme" in
        default)
            echo -e "${GREEN}user${NC}@${YELLOW}hostname${NC}:${BLUE}~/projects${NC} ${CYAN}(main)${NC} $"
            ;;
        ocean)
            echo -e "${CYAN}user${NC}@${BLUE}hostname${NC}:${BLUE}~/projects${NC} ${GREEN}(main)${NC} $"
            ;;
        forest)
            echo -e "${GREEN}user${NC}@${GREEN}hostname${NC}:${YELLOW}~/projects${NC} ${CYAN}(main)${NC} $"
            ;;
        minimal)
            echo -e "user@hostname:~/projects (main) $"
            ;;
        dracula)
            echo -e "${PURPLE}user${NC}@${CYAN}hostname${NC}:${GREEN}~/projects${NC} ${YELLOW}(main)${NC} $"
            ;;
    esac
}

# Main theme command handler
function theme_command() {
    local subcommand=$1
    shift

    case "$subcommand" in
        list)
            theme_list
            ;;
        set)
            theme_set "$@"
            ;;
        show)
            theme_show
            ;;
        preview)
            theme_preview "$@"
            ;;
        help|--help|-h|"")
            show_theme_help
            ;;
        *)
            print_error "Unknown subcommand: $subcommand"
            echo "Run: prompt-cli theme help"
            return 1
            ;;
    esac
}

# If script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    theme_command "$@"
fi