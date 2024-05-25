#!/usr/bin/env bash

######################
## useful constants ##
######################

COPY_FILES_DIR="../files"


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
    echo_warning $1
    read -p "Continue? [Y/n]: " user_answer
    if [ "${user_answer}" == "y" ] || [ "${user_answer}" == "" ]; then
        echo_info "continuing..."
    else
        echo_info "exiting..."
        exit 0
    fi
}
