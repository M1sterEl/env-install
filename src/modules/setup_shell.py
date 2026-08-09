#!/usr/bin/env python3

import argparse
import shutil
import pathlib
import subprocess
from sys import exit as sysexit

import src.constants as global_constants
from .utils import print_success, print_info

# Packages I personally like to have when using the terminal.
WANTED_PACKAGES = ["fzf", "fd-find"]

# The fzf package installs its zsh keybindings script to a different path per package manager.
FZF_KEYBINDINGS_PATHS = {
    "apt": "/usr/share/doc/fzf/examples/key-bindings.zsh",
    "dnf": "/usr/share/fzf/shell/keys",
}


def copy_zshrc(package_manager: "PackageManager") -> None:
    """
    Copies a .zshrc file to the home dir, with the fzf keybindings path set for the target package manager.
    """

    print_info(f"copying the zshrc file to {global_constants.HOME}")

    zshrc_dest = pathlib.Path(f"{global_constants.HOME}/.zshrc")

    shutil.copy(
        pathlib.Path(f"{global_constants.DEFAULT_FILES_DIR}/zshrc"),
        zshrc_dest,
    )

    fzf_keybindings_path = FZF_KEYBINDINGS_PATHS.get(package_manager.package_manager, FZF_KEYBINDINGS_PATHS["apt"])

    with open(zshrc_dest, "r") as zshrc_file:
        content = zshrc_file.read()

    with open(zshrc_dest, "w") as zshrc_file:
        zshrc_file.write(content.replace("fzf_keybindings_path_to_replace", fzf_keybindings_path))

    print_success(f"copied .zshrc file to {global_constants.HOME}")


def install_wanted_packages(package_manager: PackageManager) -> None:
    """
    Installs wanted packages that are nice to have present.

    :package_manager:    The package manger object to use for installing packages.
    """

    print_info(f"installing wanted packages: {' '.join(WANTED_PACKAGES)}")

    if not package_manager.install_packages(WANTED_PACKAGES):
        # The error printing is handled inside the package_manger.install method.
        sysexit(1)


def main(args, package_manager: "PackageManager") -> None:
    """
    Install wanted packages and copy zshrc file.
    """

    install_wanted_packages(package_manager)

    copy_zshrc(package_manager)

    print_success("finished setting up shell")


def shell_parser(subparsers_object: argparse.ArgumentParser.add_subparsers):

    parser = subparsers_object.add_parser("shell", help="setup shell environment")

    parser.set_defaults(func=main)


if __name__ == "__main__":
    pass
