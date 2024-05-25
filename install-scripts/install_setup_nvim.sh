#!/usr/bin/env bash

source utils.sh

###############
## Constants ##
###############

ONLINE_STRING="online"
OFFLINE_STRING="offline"
OFFLINE_DIR="../offline-dir"

# This is the version of nvim that the script installs.
# This is needed since apt install doesn't install the most updated version of nvim.
# This version is updated manually.
NVIM_VERSION="v0.10.0"
DEFAULT_NVIM_CONFIG_DIR="${HOME}/.config/nvim"
NVIM_FILES_DIR="${COPY_FILES_DIR}/nvim"

OFFLINE_BASH_LSP_TARFILE="${OFFLINE_DIR}/nvim/lsps/bash-lsp.tar"
OFFLINE_PYLSP_DEB_FILE="${OFFLINE_DIR}/nvim/lsps/python3-pylsp_1.7.1-1_all.deb"

# xclip - Allows us to use text copied inside nvim, outside of nvim, and vice verse.
# ripgrep - Allows for recursive search within directories.
# fd-find - Allows to find files recursively, using the telescope plugin.
NEEDED_APTS_FOR_WANTED_BEHAVIOR="xclip ripgrep fd-find"
OFFLINE_APTS_DIR="${OFFLINE_DIR}/nvim/needed-apts"

###############
## Functions ##
###############

install_nvim ()
{
	# Since ubuntu installs an outdated version of nvim, "apt install neovim" won't work, so we need to do it our own way.

	# Creating a temp dir to wget the files to.
	temp_dir=$(mktemp -d)
	echo_info "starting nvim install..."

	# Wget-ing the newest nvim appimage.
	echo_info "getting nvim.appimage version: ${NVIM_VERSION}"
	wget "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage" -P ${temp_dir}

	# This step might fail due to FUSE, then we have a failsafe incase that happens.
	echo_info "adding nvim to path"

	# Copying the nvim binary to the path.
	sudo cp ${temp_dir}/nvim.appimage /usr/bin/nvim
	sudo chmod +x /usr/bin/nvim

	# Removing the temp dir.
	rm -rf ${temp_dir}
}

# Sets up the plugins.lua file with correct absolute paths, that include the correct user name.
# After setting the correct user name, it copies the file to the given NVIM_CONFIG_DIR.
copy_configured_plugins_file ()
{
	# Get the username.
	user=$(whoami)

	echo_info "setting up ${DEFAULT_NVIM_CONFIG_DIR}/plugins.lua for user: ${user}"

	# Create a tmp file to pipe the init.lua file contents after correcting to the correct user.
	tmp_file=$(tempfile)

	# Change to correct user name and pipe to tempfile.
	cat $NVIM_FILES_DIR/plugins.lua | sed --expression "s/user_name_to_replace/${user}/g"  > $tmp_file

	echo_info "creating ${DEFAULT_NVIM_CONFIG_DIR}/lua dir"

	# Create the lua dir in nvim config dir.
	mkdir -p ${DEFAULT_NVIM_CONFIG_DIR}/lua

	echo_info "copying plugins.lua with user: ${user} to ${DEFAULT_NVIM_CONFIG_DIR}/lua/"

	# Copy the tempfile with the updated name to its place.
	cp $tmp_file ${DEFAULT_NVIM_CONFIG_DIR}/lua/plugins.lua

	rm $tmp_file
}

setup_plugins ()
{
	echo_info "creating nvim config dir: ${DEFAULT_NVIM_CONFIG_DIR}"

	# Create the nvim config dir.
	mkdir -p "${DEFAULT_NVIM_CONFIG_DIR}"

	echo_info "updating submodules"

	# The vim plugins are saved as submodules, so we update them to make sure all the files are present.
	git submodule update --init --recursive

	# Copies the plugins.
	echo_info "copying plugins to ${DEFAULT_NVIM_CONFIG_DIR}/plugins"
	cp -r ../nvim-plugins/* ${DEFAULT_NVIM_CONFIG_DIR}/plugins

    # This is needed since other wise the folder are not copied.
    sync

	# We load the submodules from a plugins dir we create in the nvim config dir in order to allow for offline installs.
    # For lazy (the chosen nvim plugin manager for this setup) to correctly load the plugins, no matter where we launch vim, it needs an absolute path.
	# For that we need to dynamically set the username in the plugins.lua file.
	# Change the user name in the plugins.lua file, and copy it to the config nvim dir.
    copy_configured_plugins_file

	echo_success "finished setting up nvim plguins"

}

setup_nvim_prefrences ()
{
    echo_info " installing packages: ${NEEDED_APTS_FOR_WANTED_BEHAVIOR}, for some needed custom behavior"

    # Installs packages for nvim custom wanted behavior.
    sudo apt update
    sudo apt install -y $NEEDED_APTS_FOR_WANTED_BEHAVIOR

    NVIM_CONFIG_DIR=$(ask_if_to_change_value "nvim config dir" $DEFAULT_NVIM_CONFIG_DIR)

	echo_info "copying init.lua to ${NVIM_CONFIG_DIR}"

	cp ${NVIM_FILES_DIR}/init.lua ${NVIM_CONFIG_DIR}/init.lua

	eho_success "copied init.lua"

	echo_info "copying settings.lua and maps.lua ${NVIM_CONFIG_DIR}"

	cp $NVIM_FILES_DIR/settings.lua $NVIM_CONFIG_DIR/lua/settings.lua
	cp $NVIM_FILES_DIR/maps.lua $NVIM_CONFIG_DIR/lua/maps.lua

	echo_success "copied settings.lua and maps.lua"
}

##########
## Main ##
##########

install_nvim
setup_plugins
setup_nvim_prefrences
