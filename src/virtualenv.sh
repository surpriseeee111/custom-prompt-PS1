#!/usr/bin/env bash
# Virtual environment detection for Python, Node, Ruby, etc.

# Function to detect Python virtual environment
function detect_python_venv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Standard virtualenv/venv
        echo "($(basename "$VIRTUAL_ENV"))"
        return 0
    elif [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        # Conda environment
        echo "(conda:$CONDA_DEFAULT_ENV)"
        return 0
    elif [[ -n "$PIPENV_ACTIVE" ]]; then
        # Pipenv
        echo "(pipenv)"
        return 0
    elif [[ -n "$POETRY_ACTIVE" ]]; then
        # Poetry
        echo "(poetry)"
        return 0
    fi
    return 1
}

# Function to detect Node.js version manager
function detect_node_env() {
    if [[ -n "$NVM_BIN" ]]; then
        local node_version=$(node -v 2>/dev/null)
        if [[ -n "$node_version" ]]; then
            echo "(nvm:${node_version})"
            return 0
        fi
    fi
    return 1
}

# Function to detect Ruby environment
function detect_ruby_env() {
    if [[ -n "$GEM_HOME" ]] && [[ "$GEM_HOME" != *"/.gem"* ]]; then
        local ruby_version=$(ruby -v 2>/dev/null | cut -d' ' -f2)
        if [[ -n "$ruby_version" ]]; then
            echo "(ruby:${ruby_version})"
            return 0
        fi
    elif command -v rvm &>/dev/null && [[ -n "$GEM_HOME" ]]; then
        local rvm_current=$(rvm current 2>/dev/null)
        if [[ -n "$rvm_current" ]] && [[ "$rvm_current" != "system" ]]; then
            echo "(rvm:${rvm_current})"
            return 0
        fi
    fi
    return 1
}

# Function to detect Docker context
function detect_docker_context() {
    if [[ -n "$DOCKER_HOST" ]]; then
        echo "(docker)"
        return 0
    elif [[ -f "/.dockerenv" ]]; then
        echo "(in-docker)"
        return 0
    fi
    return 1
}

# Main function to get all virtual environments
function get_virtualenv_info() {
    local env_info=""
    local python_env=$(detect_python_venv)
    local node_env=$(detect_node_env)
    local ruby_env=$(detect_ruby_env)
    local docker_env=$(detect_docker_context)

    # Combine all detected environments
    local all_envs=""
    [[ -n "$python_env" ]] && all_envs="$python_env"
    [[ -n "$node_env" ]] && all_envs="${all_envs:+$all_envs }$node_env"
    [[ -n "$ruby_env" ]] && all_envs="${all_envs:+$all_envs }$ruby_env"
    [[ -n "$docker_env" ]] && all_envs="${all_envs:+$all_envs }$docker_env"

    echo "$all_envs"
}

# Function to check if we should show virtualenv
function should_show_virtualenv() {
    local show_venv=$(get_config SHOW_VIRTUALENV 2>/dev/null || echo "true")
    [[ "$show_venv" == "true" ]]
}