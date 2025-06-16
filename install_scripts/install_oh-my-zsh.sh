#!/usr/bin/env bash

# Sources useful functions and variables.
source utils.sh


###############
## Constants ##
###############

ZSHRC_FILE_PATH="${HOME}/.zshrc"

###############
## Functions ##
###############

install_zsh ()
{
	echo_info "installing zsh"

	sudo apt -y install zsh
	zsh
}


install_oh-my-zsh ()
{
	# ZSH is a pre-requisite for oh-my-zsh
	install_zsh
	echo_info "installing oh-my-zsh (using wget)"

	# Create a temp file to output the installtion script from the wget command.
	omz_install_file="$(tempfile)"

	wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O $omz_install_file

	bash $omz_install_file
}

set_omz_theme ()
{
	sed -i 's/ZSH_THEME=.*/ZSH_THEME="intheloop"/g' $ZSHRC_FILE_PATH
}

##########
## Main ##
##########

install_oh-my-zsh

set_omz_theme
