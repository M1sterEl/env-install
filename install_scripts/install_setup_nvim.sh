#!/usr/bin/env bash

source utils.sh

###############
## Constants ##
###############

ONLINE_STRING="online"
OFFLINE_STRING="offline"
# A relative path since the script expects the user to be run from the scripts dir.
OFFLINE_DIR="../offline-dir"

# This is the version of nvim that the script installs.
# This is needed since apt install doesn't install the most updated version of nvim.
# This version is updated manually.
NVIM_VERSION="v0.10.0"

OFFLINE_NVIM_APT_IMAGE_LOCATION="${OFFLINE_DIR}/nvim/nvim.appimage"
NVIM_PLUGINS_DIR="../offline-dir/nvim/nvim-plugins"
DEFAULT_NVIM_CONFIG_DIR="${HOME}/.config/nvim"
# Make sure the default nvim config dir is to the user liking, if not, then the user can set it.
NVIM_CONFIG_DIR=$(ask_if_to_change_value "nvim config dir" $DEFAULT_NVIM_CONFIG_DIR)
NVIM_FILES_DIR="${COPY_FILES_DIR}/nvim"

OFFLINE_BASH_LSP_TARFILE="${OFFLINE_DIR}/nvim/lsps/bash-lsp.tar"
OFFLINE_PYLSP_DEB_FILE="${OFFLINE_DIR}/nvim/lsps/python3-pylsp_1.7.1-1_all.deb"

# xclip - Allows us to use text copied inside nvim, outside of nvim, and vice verse.
# ripgrep - Allows for recursive search within directories.
# fd-find - Allows to find files recursively, using the telescope plugin.
NEEDED_APTS_FOR_WANTED_BEHAVIOR="xclip ripgrep fd-find"
OFFLINE_APTS_DIR="${OFFLINE_DIR}/nvim/needed-apts"


######################
## Helper Functions ##
######################

print_usage ()
{
    echo_error "USAGE: ${0} [-o]"
}

######################
## Script Functions ##
######################

# Works in either online or offline mode,
# In online mode, installs the given version of nvim using wget to get the nvim appimage.
# In offline mode, gets a pre-downloaded appimage from the offline dir.
# Args: mode.
install_nvim ()
{
    # Gets the mode to run the function as.
    mode=$1

	# Since apt installs an outdated version of nvim, "apt install neovim" will get us an outdated verions of neovim, so we bypass this using wget.

	# Creating a temp dir to wget the files to.
	temp_dir=$(mktemp -d)
	echo_info "starting nvim install in ${mode} mode"

    # Checks what mode the function is expected to run in.
    # If online mode was given, then it wgets the nvim binary with the pre-set version from github.
    if [[ "${mode}" == "${ONLINE_STRING}" ]]; then
        # Wget-ing the set version nvim appimage.
        echo_info "getting nvim.appimage version: ${NVIM_VERSION}"
        wget "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage" -P ${temp_dir}

    # If offline mode was given, then it copies a pre-downloaded binary of nvim to the $PATH.
    elif [[ "${mode}" == "${OFFLINE_STRING}" ]]; then
        echo_info "assuming and using pre-downloaded nvim.appimage for version ${NVIM_VERSION}"
        cp $OFFLINE_NVIM_APT_IMAGE_LOCATION ${temp_dir}

    # If an unsupported mode string was given, then it throws an error.
    else
        echo_error "unrecognized mode detected, exiting"
        exit 1
    fi

	# This step might fail due to FUSE, so we have a temp dir as a failsafe incase that happens.
	echo_info "adding nvim to path"

	# Copying the nvim binary to the environment PATH.
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

	echo_info "setting up ${NVIM_CONFIG_DIR}/plugins.lua for user: ${user}"

	# Create a tmp file to pipe the init.lua file contents after correcting to the correct user.
	tmp_file=$(mktemp)

	# Change to correct user name and pipe to tempfile.
	cat $NVIM_FILES_DIR/plugins.lua | sed --expression "s/user_name_to_replace/${user}/g"  > $tmp_file

	echo_info "creating ${NVIM_CONFIG_DIR}/lua dir"

	# Create the lua dir in nvim config dir.
	mkdir -p ${DEFAULT_NVIM_CONFIG_DIR}/lua

	echo_info "copying plugins.lua with user: ${user} to ${DEFAULT_NVIM_CONFIG_DIR}/lua/"

	# Copy the tempfile with the updated name to its place.
	cp $tmp_file ${NVIM_CONFIG_DIR}/lua/plugins.lua

	rm $tmp_file
}

