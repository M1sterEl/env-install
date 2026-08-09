#!/usr/bin/env python3.10

import argparse
import shutil
import pathlib
import subprocess

import src.constants as global_constants
from src.modules.utils import print_success, print_info, print_warning

GIT_FILES_DIR = pathlib.Path(f"{global_constants.DEFAULT_FILES_DIR}")

# Fedora's dnf repos don't carry lazygit, it needs this copr repo enabled first.
LAZYGIT_COPR_REPO = "dejan/lazygit"


# We add the args to maintain the format for the rest of the sub commands default functions.
def copy_custom_gitconfig() -> None:
    """
    Copies a .gitconfig file to the home dir.
    """

    print_info(f"copying .gitconfig to {global_constants.HOME}")

    shutil.copy(f"{GIT_FILES_DIR}/gitconfig", f"{global_constants.HOME}/.gitconfig")

    print_success(f"copied .gitconfig file to {global_constants.HOME}")


def install_lazygit(package_manager: "PackageManager", offline: bool) -> None:
    """
    Installs Lazygit to the environment.

    :param package_manager: The package manager object to use for installing lazygit.
    :param offline:          whether to assume internet connection or not (true; to assume, false; to not assume).
    """

    if offline:
        raise NotImplementedError("offline install of lazygit not supported yet")

    # For fedora machines (and the like), a repo needs to be enabled to be able to install lazygit.
    if package_manager.package_manager == "dnf":
        print_info(f"enabling copr repo {LAZYGIT_COPR_REPO} for lazygit")

        copr_result = subprocess.run(
            ["sudo", "dnf", "copr", "enable", "-y", LAZYGIT_COPR_REPO],
            capture_output=True, text=True,
        )

        if copr_result.returncode:
            print_warning(f"failed to enable {LAZYGIT_COPR_REPO} copr repo, output: {copr_result.stderr}")
            return

    print_info(f"installing lazygit using {package_manager.package_manager}")

    if package_manager.install_packages("lazygit"):
        print_success("installed lazygit to environment")
    else:
        print_warning("didn't install lazygit to environment")


def main(args, package_manager) -> None:
    """
    Copy gitconfig file and install lazyvim based on given os.
    """

    copy_custom_gitconfig()

    install_lazygit(package_manager, args.offline)


def git_parser(subparsers_object: argparse.ArgumentParser.add_subparsers):

    git_parser = subparsers_object.add_parser("git", help=f"copies .gitconfig to '{global_constants.HOME}' or a supplied dir")

    git_parser.add_argument("-o", "--offline",
                             help="install while assuming no internet connection",
                             action="store_true")

    git_parser.set_defaults(func=main)


if __name__ == "__main__":
    pass
