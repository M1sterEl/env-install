#!/usr/bin/env python3

import argparse
import subprocess
from sys import exit as sysexit

from src.modules.utils import print_info, print_success
import src.constants as global_constants


###############
## Constants ##
###############

BASIC_DEPS = ["curl", "python3-pip"]

###############
## Functions ##
###############


def install_basic_deps(packge_manager: PackgeManager) -> None:
    """
    Updates apt and installs basic universal dependencies.

    :packge_manager:    The package manger object to use for installing packages.
    """

    print_info("updating package manger")
    if not package_manger.update():
        # The error printing is handled inside the package_manger.install method.
        sysexit(1)

    print_info(f"installing basic universal dependencies: {' '.join(BASIC_DEPS)}")
    if not package_manger.install_packages(BASIC_DEPS):
        # The error printing is handled inside the package_manger.install method.
        sysexit(1)

    print_success("installed basic dependencies")


##########
## Main ##
##########


def main(args, packge_manager: PackgeManager) -> None:

    install_basic_deps(packge_manager)


def basic_deps_parser(subparsers_object: argparse.ArgumentParser.add_subparsers):

    basic_deps_parser = subparsers_object.add_parser("basic-deps", help="install basic universal dependencies")

    basic_deps_parser.set_defaults(func=main)


if __name__ == "__main__":
    pass
