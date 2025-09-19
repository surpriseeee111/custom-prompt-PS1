#!/usr/bin/env bash
# Main loader script for custom prompt

# Prevent multiple loads
if [[ -n "$CUSTOM_PROMPT_LOADED" ]]; then
    return 0
fi
export CUSTOM_PROMPT_LOADED=1

# Get the directory where this script is located
if [[ -n "${BASH_SOURCE[0]}" ]]; then
    PROMPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    PROMPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi

# Export for use in other scripts
export CUSTOM_PROMPT_DIR="$PROMPT_DIR"

# Source all components in correct order
source "$PROMPT_DIR/colors.sh"
source "$PROMPT_DIR/os_detect.sh"
source "$PROMPT_DIR/git_info.sh"
source "$PROMPT_DIR/git_status.sh"
source "$PROMPT_DIR/config.sh"
source "$PROMPT_DIR/color_config.sh"
source "$PROMPT_DIR/prompt_builder.sh"

# Initialize components
init_config
load_config
init_colors

# Function to reload prompt
function reload_prompt() {
    load_config
    init_colors
    echo "Prompt reloaded!"
}

# Function to show prompt info
function prompt_info() {
    echo "Custom Prompt PS1 - Status"
    echo "========================="
    echo "Config Dir: $PROMPT_CONFIG_DIR"
    echo "Theme: $(get_config THEME)"
    echo "Show Git: $(get_config SHOW_GIT)"
    echo "Show User: $(get_config SHOW_USER)"
    echo "Show Host: $(get_config SHOW_HOST)"
    echo "Show Path: $(get_config SHOW_PATH)"
    echo "Show Time: $(get_config SHOW_TIME)"
    echo "OS Type: $OS_TYPE"

    if is_git_repo; then
        echo ""
        echo "Git Info:"
        echo "  Branch: $(git_branch)"
        echo "  Status: $(git_status_symbols)"
    fi
}

# Export functions for global use
export -f reload_prompt
export -f prompt_info

# Only show message if in interactive shell
if [[ $- == *i* ]]; then
    echo "Custom Prompt PS1 loaded! Type 'prompt_info' for status."
fi