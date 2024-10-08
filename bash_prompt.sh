#!/bin/env bash

#Normal colours
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
PURPLE="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
#Light colours
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
LIGHT_YELLOW="\[\033[1;33m\]"
LIGHT_BLUE="\[\033[1;34m\]"
LIGHT_PURPLE="\[\033[1;35m\]"
LIGHT_CYAN="\[\033[1;36m\]"
#0m restores to the terminal's default colour
RESTORE="\[\033[0m\]"

function get_git_branch {
    local branch=$(git branch 2>/dev/null | grep \* | cut -d ' ' -f2)
    if [[ ! -z "$branch" ]]; then
        echo "($branch)"
    fi
}

# Certain WiFi networks I use don't let me connect to the Arch mirrors properly, so I don't want to try and update my system on them
# This function checks for those
check_wifi_network() {
    # Specify the ssids of bad Wi-Fi networks to check against
    source ~/.local/bin/bad_ssids.sh 2>/dev/null || local bad_ssids="(example1|example2)"

    # initialises set_colour to blue, the colour for no connection
    local set_colour="$BLUE"

    # Get the SSID of the connected Wi-Fi network
    local current_ssid=$(iwgetid -r)
    if [[ -z "$current_ssid" ]]; then
        current_ssid="Offline"
    else
        # Check if we are connected to any of the specified Wi-Fi networks

        if echo "$current_ssid" | grep -E "$bad_ssids" > /dev/null; then
            set_colour="$RED"
        else
            #This will only happen if we're connected to a network that isn't on the list
            set_colour="$GREEN"
        fi

    fi

    # Return the values
    echo "$set_colour"
    echo "$current_ssid"
}

function bash_prompt {
    local user="$LIGHT_YELLOW\u$RESTORE"
    local host="$GREEN\h$RESTORE"
    local dir="\w"

    local git_branch=$(get_git_branch)

    local ssid_colour=$(check_wifi_network)
    local colour=$(echo "$ssid_colour" | head -n 1)
    local ssid=$(echo "$ssid_colour" | tail -n 1)


    echo "$colour[$ssid]$RESTORE[$user@$host:$dir$git_branch]\$ "
}

bash_prompt
