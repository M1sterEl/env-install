#!/usr/bin/env bash

######################
## useful constants ##
######################

COPY_FILES_DIR="../files"
DEFAULT_CONFIGS_DIR="${HOME}/.config/"


###################
## useful prints ##
###################

ANSI_RED='\033[0;31m'
ANSI_YELLOW='\033[1;33m'
ANSI_CYAN='\033[0;34m'
ANSI_GREEN='\033[0;32m'

ANSI_RESET='\033[0m'

echo_success ()
{
	echo -e "${ANSI_GREEN}success${ANSI_RESET}: $@"
}

echo_info ()
{
	echo -e "${ANSI_CYAN}info${ANSI_RESET}: $@"
}

echo_warning ()
{
	echo -e "${ANSI_YELLOW}warning${ANSI_RESET}: $@"
}

echo_error ()
{
    echo -e "${ANSI_RED}warning${ANSI_RESET}: $@"
}

special_warning_aproval_or_exit ()
{
    message=$1

    # Echos the given warning message to the user.
    echo_warning $message

    # Get user answer.
    read -p "Continue? [Y/n]: " user_answer

    # Exists or continues based on the users input.
    if [ "${user_answer}" == "y" ] || [ "${user_answer}" == "" ]; then
        echo_info "continuing..."
    else
        echo_info "exiting..."
        exit 0
    fi
}

ask_if_to_change_value () # "value name" "default given value"
{
    value_name=$1
    default_given_value=$2

    # Prints the massage given to the function
    read -p "Enter the value for ${value_name} (${default_given_value}):" user_answer

    # If the user entered a value, meaning user_answer is not empty.
    # Echo the given value.
    if [ "${user_answer}" != "" ]; then
        echo $user_answer
    else
        echo $default_given_value
    fi
}
