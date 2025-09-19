#!/usr/bin/env bash
# Color configuration and themes

# Load base colors first
source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"

# Function to load default colors (CHANGED TO FOREST)
function load_default_colors() {
    # Forest theme as default
    export PROMPT_USER_COLOR="${GREEN}"
    export PROMPT_HOST_COLOR="${BOLD_GREEN}"
    export PROMPT_PATH_COLOR="${YELLOW}"
    export PROMPT_GIT_COLOR="${CYAN}"
    export PROMPT_GIT_STATUS_COLOR="${RED}"
    export PROMPT_SYMBOL_COLOR="${GREEN}"
    export PROMPT_TIME_COLOR="${YELLOW}"
    export PROMPT_EXIT_CODE_COLOR="${RED}"
    export PROMPT_VENV_COLOR="${GREEN}"
}

# Function to load theme colors
function load_theme_colors() {
    local theme="${1:-forest}"  # Changed default to forest

    case "$theme" in
        forest|default)  # Forest is now also the default
            export PROMPT_USER_COLOR="${GREEN}"
            export PROMPT_HOST_COLOR="${BOLD_GREEN}"
            export PROMPT_PATH_COLOR="${YELLOW}"
            export PROMPT_GIT_COLOR="${CYAN}"
            export PROMPT_GIT_STATUS_COLOR="${RED}"
            export PROMPT_SYMBOL_COLOR="${GREEN}"
            export PROMPT_TIME_COLOR="${YELLOW}"
            export PROMPT_EXIT_CODE_COLOR="${RED}"
            export PROMPT_VENV_COLOR="${GREEN}"
            ;;
        ocean)
            export PROMPT_USER_COLOR="${CYAN}"
            export PROMPT_HOST_COLOR="${BLUE}"
            export PROMPT_PATH_COLOR="${BOLD_BLUE}"
            export PROMPT_GIT_COLOR="${GREEN}"
            export PROMPT_GIT_STATUS_COLOR="${YELLOW}"
            export PROMPT_SYMBOL_COLOR="${CYAN}"
            export PROMPT_TIME_COLOR="${BLUE}"
            export PROMPT_EXIT_CODE_COLOR="${RED}"
            export PROMPT_VENV_COLOR="${CYAN}"
            ;;
        classic)  # The old default theme
            export PROMPT_USER_COLOR="${GREEN}"
            export PROMPT_HOST_COLOR="${YELLOW}"
            export PROMPT_PATH_COLOR="${BLUE}"
            export PROMPT_GIT_COLOR="${CYAN}"
            export PROMPT_GIT_STATUS_COLOR="${RED}"
            export PROMPT_SYMBOL_COLOR="${WHITE}"
            export PROMPT_TIME_COLOR="${PURPLE}"
            export PROMPT_EXIT_CODE_COLOR="${RED}"
            export PROMPT_VENV_COLOR="${YELLOW}"
            ;;
        minimal)
            export PROMPT_USER_COLOR="${WHITE}"
            export PROMPT_HOST_COLOR="${WHITE}"
            export PROMPT_PATH_COLOR="${WHITE}"
            export PROMPT_GIT_COLOR="${WHITE}"
            export PROMPT_GIT_STATUS_COLOR="${WHITE}"
            export PROMPT_SYMBOL_COLOR="${WHITE}"
            export PROMPT_TIME_COLOR="${WHITE}"
            export PROMPT_EXIT_CODE_COLOR="${WHITE}"
            export PROMPT_VENV_COLOR="${WHITE}"
            ;;
        dracula)
            export PROMPT_USER_COLOR="${PURPLE}"
            export PROMPT_HOST_COLOR="${CYAN}"
            export PROMPT_PATH_COLOR="${GREEN}"
            export PROMPT_GIT_COLOR="${YELLOW}"
            export PROMPT_GIT_STATUS_COLOR="${RED}"
            export PROMPT_SYMBOL_COLOR="${PURPLE}"
            export PROMPT_TIME_COLOR="${BLUE}"
            export PROMPT_EXIT_CODE_COLOR="${RED}"
            export PROMPT_VENV_COLOR="${PURPLE}"
            ;;
        sunset)  # New theme
            export PROMPT_USER_COLOR="${RED}"
            export PROMPT_HOST_COLOR="${YELLOW}"
            export PROMPT_PATH_COLOR="${PURPLE}"
            export PROMPT_GIT_COLOR="${CYAN}"
            export PROMPT_GIT_STATUS_COLOR="${YELLOW}"
            export PROMPT_SYMBOL_COLOR="${RED}"
            export PROMPT_TIME_COLOR="${PURPLE}"
            export PROMPT_EXIT_CODE_COLOR="${BOLD_RED}"
            export PROMPT_VENV_COLOR="${YELLOW}"
            ;;
        matrix)  # New theme
            export PROMPT_USER_COLOR="${BOLD_GREEN}"
            export PROMPT_HOST_COLOR="${GREEN}"
            export PROMPT_PATH_COLOR="${GREEN}"
            export PROMPT_GIT_COLOR="${BOLD_GREEN}"
            export PROMPT_GIT_STATUS_COLOR="${GREEN}"
            export PROMPT_SYMBOL_COLOR="${BOLD_GREEN}"
            export PROMPT_TIME_COLOR="${GREEN}"
            export PROMPT_EXIT_CODE_COLOR="${BOLD_GREEN}"
            export PROMPT_VENV_COLOR="${GREEN}"
            ;;
        nord)  # New theme
            export PROMPT_USER_COLOR="${CYAN}"
            export PROMPT_HOST_COLOR="${BLUE}"
            export PROMPT_PATH_COLOR="${WHITE}"
            export PROMPT_GIT_COLOR="${GREEN}"
            export PROMPT_GIT_STATUS_COLOR="${YELLOW}"
            export PROMPT_SYMBOL_COLOR="${BLUE}"
            export PROMPT_TIME_COLOR="${CYAN}"
            export PROMPT_EXIT_CODE_COLOR="${RED}"
            export PROMPT_VENV_COLOR="${BLUE}"
            ;;
        *)
            echo "Unknown theme: $theme. Using forest."
            load_default_colors
            ;;
    esac
}

# Function to list available themes
function list_themes() {
    echo "Available themes:"
    echo "  - forest   : Green nature theme (default)"
    echo "  - ocean    : Blue/cyan theme"
    echo "  - classic  : Traditional colors"
    echo "  - minimal  : Monochrome"
    echo "  - dracula  : Purple/dark theme"
    echo "  - sunset   : Warm red/yellow theme"
    echo "  - matrix   : All green theme"
    echo "  - nord     : Nordic blue theme"
}

# Function to preview theme
function preview_theme() {
    local theme="${1:-forest}"
    local old_theme="${PROMPT_THEME}"

    # Temporarily load theme
    load_theme_colors "$theme"

    # Show preview
    echo -e "\nTheme: $theme"
    echo -e "${PROMPT_USER_COLOR}user${RESET}@${PROMPT_HOST_COLOR}host${RESET}:${PROMPT_PATH_COLOR}~/path${RESET}${PROMPT_GIT_COLOR} (main${PROMPT_GIT_STATUS_COLOR}*${PROMPT_GIT_COLOR})${RESET}${PROMPT_SYMBOL_COLOR}\$${RESET}"

    # Restore original theme
    load_theme_colors "$old_theme"
}

# Function to initialize colors
function init_colors() {
    # Load theme from config or use forest as default
    local theme=$(get_config THEME 2>/dev/null || echo "forest")
    load_theme_colors "$theme"
}