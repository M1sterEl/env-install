#!/usr/bin/env python3
"""
The file for the main command for installing the wanted environment.
"""
import argparse

if __name__ == "__main__":

    parser = argparse.ArgumentParser(
                    prog="env-install",
                    )

    subparsers = parser.add_subparsers(help="what to install")
    subparsers.required = True

