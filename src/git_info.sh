#!/usr/bin/env bash
# Git information functions

# Function to check if we're in a git repository
function is_git_repo() {
    git rev-parse --git-dir &>/dev/null
    return $?
}

# Function to get current git branch
function git_branch() {
    if is_git_repo; then
        local branch
        branch=$(git symbolic-ref --short HEAD 2>/dev/null)

        if [[ -z "$branch" ]]; then
            # We're in detached HEAD state
            branch=$(git rev-parse --short HEAD 2>/dev/null)
            branch="detached:${branch}"
        fi

        echo "$branch"
    fi
}

# Function to get git remote info
function git_remote() {
    if is_git_repo; then
        local remote
        remote=$(git config --get remote.origin.url 2>/dev/null)

        if [[ -n "$remote" ]]; then
            # Extract just the repo name
            remote=$(basename "$remote" .git)
            echo "$remote"
        fi
    fi
}

# Function to format git info for prompt
function git_prompt_info() {
    if is_git_repo; then
        local branch=$(git_branch)
        if [[ -n "$branch" ]]; then
            echo " (${branch})"
        fi
    fi
}