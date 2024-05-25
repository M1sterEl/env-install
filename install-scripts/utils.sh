#!/usr/bin/env bash

ANSI_RED='\033[0;31m'
ANSI_YELLOW='\033[1;33m'
ANSI_CYAN='\033[0;34m'

ANSI_RESET='\033[0m'

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