# Copies the nvim plugins and plugins.lua file to the nvim config dir,
# Args: mode.
setup_plugins ()
{
    # gets the mode to run the function as.
    mode=$1

	echo_info "creating nvim config dir: ${NVIM_CONFIG_DIR}"

	# Create the nvim config dir.
	mkdir -p "${NVIM_CONFIG_DIR}"

    # Checks if we are online, if so then syncs the plugins.
    # If we are offline then just assume the plugins are present.
    if [[ "${mode}" == "${ONLINE_STRING}" ]]; then
        echo_info "updating submodules"
        # The vim plugins are saved as submodules, so we update them to make sure all the files are present.
        git submodule update --init --recursive
    fi

	# Copies the plugins.
	echo_info "copying plugins to ${NVIM_CONFIG_DIR}/plugins"
	cp -r "${NVIM_PLUGINS_DIR}/*" "${NVIM_CONFIG_DIR}/plugins"

    # This is needed since other wise the plugins folders are not copied.
    sync

	# We load the submodules from a plugins dir we create in the nvim config dir in order to allow for offline installs.
    # For lazy (the chosen nvim plugin manager for this setup) to correctly load the plugins, no matter where we launch vim, it needs an absolute path.
	# For that we need to dynamically set the username in the plugins.lua file.
	# Change the user name in the plugins.lua file, and copy it to the config nvim dir.
    copy_configured_plugins_file

	echo_success "finished setting up nvim plguins"
}

# Installs the wanted lsps.
# In online mode, just installs them.
# In offline mode installs them using pre-downloaded files.
# Args: mode.
install_lsps ()
{
    # The lsp settings for nvim are already written in the files copied in the 'setup_nvim_prefrences' function.

    # Gets the mode to run the function as.
    mode=$1

    # In an online setting the bash-language-server will be installed using npm.
    # This is the default dir where npm installs packages.
    bash_language_server_dest="/usr/local/lib/node_modules"

    if [[ "${mode}" == "${OFFLINE_STRING}" ]]; then
        echo_info "running in offline mode, assuming and using pre downloaded lsp packages"

        echo_info "installing the bash-language-server"
        echo_info "extarcting ${OFFLINE_BASH_LSP_TARFILE} to ${bash_language_server_dest}"

        # Install the bash-language-server lsp.
        # Untar the bash-language-server folder to the its destination.
        tar -C "${bash_language_server_dest}" -xvf "${OFFLINE_BASH_LSP_TARFILE}"

        echo_success "installed the bash-language-server"

        echo_info "installing python3-pylsp"

        sudo dpkg -i "${OFFLINE_PYLSP_DEB_FILE}"

        echo_success "installed python3-pylsp"

        return 0

    elif [[ "${mode}" == "${ONLINE_STRING}" ]]; then

        sudo apt update

        # Some lsps require npm to be installed.
        sudo apt install --no-install-recommends npm

        # Install an lsp server for bash.
        sudo npm i -g bash-language-server

        # Install an lsp server for python.
        sudo apt install -y python3-pylsp

        echo_success "installed lsps"

    else
        echo_error "unrecognized mode detected, exiting"
        exit 1
    fi
}

# Installs some packages needed for wanted behavior, as well as copies the settings.lua and maps.lua files to the nvim config dir.
# Args: mode.
setup_nvim_prefrences ()
{
    # Gets the mode to run the function as.
    mode=$1
    echo_info " installing packages: ${NEEDED_APTS_FOR_WANTED_BEHAVIOR}, for some needed custom behavior"

    if [[ "${mode}" == "${OFFLINE_STRING}" ]]; then
        for deb_file in ${OFFLINE_APTS_DIR}/*; do
            sudo dpkg -i "${deb_file}"
        done

    elif [[ "${mode}" == "${ONLINE_STRING}" ]]; then
        # Installs packages for nvim custom wanted behavior.
        sudo apt update
        sudo apt install -y $NEEDED_APTS_FOR_WANTED_BEHAVIOR
    fi

	echo_info "copying init.lua to ${NVIM_CONFIG_DIR}"

	cp ${NVIM_FILES_DIR}/init.lua ${NVIM_CONFIG_DIR}/init.lua

	eho_success "copied init.lua"

	echo_info "copying settings.lua and maps.lua ${NVIM_CONFIG_DIR}"

    # Copies the settings and maps file for nvim, to the lua dir inside the set nvim config dir.
	cp $NVIM_FILES_DIR/settings.lua $NVIM_CONFIG_DIR/lua/settings.lua
	cp $NVIM_FILES_DIR/maps.lua $NVIM_CONFIG_DIR/lua/maps.lua

	echo_success "copied settings.lua and maps.lua"
}

##########
## Main ##
##########

# This variable will be passed to relevant function to let them know if they should run in offline mode or not.
# We initialize the mode as online, since we assume we are online unless told otherwise.
offline_arg="${ONLINE_STRING}"

while getopts :o flag
do
    case "${flag}" in
        o) offline_arg="${OFFLINE_STRING}"  ;;
        ?) print_usage && exit 1            ;;
    esac
done

# Installs the updated verions of neovim, since apt install doesn't contain the updated version.
install_nvim $offline_arg

# Creates the nvim config dir, copies the plugins, copies the plugins.lua file with correct user name in its absolute paths.
setup_plugins $offline_arg

# Installs wanted commonly used lsps.
install_lsps $offline_arg

# Installs some apts needed for wanted behavior and copies the init.lua and settings.lua files.
setup_nvim_prefrences $offline_arg

echo_success "finished installing and setting up neovim"
