#!/usr/bin/env bash

# Sources useful functions and variables.
source utils.sh

###############
## Functions ##
###############

copy_custom_gitconfig ()
{
    echo_info "copying .gitconfig to ~/"

    cp ../files/gitconfig ~/.gitconfig

    echo_success "copied the .gitconfig to the home directory"
}

##########
## Main ##
##########

# Assuming that the user is not in an airgapped environment:
# For the user to get this repo, he would have already have had to install git.
# So in other words, there is not need to install git since its already installed,

copy_custom_gitconfig
