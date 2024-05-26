#!/usr/bin/env bash

source utils.sh

###############
## Functions ##
###############

install_i3 ()
{
    echo_info "installing i3"

    sudo apt update
    sudo apt install -y i3

    echo_success "installed i3"
}

logout ()
{
    special_warning_aproval_or_exit "In order to switch to i3, the user needs to logout, this action requires user approval to continue"
    gnome-session-quit --no-prompt
}

copy_config_dir ()
{
    echo_info "copying i3 config files to ~/.config/i3"

    cp -RT ../files/i3/ "${HOME}/.config/i3/"

    echo_warning "in order for the bar to show, you must set the right values in ~/.config/i3/custom_bar.sh"
    echo_success "copied i3 config files"
}

install_personal_deps ()
{
    echo_info "installing personal preference dependences: jq"

    # Needed for on the fly workspace naming.
    sudo apt install -y jq
}

##########
## Main ##
##########

install_i3
install_personal_deps
copy_config_dir

# Echos a message letting the user know the setting is done.
# This is done since the next function (logout) will ask the user if he'd like to log out or not so that he can start using i3,
# so we let him know the script is finished and he can log out safely.
echo_sucess "finished installing and setting up i3"

logout
