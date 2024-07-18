#!/usr/bin/env bash

source utils.sh


###############
## constants ##
###############

DEFAULT_I3_CONFIG_FILE_PATH="${HOME}/.config/i3/config"

###############
## Functions ##
###############

install_rofi ()
{
    echo_info "installing rofi"

    sudo apt update
    sudo apt install -y rofi

    echo_success "installed i3"
}

replace_dmenu_with_rofi () # i3_config_file
{
    # Argument assignment.
    i3_config_file=$1

    echo_info "changing dmenu_run to rofi in the i3 config file"

    # Replace the demun_run with rofi in the i3 config file.
    sed -i 's/dmenu_run/rofi -show combi/' $i3_config_file

    if [[ $? ]]; then
        echo_success "replaced 'dmenu_run' with 'rofi -show combi'"

    else
        echo_error "couldn't replace 'dmenu_run' to 'rofi -show combi'"
    fi
}

##########
## Main ##
##########

install_rofi 

# Asks the user for the default config
i3_config_file_path=$(ask_if_to_change_value "default i3 config path" $DEFAULT_I3_CONFIG_FILE_PATH)

replace_dmenu_with_rofi $i3_config_file_path
