#!/usr/bin/env bash

source utils.sh

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
    echo_info "installing fzf"
    sudo apt install -y fzf
}

install_pip3 ()
{
   echo_info "installing python3-pip" 
   sudo apt install -y python3-pip
}

##########
## Main ##
##########

# The following lines will just install packages, so we run apt update before hand, instead of running it in each function individually.
sudo apt update

# Installs basic packages that are expected to be present.
install_fzf
install_pip3

copy_zshrc

echo_success "finished setting up shell"
