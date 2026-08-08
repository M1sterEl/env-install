#!/usr/bin/env python3

import argparse
import shutil
import pathlib
import subprocess

import src.constants as global_constants
from .utils import print_success, print_info

# Packages I personally like to have when using the terminal.
WANTED_PACKAGES = ["fzf", "fd-find"]


def copy_zshrc() -> None:
    """
    Copies a .zshrc file to the home dir.
    """

    print_info(f"copying the zshrc file to {global_constants.HOME}")

    shutil.copy(
        pathlib.Path(f"{global_constants.DEFAULT_FILES_DIR}/zshrc"),
        pathlib.Path(f"{global_constants.HOME}/.zshrc"),
    )

    print_success(f"copied .zshrc file to {global_constants.HOME}")


def install_wanted_packages(packge_manager: PackgeManager) -> None:
    """
    Installs wanted packages that are nice to have present.

    :packge_manager:    The package manger object to use for installing packages.
    """

    print_info(f"installing wanted packages: {' '.join(WANTED_PACKAGES)}")

    if not packge_manager.install(WANTED_PACKAGES):
        # The error printing is handled inside the package_manger.install method.
        sysexit(1)


def main(args, packge_manager: PackgeManager) -> None:
    """
    Install wanted packages and copy zshrc file.
    """

    install_wanted_packages(packge_manager)

    copy_zshrc()

    print_success("finished setting up shell")


def shell_parser(subparsers_object: argparse.ArgumentParser.add_subparsers):

    parser = subparsers_object.add_parser("shell", help="setup shell environment")

    parser.set_defaults(func=main)


if __name__ == "__main__":
    pass
