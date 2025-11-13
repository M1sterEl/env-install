#!/usr/bin/env python3.10
"""
The file for the main command for installing the wanted environment.
"""
import argparse

from install_scripts import nvim_parser, git_parser

from install_scripts import constants as global_constants


if __name__ == "__main__":

    main_parser = argparse.ArgumentParser(
                    prog="env-install",
                    )

    action_subparsers = main_parser.add_subparsers(help="what action to do")
    action_subparsers.required = True

    setup_parser = action_subparsers.add_parser("setup",
                                                  help="setup parts/the whole of the environment")

    setup_parser.add_argument("target_os",
                                choices=global_constants.SUPPORTED_TARGET_OSS,
                                help="target system the setup is run on")

    setup_target_subparser = setup_parser.add_subparsers(help="what to setup")

    nvim_parser(setup_target_subparser)

    git_parser(setup_target_subparser)

    build_parser = action_subparsers.add_parser("build",
                                                  help="build supported outputs")

    build_target_subparser = build_parser.add_subparsers(help="what to build", dest="build")


    args = main_parser.parse_args()

    if hasattr(args, "build"):
        raise NotImplementedError("The build command is not implemented yet")

    args.func(args)
