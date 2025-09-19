#!/usr/bin/env bash
# Update command for prompt-cli

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Update function
function update_prompt() {
    local REPO_URL="https://github.com/TheDevOpsBlueprint/custom-prompt-PS1.git"
    local TEMP_DIR="/tmp/custom-prompt-update-$$"

    print_info "Checking for updates..."

    # Clone latest version to temp directory
    if git clone --quiet "$REPO_URL" "$TEMP_DIR" 2>/dev/null; then
        cd "$TEMP_DIR"

        # Run installer
        if [[ -f "install.sh" ]]; then
            print_info "Installing updates..."
            bash install.sh

            # Clean up
            cd /
            rm -rf "$TEMP_DIR"

            print_info "Update complete! Reload your terminal or run: reload_prompt"
        else
            print_error "Install script not found in repository"
            rm -rf "$TEMP_DIR"
            return 1
        fi
    else
        print_error "Failed to download updates"
        return 1
    fi
}

# If run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    update_prompt
fi