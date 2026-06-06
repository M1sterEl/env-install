#!/usr/bin/env python3
import argparse
import subprocess
import pathlib
import tempfile
import re
from sys import exit as sysexit

from src.install_scripts.utils import get_from_url, print_info, print_success, print_error
import src.constants as global_constants


###############
## Constants ##
###############

ZSHRC_FILE_PATH = pathlib.Path(f"{global_constants.HOME}/.zshrc")

OMZ_INSTALL_SCRIPT_URL = "https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh"


###############
## Functions ##
###############

def install_zsh(packge_manager: PackgeManager) -> None:
    """
    Installs zsh using dnf.

    :packge_manager:    The package manger object to use for installing packages.
    """

    print_info("installing zsh")

    if not packge_manager.install("zsh"):
        # The error printing is handled inside the package_manger.install method.
        sysexit(1)


def install_oh_my_zsh(packge_manager: PackgeManager) -> None:
    """
    Installs oh-my-zsh by first installing zsh, then downloading and running
    the oh-my-zsh install script.

    :packge_manager:    The package manger object to use for installing packages.
    """

    # ZSH is a pre-requisite for oh-my-zsh.
    install_zsh(packge_manager)

    print_info("installing oh-my-zsh (using wget)")

    # Download the install script content using requests.
    omz_install_script_content = get_from_url(OMZ_INSTALL_SCRIPT_URL)

    # Create a temp file to output the installation script.
    with tempfile.NamedTemporaryFile(mode='wb', delete=False, suffix=".sh") as omz_install_file:
        omz_install_file.write(omz_install_script_content)
        omz_install_file_path = omz_install_file.name

    subprocess_result = subprocess.run(["bash", omz_install_file_path], capture_output=False)

    # Return code of 0 is a success.
    if not int(subprocess_result.returncode):
        print_success("installed oh-my-zsh")

    else:
        print_error("oh-my-zsh failed to install")


def set_omz_theme() -> None:
    """
    Sets the oh-my-zsh theme to 'intheloop' in the .zshrc file.
    """

    print_info("setting oh-my-zsh theme to 'intheloop'")

    with open(ZSHRC_FILE_PATH, 'r') as zshrc_file:
        content = zshrc_file.read()
        updated_content = re.sub(r'ZSH_THEME=.*', 'ZSH_THEME="intheloop"', content, flags=re.M)

    with open(ZSHRC_FILE_PATH, 'w') as zshrc_file:
        zshrc_file.write(updated_content)

    print_success("set oh-my-zsh theme")


##########
## Main ##
##########

def main(args, packge_manager: PackgeManager) -> None:

    install_oh_my_zsh(packge_manager)

    set_omz_theme()


def omz_parser(subparsers_object: argparse.ArgumentParser.add_subparsers):

    omz_parser = subparsers_object.add_parser("omz", help="install oh-my-zsh")

    omz_parser.set_defaults(func=main)


if __name__ == "__main__":
    pass
