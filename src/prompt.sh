#!/usr/bin/env bash
function custom_prompt() {
    # Basic prompt: user@host:current_directory$
    PS1="\u@\h:\w\$ "
}
export -f custom_prompt
PROMPT_COMMAND=custom_prompt
custom_prompt