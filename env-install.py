#!/usr/bin/env python3.10
"""
The file for the main command for installing the wanted environment.
"""
import argparse
from install_scripts.install_setup_nvim import nvim_parser

if __name__ == "__main__":

    main_parser = argparse.ArgumentParser(
                    prog="env-install",
                    )

    subparsers = main_parser.add_subparsers(help="what to install")
    subparsers.required = True


    nvim_parser(subparsers)

    args = main_parser.parse_args()
    args.func(args)
