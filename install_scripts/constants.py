#!/usr/bin/env python3

from  os import getenv
import pathlib

HOME = getenv("HOME")

DEFAULT_CONFIG_DIR = f"{HOME}/.config/"

TOP_PROJECT_DIR = pathlib.Path(__file__).parent.parent
