#!/usr/bin/env bash
# Configuration system for custom prompt

# Configuration paths
export PROMPT_CONFIG_DIR="${HOME}/.config/custom-prompt"
export PROMPT_CONFIG_FILE="${PROMPT_CONFIG_DIR}/config"

# Default configuration values
declare -A DEFAULT_CONFIG=(
    ["SHOW_GIT"]="true"
    ["SHOW_USER"]="true"
    ["SHOW_HOST"]="true"
    ["SHOW_PATH"]="true"
    ["SHOW_TIME"]="false"
    ["SHOW_EXIT_CODE"]="true"
    ["PATH_STYLE"]="full"  # full, short, or basename
    ["THEME"]="default"
    ["GIT_SHOW_STATUS"]="true"
)

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
    cat > "$PROMPT_CONFIG_FILE" << 'EOF'
# Custom Prompt Configuration
# Generated on: $(date)

# Display Options
SHOW_GIT=true
SHOW_USER=true
SHOW_HOST=true
SHOW_PATH=true
SHOW_TIME=false
SHOW_EXIT_CODE=true

# Path Style: full, short, or basename
PATH_STYLE=full

# Theme: default, ocean, forest, minimal
THEME=default

# Git Options
GIT_SHOW_STATUS=true
EOF
}

# Function to load configuration
function load_config() {
    # First set defaults
    for key in "${!DEFAULT_CONFIG[@]}"; do
        export "PROMPT_${key}=${DEFAULT_CONFIG[$key]}"
    done

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
            sed -i.bak "s/^${key}=.*/${key}=${value}/" "$PROMPT_CONFIG_FILE"
        else
            echo "${key}=${value}" >> "$PROMPT_CONFIG_FILE"
        fi

        # Reload configuration
        load_config
    fi
}