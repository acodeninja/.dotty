#!/bin/sh

# Get the current directory
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $THIS_DIR/functions.sh

function generate_ps1 {
    local CURRENT_TERM_WIDTH="$(tput cols)"

    local COLOUR_GRAY="\033[1;30m"
    local COLOUR_LIGHT_GRAY="\033[0;37m"
    local COLOUR_CYAN="\033[0;36m"
    local COLOUR_RED="\033[0;31m"
    local COLOUR_YELLOW="\033[0;33m"
    local COLOUR_ORANGE="\033[1;31m"
    local COLOUR_NONE="\033[0m"

    local LAST_EXIT_CODE=$(nonzero_return)

    local USERNAME=$(whoami)
    local HOSTNAME=$(hostname)
    local GIT_CURRENT_BRANCH=$(get_git_branch)
    local GIT_CURRENT_AUTHOR=$(get_git_author)
    local BACKGROUND_JOBS=$(get_background_job_count)
    local GET_CLI_VERSIONS=$(get_current_versions)

    local TOP_LINE="\n$COLOUR_LIGHT_GRAY[$USERNAME@$HOSTNAME]$COLOUR_NONE"
          TOP_LINE="$TOP_LINE$COLOUR_CYAN$GIT_CURRENT_AUTHOR$COLOUR_NONE"
          TOP_LINE="$TOP_LINE$COLOUR_RED$BACKGROUND_JOBS$COLOUR_NONE"

    # if [ "$(tput cols)" -gt "100" ]; then
        TOP_LINE="$TOP_LINE$GET_CLI_VERSIONS"
    # fi

    local PROMPT="$(dirs)$COLOUR_YELLOW$GIT_CURRENT_BRANCH$COLOUR_NONE > "

    echo -e "$TOP_LINE\n$PROMPT"
}

# generate_ps1
# _CUSTOM_PS1="\n\`nonzero_return\`"

# Add host and username
# _CUSTOM_PS1="$_CUSTOM_PS1$LIGHT_GRAY[\u@\h]$NO_COLOUR"

# git branch info if available
# _CUSTOM_PS1="$_CUSTOM_PS1"

# Add details of jobs running and stopped
# _CUSTOM_PS1="$_CUSTOM_PS1\`get_background_job_count\`"
# _CUSTOM_PS1="$_CUSTOM_PS1\`get_load_average\`"

# Versions of popular development tools
# _CUSTOM_PS1="$_CUSTOM_PS1\`get_current_versions\`"

# Current directory
# _CUSTOM_PS1="$_CUSTOM_PS1\n\w\`parse_git_branch\` > "

export PS1="\`generate_ps1\`"
