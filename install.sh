#!/usr/bin/env bash
# Installation script for Custom Prompt PS1

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Installation directory
INSTALL_DIR="${HOME}/.custom-prompt"

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to detect shell
detect_shell() {
    if [ -n "$BASH_VERSION" ]; then
        echo "bash"
    elif [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
    else
        echo "unknown"
    fi
}

# Main installation
main() {
    print_info "Starting Custom Prompt PS1 installation..."

    # Check if already installed
    if [[ -d "$INSTALL_DIR" ]]; then
        print_warning "Custom Prompt already installed at $INSTALL_DIR"
        read -p "Do you want to reinstall? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled."
            exit 0
        fi
        rm -rf "$INSTALL_DIR"
    fi

    # Create installation directory
    print_info "Creating installation directory: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"

    # Copy source files
    print_info "Copying source files..."
    if [[ -d "src" ]]; then
        cp -r src/* "$INSTALL_DIR/"
    else
        print_error "Source directory not found. Please run from the repository root."
        exit 1
    fi

    # Make scripts executable
    chmod +x "$INSTALL_DIR"/*.sh

    # Add loader to shell RC file
    SHELL_TYPE=$(detect_shell)
    RC_FILE=""

    case "$SHELL_TYPE" in
        bash)
            RC_FILE="$HOME/.bashrc"
            # Also check .bash_profile on macOS
            if [[ "$OSTYPE" == "darwin"* ]] && [[ -f "$HOME/.bash_profile" ]]; then
                RC_FILE="$HOME/.bash_profile"
            fi
            ;;
        zsh)
            RC_FILE="$HOME/.zshrc"
            ;;
        *)
            print_warning "Unknown shell. Please manually add the following to your shell RC file:"
            echo "source $INSTALL_DIR/loader.sh"
            ;;
    esac

    if [[ -n "$RC_FILE" ]]; then
        # Check if already added
        if grep -q "custom-prompt/loader.sh" "$RC_FILE" 2>/dev/null; then
            print_warning "Loader already exists in $RC_FILE"
        else
            print_info "Adding loader to $RC_FILE"
            echo "" >> "$RC_FILE"
            echo "# Custom Prompt PS1" >> "$RC_FILE"
            echo "if [[ -f \"$INSTALL_DIR/loader.sh\" ]]; then" >> "$RC_FILE"
            echo "    source \"$INSTALL_DIR/loader.sh\"" >> "$RC_FILE"
            echo "    enable_custom_prompt" >> "$RC_FILE"
            echo "fi" >> "$RC_FILE"
        fi
    fi

    print_info "Installation complete!"
    echo ""
    echo "To start using the custom prompt:"
    echo "  1. Restart your terminal, or"
    echo "  2. Run: source $RC_FILE"
    echo ""
    echo "Commands available:"
    echo "  prompt_info         - Show current configuration"
    echo "  enable_custom_prompt  - Enable the custom prompt"
    echo "  disable_custom_prompt - Disable the custom prompt"
    echo "  reload_prompt        - Reload configuration"
    echo ""
    print_info "Enjoy your new prompt!"
}

# Run main installation
main "$@"