#!/usr/bin/env python3.10

import argparse
import shutil
import pathlib

import install_scripts.constants as global_constants
from .utils import print_success, print_info


# We add the args to maintain the format for the rest of the sub commands default functions.
def copy_custom_gitconfig(args) -> None:
    """
    Copies a .gitconfig file to the home dir.
    """

    print_info(f"copying .gitconfig to {global_constants.HOME}")

    shutil.copy(f"{global_constants.DEFUALT_FILES_DIR}/gitconfig", f"{global_constants.HOME}/.gitconfig")

    print_success(f"copied .gitconfig file to {global_constants.HOME}")


def git_config_parser(subparsers_object: argparse.ArgumentParser.add_subparsers):

    git_config_parser = subparsers_object.add_parser("gitconfig", help="copies .gitconfig to the {global_constants.HOME}")

    git_config_parser.set_defaults(func=copy_custom_gitconfig)


if __name__ == "__main__":
    pass
