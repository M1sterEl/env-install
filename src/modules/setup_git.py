#!/usr/bin/env python3.10

import argparse
import shutil
import pathlib
import subprocess

import src.constants as global_constants
from src.modules.utils import print_success, print_info, print_success, print_warning

GIT_FILES_DIR = pathlib.Path(f"{global_constants.DEFAULT_FILES_DIR}")


# We add the args to maintain the format for the rest of the sub commands default functions.
def copy_custom_gitconfig() -> None:
    """
    Copies a .gitconfig file to the home dir.
    """

    print_info(f"copying .gitconfig to {global_constants.HOME}")

    shutil.copy(f"{GIT_FILES_DIR}/gitconfig", f"{global_constants.HOME}/.gitconfig")

    print_success(f"copied .gitconfig file to {global_constants.HOME}")


def install_lazygit(target_os: str, offline: bool) -> None:
    """
    Installs Lazygit to the environment.

    :param target_os:   the os we are installing lazygit on.
    :param offline:     whether to assume internet connection or not (true; to assume, false; to not assume).
    """

    print_info(f"installing lazygit using the method for {target_os}")

    if offline:
        raise NotImplementedError("offline install of lazygit not supported yet")

    success = True

    try:
        match target_os:
            case "mac":
                print_info(f"{target_os} was defined as the target os, installing using homebrew")
                subprocess.run(["brew", "install", "lazygit"], capture_output=False)

            case "debian":
                print_info(f"{target_os} was defined as the target os, installing using apt")
                subprocess.run(["sudo", "apt", "install", "lazygit"], capture_output=False)

            case _:
                print_error("unrecognized target os detected, didn't install lazygit")
                success = False
    except:
        success = False

    if success:
        print_success("installed lazygit to environment")

    else:
        print_warning("didn't install lazygit to environment")


def main(args, package_manager) -> None:
    """
    Copy gitconfig file and install lazyvim based on given os.
    """

    copy_custom_gitconfig()

    install_lazygit(args.target_os, args.offline)


def git_parser(subparsers_object: argparse.ArgumentParser.add_subparsers):

    git_parser = subparsers_object.add_parser("git", help=f"copies .gitconfig to '{global_constants.HOME}' or a supplied dir")

    git_parser.add_argument("-o", "--offline",
                             help="install while assuming no internet connection",
                             action="store_true")

    git_parser.set_defaults(func=main)


if __name__ == "__main__":
    pass
