#!/usr/bin/env bash

# Sources useful functions and variables.
source utils.sh

###############
## Functions ##
###############

install_basic_deps ()
{
    echo_info "updating apt"
    sudo apt update

    echo_info "installing basic universal dependencies"

    sudo apt install curl
}

##########
## Main ##
##########

install_basic_deps
