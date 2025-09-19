#!/usr/bin/env bash
# Theme command for prompt-cli

# Source required functions
PROMPT_DIR="${HOME}/.custom-prompt"
if [[ -f "$PROMPT_DIR/loader.sh" ]]; then
    source "$PROMPT_DIR/loader.sh" 2>/dev/null >&2
fi

# Use plain colors for output
RED="${RED_PLAIN:-\033[0;31m}"
GREEN="${GREEN_PLAIN:-\033[0;32m}"
YELLOW="${YELLOW_PLAIN:-\033[1;33m}"
BLUE="${BLUE_PLAIN:-\033[0;34m}"
PURPLE="${PURPLE_PLAIN:-\033[0;35m}"
CYAN="${CYAN_PLAIN:-\033[0;36m}"
NC="${NC:-\033[0m}"

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
  forest    - Green nature theme (default)
  ocean     - Blue/cyan theme
  classic   - Traditional colors
  minimal   - Monochrome
  dracula   - Purple/dark theme
  sunset    - Warm red/yellow theme
  matrix    - All green theme
  nord      - Nordic blue theme

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
    echo -e "  ${GREEN}●${NC} forest   - Green nature theme (default)"
    echo -e "  ${CYAN}●${NC} ocean    - Blue/cyan theme"
    echo -e "  ${YELLOW}●${NC} classic  - Traditional colors"
    echo -e "  ${NC}●${NC} minimal  - Monochrome"
    echo -e "  ${PURPLE}●${NC} dracula  - Purple/dark theme"
    echo -e "  ${RED}●${NC} sunset   - Warm red/yellow theme"
    echo -e "  ${GREEN}●${NC} matrix   - All green theme"
    echo -e "  ${BLUE}●${NC} nord     - Nordic blue theme"
    echo ""

    local current_theme=$(get_config THEME 2>/dev/null || echo "forest")
    echo -e "Current theme: ${GREEN}${current_theme}${NC}"
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
        forest|ocean|classic|minimal|dracula|sunset|matrix|nord|default)
            # Map default to forest
            [[ "$theme" == "default" ]] && theme="forest"

            if type set_config &>/dev/null; then
                set_config THEME "$theme"

                if type load_theme_colors &>/dev/null; then
                    load_theme_colors "$theme"
                fi

                print_info "Theme set to: $theme"
                echo "Theme will apply to new prompt lines"

                echo ""
                theme_preview "$theme"
            else
                print_error "Configuration system not loaded"
                return 1
            fi
            ;;
        *)
            print_error "Unknown theme: $theme"
            echo "Available themes: forest, ocean, classic, minimal, dracula, sunset, matrix, nord"
            return 1
            ;;
    esac
}

# Show current theme
function theme_show() {
    local current_theme=$(get_config THEME 2>/dev/null || echo "forest")
    echo -e "Current theme: ${GREEN}${current_theme}${NC}"
    echo ""
    theme_preview "$current_theme"
}

# Preview theme (simplified)
function theme_preview() {
    local theme="${1:-forest}"

    echo "Preview of '${theme}' theme:"
    echo "User@Host:~/path (git branch: main | ↑2 ±1) $"
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