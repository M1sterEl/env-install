#!/usr/bin/env python3

import argparse
import subprocess
import pathlib
import re
from sys import exit as sysexit

from src.install_scripts.utils import print_info, print_success, print_error, ask_if_to_change_value
import src.constants as global_constants


DEFAULT_I3_CONFIG_FILE_PATH = pathlib.Path(f"{global_constants.HOME}/.config/i3/config")


def install_rofi(packge_manager: PackgeManager) -> None:
    """
    Installs rofi using apt.

    :packge_manager:    The package manger object to use for installing packages.
    """

    print_info("installing rofi")

    print_info("updating package manger")
    if not package_manger.update():
        # The error printing is handled inside the package_manger.install method.
        sysexit(1)

    if not package_manger.install("rofi"):
        # The error printing is handled inside the package_manger.install method.
        sysexit(1)

    print_success("installed rofi")


def replace_dmenu_with_rofi(i3_config_file: pathlib.Path) -> None:
    """
    Replaces dmenu_run with rofi in the i3 config file.

    :param i3_config_file:  the path to the i3 config file.
    """

    print_info("changing dmenu_run to rofi in the i3 config file")

    with open(i3_config_file, 'r') as config_file:
        content = config_file.read()
        updated_content = re.sub("dmenu_run", "rofi -show combi", content, flags=re.M)

    if content != updated_content:
        with open(i3_config_file, 'w') as config_file:
            config_file.write(updated_content)

        print_success("replaced 'dmenu_run' with 'rofi -show combi'")

    else:
        print_error("couldn't replace 'dmenu_run' to 'rofi -show combi'")


def main(args, packge_manager: PackgeManager) -> None:

    install_rofi(packge_manager)

    # We set this variable here and not in the top of the file as a constant,
    # since otherwise the user will be asked for the value each time we load this module.
    i3_config_file_path = pathlib.Path(ask_if_to_change_value("default i3 config path", str(DEFAULT_I3_CONFIG_FILE_PATH)))

    replace_dmenu_with_rofi(i3_config_file_path)


def rofi_parser(subparsers_object: argparse.ArgumentParser.add_subparsers):

    rofi_sub_parser = subparsers_object.add_parser("rofi", help="install and setup rofi")

    rofi_sub_parser.set_defaults(func=main)


if __name__ == "__main__":
    pass
