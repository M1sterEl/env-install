#!/usr/bin/env python3
"""
The file for the main command for installing the wanted environment.
"""
import argparse

from src.install_scripts import nvim_parser, git_parser, basic_deps_parser, omz_parser, rofi_parser, shell_parser
from src.classes import PackageManager
from src import constants as global_constants

parser_list = [nvim_parser, git_parser, basic_deps_parser, omz_parser, rofi_parser, shell_parser]

if __name__ == "__main__":

    main_parser = argparse.ArgumentParser(
                    prog="env-install",
                    )

    action_subparsers = main_parser.add_subparsers(help="what action to do")
    action_subparsers.required = True

    setup_parser = action_subparsers.add_parser("setup",
                                                  help="setup parts/the whole of the environment")

    setup_parser.add_argument("target_os",
                                choices=global_constants.TargetOS._member_names_,
                                help="target system the setup is run on")

    setup_target_subparser = setup_parser.add_subparsers(help="what to setup")

    for parser in parser_list:
        parser(setup_target_subparser)

    build_parser = action_subparsers.add_parser("build",
                                                  help="build supported outputs")

    build_target_subparser = build_parser.add_subparsers(help="what to build", dest="build")


    args = main_parser.parse_args()

    if hasattr(args, "build"):
        raise NotImplementedError("The build command is not implemented yet")

    package_manager = PackageManager(global_constants.TargetOS[f"{args.target_os}"])

    args.func(args, package_manager)
