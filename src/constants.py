#!/usr/bin/env python3

from enum import Enum

from os import getenv
import pathlib

# Nvim install.
NVIM_VERSION="v0.10.0"

# Host paths.
HOME = getenv("HOME")
DEFAULT_CONFIG_DIR = f"{HOME}/.config/"
TOP_PROJECT_DIR = pathlib.Path(__file__).parent.parent
DEFAULT_FILES_DIR = pathlib.Path(f"{TOP_PROJECT_DIR}/files")

# Target info.
class TargetOS(Enum):
    """
    An enum of the supported intall targets and their corresponding package managers.
    """
    debian = "apt"
    mac = "brew"
    fedora = "dnf"
