#!/usr/bin/env bash

source utils.sh

###############
## Constants ##
###############

# Packages I  personally like to have when using the terminal.
WANTED_PACKAGES="fzf fd-find"

###############
## Functions ##
###############

copy_zshrc ()
{
    echo_info "copying the zshrc file to the home dir"
    cp $COPY_FILES_DIR/zshrc $HOME/.zshrc
}

install_fzf ()
{
    # Making sure the apt cache is updated.
    sudo apt update

    echo_info "installing wanted packages: ${WANTED_PACKAGES}"
    sudo apt install -y $WANTED_PACKAGES
}

##########
## Main ##
##########

# Installs wanted packages that are nice to have present.
install_wanted_pakcages

copy_zshrc

echo_success "finished setting up shell"
