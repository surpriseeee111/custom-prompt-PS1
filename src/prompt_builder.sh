#!/usr/bin/env bash
# Prompt assembly and building

# Function to get terminal width
function get_terminal_width() {
    echo "${COLUMNS:-$(tput cols 2>/dev/null || echo 80)}"
}

# Function to calculate prompt length (without color codes)
function get_prompt_length() {
    local prompt="$1"
    # Remove all ANSI escape sequences
    local stripped=$(echo -e "$prompt" | sed 's/\\\[\\033\[[^m]*m\\\]//g' | sed 's/\\033\[[^m]*m//g' | sed 's/\\\[//g' | sed 's/\\\]//g')
    # Remove special bash escapes
    stripped=$(echo "$stripped" | sed 's/\\[uth]//g' | sed 's/\\W//g' | sed 's/\\w/~\/path/g' | sed 's/\\\$//g')
    echo "${#stripped}"
}

# Function to create dynamic separator line
function create_separator_line() {
    local prompt_content="$1"
    local term_width=$(get_terminal_width)
    local prompt_length=$(get_prompt_length "$prompt_content")

    # Calculate remaining space for separator
    local remaining=$((term_width - prompt_length - 1))

    # Create the separator
    local separator=""
    if [[ $remaining -gt 0 ]]; then
        separator=$(printf '─%.0s' $(seq 1 $remaining))
    fi

    echo "$separator"
}

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

# Function to build the prompt (two-line version)
function build_prompt() {
    local last_exit_code=$?
    local line1=""
    local line2=""

    # Build first line content
    local line1_content=""

    # Opening bracket/decorator
    line1_content="${PROMPT_SYMBOL_COLOR}┌─${RESET}"

    # Virtual environment (integrated into the line)
    if [[ $(get_config SHOW_VIRTUALENV) == "true" ]]; then
        local venv_info=$(get_virtualenv_info)
        if [[ -n "$venv_info" ]]; then
            line1_content+="${PROMPT_VENV_COLOR}${venv_info}${RESET}"
            line1_content+="${PROMPT_SYMBOL_COLOR}─${RESET}"
        fi
    fi

    # Time in parentheses
    if [[ $(get_config SHOW_TIME) == "true" ]]; then
        line1_content+="${PROMPT_TIME_COLOR}(\\t)${RESET}"
        line1_content+="${PROMPT_SYMBOL_COLOR}─${RESET}"
    fi

    # Exit code if last command failed
    if [[ $(get_config SHOW_EXIT_CODE) == "true" ]] && [[ $last_exit_code -ne 0 ]]; then
        line1_content+="${PROMPT_EXIT_CODE_COLOR}(Err ${last_exit_code})${RESET}"
        line1_content+="${PROMPT_SYMBOL_COLOR}─${RESET}"
    fi

    # Current directory in parentheses
    if [[ $(get_config SHOW_PATH) == "true" ]]; then
        line1_content+="${PROMPT_SYMBOL_COLOR}(${RESET}"
        line1_content+="${PROMPT_PATH_COLOR}$(get_prompt_path)${RESET}"
        line1_content+="${PROMPT_SYMBOL_COLOR})${RESET}"
    fi

    # Git info
    if [[ $(get_config SHOW_GIT) == "true" ]] && is_git_repo; then
        local branch=$(git_branch)
        if [[ -n "$branch" ]]; then
            line1_content+="${PROMPT_SYMBOL_COLOR}─(${RESET}"
            line1_content+="${PROMPT_GIT_COLOR}${branch}"

            if [[ $(get_config GIT_SHOW_STATUS) == "true" ]]; then
                local status=$(git_status_symbols)
                if [[ -n "$status" ]]; then
                    line1_content+=" ${PROMPT_GIT_STATUS_COLOR}${status}"
                fi
            fi

            line1_content+="${RESET}${PROMPT_SYMBOL_COLOR})${RESET}"
        fi
    fi

    # Add dynamic separator
    local separator=$(create_separator_line "$line1_content")
    line1="${line1_content}${PROMPT_SYMBOL_COLOR}${separator}${RESET}"

    # Build second line
    line2="${PROMPT_SYMBOL_COLOR}└─${RESET}"

    # User@Host
    if [[ $(get_config SHOW_USER) == "true" ]]; then
        line2+="${PROMPT_SYMBOL_COLOR}(${RESET}"
        line2+="${PROMPT_USER_COLOR}\\u${RESET}"

        if [[ $(get_config SHOW_HOST) == "true" ]]; then
            line2+="@${PROMPT_HOST_COLOR}\\h${RESET}"
        fi

        line2+="${PROMPT_SYMBOL_COLOR})${RESET}"
    elif [[ $(get_config SHOW_HOST) == "true" ]]; then
        line2+="${PROMPT_SYMBOL_COLOR}(${RESET}"
        line2+="${PROMPT_HOST_COLOR}\\h${RESET}"
        line2+="${PROMPT_SYMBOL_COLOR})${RESET}"
    fi

    # Prompt symbol
    if [[ $EUID -eq 0 ]]; then
        line2+="${PROMPT_SYMBOL_COLOR}#${RESET} "
    else
        line2+="${PROMPT_SYMBOL_COLOR}\$${RESET} "
    fi

    # Set PS1 with newline between lines
    PS1="${line1}\n${line2}"
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
    echo -e "\nPreview:\n$PS1"
    PS1="$old_ps1"
}