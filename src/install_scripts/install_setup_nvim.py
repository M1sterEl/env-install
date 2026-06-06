#!/usr/bin/env python3
import argparse
import git
import shutil
import pathlib
import re

from src.install_scripts.utils import get_from_url, ask_if_to_change_value, print_info, print_success
import src.constants as global_constants


NVIM_APPIMAGE_URL = f"https://github.com/neovim/neovim/releases/download/{global_constants.NVIM_VERSION}/nvim.appimage"

HOST_NVIM_PATH_LOCATION = pathlib.Path("/usr/bin/nvim")

# These are the folders located in the project dir, not the one in the host system.
# They are used to copy configurations from.
NVIM_OFFLINE_DIR = pathlib.Path(f"{global_constants.TOP_PROJECT_DIR}/offline-dir/nvim")
NVIM_OFFLINE_APPIMAGE_LOCATION = pathlib.Path(f"{NVIM_OFFLINE_DIR}/nvim.appimage")
NVIM_PLUGINS_DIR = pathlib.Path(f"{NVIM_OFFLINE_DIR}/nvim-plugins")
NVIM_FILES_DIR = pathlib.Path(f"{global_constants.DEFAULT_FILES_DIR}/nvim")


def install_nvim_appimage(offline_mode: bool = False) -> None:
    """
    Install the nvim binary using online sources.
    Since some package managers install an outdated version of nvim, we use the nvim source site.
    In offline mode, then it just uses the packaged binary.

    :param offline_mode:    whether to install using online sources or copy the package binary.
    """

    if offline_mode:
        print_info("getting nvim.appimage using offline mode")

        shutil.copy(NVIM_OFFLINE_APPIMAGE_LOCATION, HOST_NVIM_PATH_LOCATION)

    else:
        print_info(f"getting nvim.appimage version: {global_constants.NVIM_VERSION} using online mode")
        nvim_appimage_bin_response = get_from_url(NVIM_APPIMAGE_URL)

        with open(HOST_NVIM_PATH_LOCATION, 'wb') as nvim_bin_file:
            nvim_bin_file.write(nvim_appimage_bin_response)

    HOST_NVIM_PATH_LOCATION.chmod(111)

    print_success("installed nvim app image")


def install_nvim_plugins(host_nvim_config_path: pathlib.Path, offline_mode: bool = False) -> None:
    """
    Locally installs nvim plugins.

    :param offline:             True don't sync submodules before installing, False sync submodules.
    :param host_nvim_config_path:    the config path in the host for nvim configurations.
    """

    # If we aren't in offline mode then we will want to make sure all of the plugin submodules are up to date.
    # If we are in offline mode then we couldn't update them even if we wanted.
    if not offline_mode:
        print_info("updating plugins submodules")

        repo = git.Repo(global_constants.TOP_PROJECT_DIR)
        repo.git.submodule("update", "--init", "--recursive")

        print_success("updated submodules")

    # Gets the name of all the plugins submodules.
    plugin_dirs = [directory for directory in NVIM_PLUGINS_DIR.iterdir() if directory.is_dir()]

    # Sets up the folders in the host system.
    host_nvim_config_plugins_dir = host_nvim_config_path / "plugins"
    host_nvim_config_plugins_dir.mkdir(exist_ok=True)

    print_info(f"copying plugins from {NVIM_PLUGINS_DIR} to {host_nvim_config_plugins_dir}")

    # Copy all plugin in the offline-dir to the correct location.
    for plugin_dir in plugin_dirs:
        plugin_dest = host_nvim_config_plugins_dir / plugin_dir.name
        shutil.copytree(plugin_dir, plugin_dest, dirs_exist_ok=True)

    print_success(f"copied all the plugins to {host_nvim_config_path}")


def copy_lua_configs(host_nvim_config_path: pathlib.Path):
    """
    Copies the lua configs to the relevant nvim config dir.
    """

    print_info("copying lua config files")

    # We copy the init.lua here, since this is where it's needs to be.
    # We don't copy it later with the rest of the files.
    shutil.copy(f"{NVIM_FILES_DIR}/init.lua", f"{host_nvim_config_path}")

    print_success(f"copied init.lua to {host_nvim_config_path}")

    host_lua_config_dir = host_nvim_config_path / "lua"

    host_lua_config_dir.mkdir(exist_ok=True)

    print_info(f"copying the rest of the lua config files from {NVIM_FILES_DIR} to {host_lua_config_dir}")

    for file in NVIM_FILES_DIR.iterdir():
        # TODO: a bit of a magic name.
        # We don't need to copy the init.lua file, since it needs to exist the top config directory.
        if file.name != "init.lua":
            shutil.copy(f"{NVIM_FILES_DIR}/{file.name}", f"{host_lua_config_dir}")

    print_success(f"copied lua config files to {host_lua_config_dir}")


def setup_plugins_path(host_nvim_config_path: pathlib.Path) -> None:
    """
    Sets up the nvim config path for the plugins' paths in the plugins.lua file.

    :param host_nvim_config_path:    the config path in the host for nvim configurations.
    """

    plugins_file_path = host_nvim_config_path / "lua/plugins.lua"

    print_info(f"updating path in the plugins file ({plugins_file_path}) to {host_nvim_config_path}")

    with open(plugins_file_path, 'r') as plugins_file:
        content = plugins_file.read()
        updated_content = re.sub("nvim_path_to_replace", f"{host_nvim_config_path}", content, flags = re.M)

    with open(plugins_file_path, "w") as plugins_file:
        plugins_file.write(updated_content)

    print_success("updated plugins file")


def main(args):

    # If the user specified he will manually install nvim later.
    if not args.manually_install_nvim:
        install_nvim_appimage(args.offline)

    # We set this variable here and not in the top of the file as a constant,
    # since otherwise the user will be asked for the value each time we load this module.
    # Which will result in the value question appearing each time we run any cli command.
    host_nvim_config_dir = pathlib.Path(ask_if_to_change_value("default config path for nvim", f"{global_constants.DEFAULT_CONFIG_DIR}nvim"))

    host_nvim_config_dir.mkdir(exist_ok=True)

    install_nvim_plugins(host_nvim_config_dir, args.offline)

    # No offline options, since we literally only need files in the repo.
    copy_lua_configs(host_nvim_config_dir)

    # Since we want the plugins path in the plugins.lua to be absolute and local.
    # And since we allow the user to configure the path.
    # We need to set the configured path in the file itself.
    setup_plugins_path(host_nvim_config_dir)

    if args.lsp_install:
        raise NotImplementedError("lsp install is not implented yet")


def nvim_parser(subparsers_object: argparse.ArgumentParser.add_subparsers):

    nvim_parser = subparsers_object.add_parser("nvim", help="install nvim")

    nvim_parser.add_argument("-o", "--offline",
                             help="install while assuming no internet connection",
                             action="store_true")

    nvim_parser.add_argument("-l", "--lsp-install",
                             help="installs pre-determined lsps (NOT IMPLEMNTED YET)",
                             action="store_true")

    nvim_parser.add_argument("-m", "--manually-install-nvim",
                             help="don't install the nvim appimage, it will be installed later",
                             action="store_true")

    nvim_parser.set_defaults(func=main)


if __name__ == "__main__":
    pass
