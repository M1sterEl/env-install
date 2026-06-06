#!/usr/bin/env python3

import argparse
import subprocess
import shutil
import pathlib
from sys import exit as sysexit

from src.install_scripts.utils import print_info, print_success, print_warning, special_warning_aproval_or_exit
import src.constants as global_constants

I3_FILES_DIR = pathlib.Path(f"{global_constants.DEFAULT_FILES_DIR}/i3")
I3_CONFIG_DIR = pathlib.Path(f"{global_constants.DEFAULT_CONFIG_DIR}i3")


def install_i3(packge_manager: PackgeManager) -> None:
    """
    Installs i3 window manager via apt.

    :packge_manager:    The package manger object to use for installing packages.
    """

    print_info("installing i3")

    print_info("updating package manger")
    if not package_manger.update():
        # The error printing is handled inside the package_manger.install method.
        sysexit(1)

    if not package_manger.install("i3"):
        # The error printing is handled inside the package_manger.install method.
        sysexit(1)

    print_success("installed i3")


def install_personal_deps() -> None:
    """
    Installs personal preference dependencies (jq for on the fly workspace naming).
    """

    print_info("installing personal preference dependences: jq")

    # Needed for on the fly workspace naming.
    if not package_manger.install("jq"):
        # The error printing is handled inside the package_manger.install method.
        sysexit(1)

    print_success("installed personal preference dependences")


def copy_config_dir() -> None:
    """
    Copies i3 config files from the project files directory to ~/.config/i3.
    """

    print_info("copying i3 config files to ~/.config/i3")

    shutil.copytree(I3_FILES_DIR, I3_CONFIG_DIR, dirs_exist_ok=True)

    print_warning("in order for the bar to show, you must set the right values in ~/.config/i3/custom_bar.sh")
    print_success("copied i3 config files")


def logout() -> None:
    """
    Prompts the user for approval before logging out of the current gnome session.
    """

    user_disagreed = special_warning_aproval_or_exit(
        "In order to switch to i3, the user needs to logout, this action requires user approval to continue"
    )

    if user_disagreed:
        sysexit(0)

    subprocess.run(["gnome-session-quit", "--no-prompt"], capture_output=False)


def main(args, packge_manager: PackgeManager) -> None:

    install_i3(packge_manager)
    install_personal_deps()
    copy_config_dir()

    print_success("finished installing and setting up i3")

    logout()


def i3_parser(subparsers_object: argparse.ArgumentParser.add_subparsers):

    i3_sub_parser = subparsers_object.add_parser("i3", help="install and setup i3")

    i3_sub_parser.set_defaults(func=main)


if __name__ == "__main__":
    pass
