#!/usr/bin/env bash
# Configuration system for custom prompt

# Configuration paths
export PROMPT_CONFIG_DIR="${HOME}/.config/custom-prompt"
export PROMPT_CONFIG_FILE="${PROMPT_CONFIG_DIR}/config"

# Default configuration values (using regular variables for compatibility)
DEFAULT_SHOW_GIT="true"
DEFAULT_SHOW_USER="true"
DEFAULT_SHOW_HOST="true"
DEFAULT_SHOW_PATH="true"
DEFAULT_SHOW_TIME="false"
DEFAULT_SHOW_EXIT_CODE="true"
DEFAULT_SHOW_VIRTUALENV="true"
DEFAULT_PATH_STYLE="full"
DEFAULT_THEME="forest"  # Changed from "default" to "forest"
DEFAULT_GIT_SHOW_STATUS="true"

# Function to initialize config directory
function init_config() {
    if [[ ! -d "$PROMPT_CONFIG_DIR" ]]; then
        mkdir -p "$PROMPT_CONFIG_DIR"
    fi

    if [[ ! -f "$PROMPT_CONFIG_FILE" ]]; then
        create_default_config
        echo "Created default config at: $PROMPT_CONFIG_FILE"
    fi
}

# Function to create default configuration file
function create_default_config() {
    cat > "$PROMPT_CONFIG_FILE" << EOF
# Custom Prompt Configuration
# Generated on: $(date)

# Display Options
SHOW_GIT=true
SHOW_USER=true
SHOW_HOST=true
SHOW_PATH=true
SHOW_TIME=false
SHOW_EXIT_CODE=true
SHOW_VIRTUALENV=true

# Path Style: full, short, or basename
PATH_STYLE=full

# Theme: forest, ocean, classic, minimal, dracula, sunset, matrix, nord
THEME=forest

# Git Options
GIT_SHOW_STATUS=true
EOF
}

# Function to load configuration
function load_config() {
    # First set defaults
    export PROMPT_SHOW_GIT="${DEFAULT_SHOW_GIT}"
    export PROMPT_SHOW_USER="${DEFAULT_SHOW_USER}"
    export PROMPT_SHOW_HOST="${DEFAULT_SHOW_HOST}"
    export PROMPT_SHOW_PATH="${DEFAULT_SHOW_PATH}"
    export PROMPT_SHOW_TIME="${DEFAULT_SHOW_TIME}"
    export PROMPT_SHOW_EXIT_CODE="${DEFAULT_SHOW_EXIT_CODE}"
    export PROMPT_SHOW_VIRTUALENV="${DEFAULT_SHOW_VIRTUALENV}"
    export PROMPT_PATH_STYLE="${DEFAULT_PATH_STYLE}"
    export PROMPT_THEME="${DEFAULT_THEME}"
    export PROMPT_GIT_SHOW_STATUS="${DEFAULT_GIT_SHOW_STATUS}"

    # Then load from file if exists
    if [[ -f "$PROMPT_CONFIG_FILE" ]]; then
        while IFS='=' read -r key value; do
            # Skip comments and empty lines
            [[ "$key" =~ ^#.*$ ]] && continue
            [[ -z "$key" ]] && continue

            # Remove leading/trailing whitespace
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs)

            # Export the configuration
            export "PROMPT_${key}=${value}"
        done < "$PROMPT_CONFIG_FILE"
    fi
}

# Function to get config value
function get_config() {
    local key=$1
    local var_name="PROMPT_${key}"
    echo "${!var_name}"
}

# Function to set config value
function set_config() {
    local key=$1
    local value=$2

    if [[ -f "$PROMPT_CONFIG_FILE" ]]; then
        # Update existing key or add new one
        if grep -q "^${key}=" "$PROMPT_CONFIG_FILE"; then
            if [[ "$(uname)" == "Darwin" ]]; then
                sed -i '' "s/^${key}=.*/${key}=${value}/" "$PROMPT_CONFIG_FILE"
            else
                sed -i "s/^${key}=.*/${key}=${value}/" "$PROMPT_CONFIG_FILE"
            fi
        else
            echo "${key}=${value}" >> "$PROMPT_CONFIG_FILE"
        fi

        # Reload configuration
        load_config
    fi
}