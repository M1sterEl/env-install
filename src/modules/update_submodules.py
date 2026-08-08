#!/usr/bin/env python3

import argparse

import git

import src.constants as global_constants
from src.modules.utils import print_info, print_success


def main(args) -> None:
    """
    Updates all submodules to the latest commit on their tracked branch (main/master).
    """

    print_info("updating submodules to their main branch")

    repo = git.Repo(global_constants.TOP_PROJECT_DIR)
    repo.git.submodule("update", "--init", "--recursive", "--remote", "--merge")

    print_success("updated submodules to their main branch")


def submodules_parser(subparsers_object: argparse.ArgumentParser.add_subparsers):

    submodules_parser = subparsers_object.add_parser("submodules", help="update submodules to their main branch")

    submodules_parser.set_defaults(func=main)


if __name__ == "__main__":
    pass
