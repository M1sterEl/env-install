#!/usr/bin/env bash

ANSI_RED='\033[0;31m'
ANSI_ORANGE='\033[0;33m'
ANSI_CYAN='\033[0;34m'

ANSI_RESET='\033[0m'


echo_info ()
{
	echo -e "${ANSI_CYAN}info${ANSI_RESET}: $@"
}

echo_warning ()
{
	echo -e "${ANSI_ORAGNE}warning${ANSI_RESET}: $@"
}

echo_erro ()
{
    echo -e "${ANSI_ORAGNE}warning${ANSI_RESET}: $@"
}
