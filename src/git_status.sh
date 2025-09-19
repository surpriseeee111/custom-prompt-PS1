#!/usr/bin/env bash
# Git status indicators and symbols

# Function to check if there are uncommitted changes
function git_has_changes() {
    if is_git_repo; then
        ! git diff --quiet --ignore-submodules HEAD 2>/dev/null
    else
        return 1
    fi
}

# Function to check if there are untracked files
function git_has_untracked() {
    if is_git_repo; then
        [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]
    else
        return 1
    fi
}

# Function to check if there are staged files
function git_has_staged() {
    if is_git_repo; then
        ! git diff --cached --quiet 2>/dev/null
    else
        return 1
    fi
}

# Function to get ahead/behind status
function git_ahead_behind() {
    if is_git_repo; then
        local upstream branch ahead behind

        branch=$(git symbolic-ref --short HEAD 2>/dev/null)
        upstream=$(git rev-parse --abbrev-ref "${branch}@{upstream}" 2>/dev/null)

        if [[ -n "$upstream" ]]; then
            ahead=$(git rev-list --count "${upstream}..HEAD" 2>/dev/null)
            behind=$(git rev-list --count "HEAD..${upstream}" 2>/dev/null)

            local status=""
            [[ $ahead -gt 0 ]] && status="↑${ahead}"
            [[ $behind -gt 0 ]] && status="${status}↓${behind}"

            echo "$status"
        fi
    fi
}

# Function to get all git status symbols
function git_status_symbols() {
    if ! is_git_repo; then
        return
    fi

    local symbols=""

    # Check for various states
    git_has_changes && symbols="${symbols}*"
    git_has_untracked && symbols="${symbols}?"
    git_has_staged && symbols="${symbols}+"

    # Add ahead/behind
    local ahead_behind=$(git_ahead_behind)
    [[ -n "$ahead_behind" ]] && symbols="${symbols} ${ahead_behind}"

    echo "$symbols"
}

# Combined git info with status
function git_full_info() {
    if is_git_repo; then
        local branch=$(git_branch)
        local status=$(git_status_symbols)

        if [[ -n "$branch" ]]; then
            if [[ -n "$status" ]]; then
                echo " (${branch} ${status})"
            else
                echo " (${branch})"
            fi
        fi
    fi
}