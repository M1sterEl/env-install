#!/usr/bin/env bash

# Sources useful functions and variables.
source utils.sh

###############
## Constants ##
###############

BASIC_DEPS="curl python3-pip"

###############
## Functions ##
###############

install_basic_deps ()
{
    echo_info "updating apt"
    sudo apt update

    echo_info "installing basic universal dependencies: ${BASIC_DEPS}"

    sudo apt install -y $BASIC_DEPS
}

##########
## Main ##
##########

install_basic_deps
