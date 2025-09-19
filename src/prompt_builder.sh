#!/usr/bin/env bash
# Prompt assembly and building

# Function to get formatted path
function get_prompt_path() {
    local path_style=$(get_config PATH_STYLE)
    local current_path=""

    case "$path_style" in
        basename)
            current_path="\\W"
            ;;
        short)
            # Show ~ for home and truncate deep paths
            current_path="\\w"
            ;;
        full|*)
            current_path="\\w"
            ;;
    esac

    echo "$current_path"
}

# Function to get exit code indicator
function get_exit_code() {
    local exit_code=$1
    if [[ $(get_config SHOW_EXIT_CODE) == "true" ]] && [[ $exit_code -ne 0 ]]; then
        echo " ${PROMPT_EXIT_CODE_COLOR}✗${RESET}"
    fi
}

# Function to get time string
function get_time_string() {
    if [[ $(get_config SHOW_TIME) == "true" ]]; then
        echo "[\\t] "
    fi
}

# Function to build the prompt
function build_prompt() {
    local last_exit_code=$?
    local prompt=""

    # Time
    if [[ $(get_config SHOW_TIME) == "true" ]]; then
        prompt+="${PROMPT_TIME_COLOR}[\\t]${RESET} "
    fi

    # User
    if [[ $(get_config SHOW_USER) == "true" ]]; then
        prompt+="${PROMPT_USER_COLOR}\\u${RESET}"
    fi

    # @ separator
    if [[ $(get_config SHOW_USER) == "true" ]] && [[ $(get_config SHOW_HOST) == "true" ]]; then
        prompt+="@"
    fi

    # Host
    if [[ $(get_config SHOW_HOST) == "true" ]]; then
        prompt+="${PROMPT_HOST_COLOR}\\h${RESET}"
    fi

    # : separator
    if [[ $(get_config SHOW_PATH) == "true" ]] && ([[ $(get_config SHOW_USER) == "true" ]] || [[ $(get_config SHOW_HOST) == "true" ]]); then
        prompt+=":"
    fi

    # Path
    if [[ $(get_config SHOW_PATH) == "true" ]]; then
        prompt+="${PROMPT_PATH_COLOR}$(get_prompt_path)${RESET}"
    fi

    # Git info
    if [[ $(get_config SHOW_GIT) == "true" ]] && is_git_repo; then
        local git_info=""
        local branch=$(git_branch)

        if [[ -n "$branch" ]]; then
            git_info="${PROMPT_GIT_COLOR} (${branch}"

            if [[ $(get_config GIT_SHOW_STATUS) == "true" ]]; then
                local status=$(git_status_symbols)
                if [[ -n "$status" ]]; then
                    git_info+=" ${PROMPT_GIT_STATUS_COLOR}${status}${PROMPT_GIT_COLOR}"
                fi
            fi

            git_info+=")${RESET}"
            prompt+="$git_info"
        fi
    fi

    # Exit code
    if [[ $(get_config SHOW_EXIT_CODE) == "true" ]] && [[ $last_exit_code -ne 0 ]]; then
        prompt+=" ${PROMPT_EXIT_CODE_COLOR}[${last_exit_code}]${RESET}"
    fi

    # Prompt symbol ($ for user, # for root) - using simple dollar sign
    if [[ $EUID -eq 0 ]]; then
        prompt+=" ${PROMPT_SYMBOL_COLOR}#${RESET} "
    else
        prompt+=" ${PROMPT_SYMBOL_COLOR}\$${RESET} "
    fi

    # Set the PS1
    PS1="$prompt"
}

# Function to enable prompt
function enable_custom_prompt() {
    PROMPT_COMMAND="build_prompt"
    echo "Custom prompt enabled!"
}

# Function to disable prompt
function disable_custom_prompt() {
    PROMPT_COMMAND=""
    PS1="\\u@\\h:\\w\\$ "
    echo "Custom prompt disabled. Using default bash prompt."
}

# Function to preview current settings
function preview_prompt() {
    local old_ps1="$PS1"
    build_prompt
    echo -e "\nPreview: $PS1"
    PS1="$old_ps1"
}