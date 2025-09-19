#!/usr/bin/env bash
# Color support detection and color definitions

# Function to check if terminal supports colors
function supports_color() {
    # Check if stdout is a terminal
    if [ -t 1 ]; then
        # Check if terminal supports colors (8 or more)
        if [ "$(tput colors 2>/dev/null)" -ge 8 ]; then
            return 0
        fi
    fi
    return 1
}

# Define color codes
if supports_color; then
    # Regular colors
    export RED='\[\033[0;31m\]'
    export GREEN='\[\033[0;32m\]'
    export YELLOW='\[\033[0;33m\]'
    export BLUE='\[\033[0;34m\]'
    export PURPLE='\[\033[0;35m\]'
    export CYAN='\[\033[0;36m\]'
    export WHITE='\[\033[0;37m\]'

    # Bold colors
    export BOLD_RED='\[\033[1;31m\]'
    export BOLD_GREEN='\[\033[1;32m\]'
    export BOLD_YELLOW='\[\033[1;33m\]'
    export BOLD_BLUE='\[\033[1;34m\]'

    # Reset
    export RESET='\[\033[0m\]'
else
    # No colors
    export RED=''
    export GREEN=''
    export YELLOW=''
    export BLUE=''
    export PURPLE=''
    export CYAN=''
    export WHITE=''
    export BOLD_RED=''
    export BOLD_GREEN=''
    export BOLD_YELLOW=''
    export BOLD_BLUE=''
    export RESET=''
fi