#!/usr/bin/env bash
# Prompt assembly and building

# Function to get terminal width
function get_terminal_width() {
    echo "${COLUMNS:-$(tput cols 2>/dev/null || echo 80)}"
}

# Function to truncate path if needed
function truncate_path() {
    local path="$1"
    local max_length="$2"

    if [[ ${#path} -gt $max_length ]]; then
        # Truncate from the beginning and add ...
        local truncated="...${path: -$((max_length-3))}"
        echo "$truncated"
    else
        echo "$path"
    fi
}

# Function to calculate real prompt length
function calculate_real_length() {
    local text="$1"
    # Strip ANSI codes and count actual characters
    local stripped=$(echo -e "$text" | sed 's/\x1b\[[0-9;]*m//g' | sed 's/\\\[//g' | sed 's/\\\]//g')
    echo ${#stripped}
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
            current_path="\\w"
            ;;
        full|*)
            current_path="\\w"
            ;;
    esac

    echo "$current_path"
}

# Function to get actual PWD for display
function get_display_pwd() {
    local pwd_path="$PWD"
    # Replace home with ~
    pwd_path="${pwd_path/#$HOME/~}"
    echo "$pwd_path"
}

# Function to build the prompt (two-line version)
function build_prompt() {
    local last_exit_code=$?
    local line1=""
    local line2=""

    # Build ALL fixed content first to calculate proper length
    local fixed_content=""

    # Opening bracket/decorator
    fixed_content="┌─"

    # Virtual environment
    local venv_text=""
    if [[ $(get_config SHOW_VIRTUALENV) == "true" ]]; then
        local venv_info=$(get_virtualenv_info)
        if [[ -n "$venv_info" ]]; then
            venv_text="${venv_info}─"
            fixed_content+="${venv_text}"
        fi
    fi

    # Time
    local time_text=""
    if [[ $(get_config SHOW_TIME) == "true" ]]; then
        time_text="($(date +%H:%M:%S))─"
        fixed_content+="${time_text}"
    fi

    # Exit code
    local err_text=""
    if [[ $(get_config SHOW_EXIT_CODE) == "true" ]] && [[ $last_exit_code -ne 0 ]]; then
        err_text="(Err ${last_exit_code})─"
        fixed_content+="${err_text}"
    fi

    # Git info
    local git_text=""
    if [[ $(get_config SHOW_GIT) == "true" ]] && is_git_repo; then
        local branch=$(git_branch)
        if [[ -n "$branch" ]]; then
            git_text="(${branch}"

            if [[ $(get_config GIT_SHOW_STATUS) == "true" ]]; then
                local status=$(git_status_symbols)
                if [[ -n "$status" ]]; then
                    git_text+=" ${status}"
                fi
            fi

            git_text+=")"
            fixed_content+="${git_text}"
        fi
    fi

    # Now calculate available space for PWD
    local term_width=$(get_terminal_width)
    local fixed_length=${#fixed_content}

    # Get PWD and calculate display
    local pwd_display=$(get_display_pwd)

    # Available space = terminal width - fixed content - brackets/dashes (8 chars reserved)
    local available_for_pwd=$((term_width - fixed_length - 8))

    # Ensure minimum space for PWD
    if [[ $available_for_pwd -lt 20 ]]; then
        available_for_pwd=20
    fi

    # Truncate PWD if needed
    if [[ ${#pwd_display} -gt $available_for_pwd ]]; then
        pwd_display=$(truncate_path "$pwd_display" $available_for_pwd)
    fi

    # Calculate separator length
    local separator_length=$((term_width - fixed_length - ${#pwd_display} - 6))
    if [[ $separator_length -lt 2 ]]; then
        separator_length=2
    fi

    # Build the actual first line with colors
    line1="${PROMPT_SYMBOL_COLOR}┌─${RESET}"

    # Add each component with colors
    if [[ -n "$venv_text" ]]; then
        line1+="${PROMPT_VENV_COLOR}${venv_info}${RESET}${PROMPT_SYMBOL_COLOR}─${RESET}"
    fi

    if [[ -n "$time_text" ]]; then
        line1+="${PROMPT_TIME_COLOR}(\\t)${RESET}${PROMPT_SYMBOL_COLOR}─${RESET}"
    fi

    if [[ -n "$err_text" ]]; then
        line1+="${PROMPT_EXIT_CODE_COLOR}(Err ${last_exit_code})${RESET}${PROMPT_SYMBOL_COLOR}─${RESET}"
    fi

    if [[ -n "$git_text" ]]; then
        line1+="${PROMPT_SYMBOL_COLOR}(${RESET}${PROMPT_GIT_COLOR}${branch}"
        if [[ -n "$status" ]]; then
            line1+=" ${PROMPT_GIT_STATUS_COLOR}${status}"
        fi
        line1+="${RESET}${PROMPT_SYMBOL_COLOR})${RESET}"
    fi

    # Add separator
    local separator=$(printf '─%.0s' $(seq 1 $separator_length))
    line1+="${PROMPT_SYMBOL_COLOR}${separator}(${RESET}"

    # Add PWD
    if [[ $(get_config SHOW_PATH) == "true" ]]; then
        line1+="${PROMPT_PATH_COLOR}${pwd_display}${RESET}"
        line1+="${PROMPT_SYMBOL_COLOR})──${RESET}"
    else
        line1+="${PROMPT_SYMBOL_COLOR})──${RESET}"
    fi

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

    # Set PS1
    PS1="${line1}\n${line2}"
}

# Rest of functions remain the same...
function enable_custom_prompt() {
    PROMPT_COMMAND="build_prompt"
    echo "Custom prompt enabled!"
}

function disable_custom_prompt() {
    PROMPT_COMMAND=""
    PS1="\\u@\\h:\\w\\$ "
    echo "Custom prompt disabled. Using default bash prompt."
}

function preview_prompt() {
    local old_ps1="$PS1"
    build_prompt
    echo -e "\nPreview:\n$PS1"
    PS1="$old_ps1"
}