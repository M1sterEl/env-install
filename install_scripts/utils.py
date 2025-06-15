#!/usr/bin/env python3

<<<<<<< HEAD:install_scripts/utils.py
import requests
from typing import Any
=======
>>>>>>> 68e31ac (Converted the utils.sh file from bash to python.):install-scripts/utils.py

ANSI_CLEAR  = '\033[0m'
PINK        = '\033[95m'
BLUE        = '\033[94m'
CYAN        = '\033[96m'
GREEN       = '\033[92m'
YELLOW      = '\033[93m'
RED         = '\033[91m'
BOLD        = "\033[1m"
UNDERLINE   = '\033[4m'


def print_success(info: str) -> None:
    print(f"{GREEN}Success{ANSI_CLEAR}: {info}")


def print_error(info: str) -> None:
    print(f"{RED}Error{ANSI_CLEAR}: {info}")


def print_warning(info: str) -> None:
    print(f"{YELLOW}Warning{ANSI_CLEAR}: {info}")


def print_info(info: str) -> None:
    print(f"{BLUE}Info{ANSI_CLEAR}: {info}")


def special_warning_aproval_or_exit(message: str) -> bool:
    """
    Print a message to the user, and gets his approval or denial.

    :param message: the message to display the user.

    :retrun bool:   True if the user approved, False if the user denied.
    """

    user_agreed_options = ["y", "Y"]
    user_disagreed_options = ["n"]

    possible_user_input_options = user_agreed_options + user_disagreed_options

    print_warning(message)

    # To allow for future changes to the user_agreed_options, we set the default value returned as the first agree value.
    # Whatever it might be.
    user_input = input("Continue? [Y/n]: ") or user_agreed_options[0]

    while user_input not in possible_user_input_options:
        print_warning("unrecognized option received, please try again")
        user_input = input("Continue? [Y/n]: ")

    if user_input in user_disagreed_options:
        return True

    elif user_input in user_disagreed_options:
        return False

    # Since we validate the input before hand, we should never get here, so we raise an exception.
    else:
        raise RuntimeError("error in parsing user input")


def ask_if_to_change_value(value_name: str, default_given_value: str) -> str:
    """
    Print a value name and it's value to the user and let him change the value if he wants to.

    :param value_name:          the name of the value that we ask the user if he wants to change.
    :param default_given_value: the current/default value of the value that we ask the user if he wants to change.

    :return str:                the value agreed upon by the user, whether its the default value, or the new one given the user.
    """

    message_fstring = f"{BOLD}Enter value for {value_name} ({default_given_value}):{ANSI_CLEAR} "

    return input(message_fstring) or default_given_value
<<<<<<< HEAD:install_scripts/utils.py


def get_from_url(url: str) -> Any:
    """
    Get and return the response from a given url.

    :param url:     the url we want to get data from.

    :return Any:    since we can't know the data type we would receive, we could return anything.
    """

    return requests.get(url).content
=======
>>>>>>> 68e31ac (Converted the utils.sh file from bash to python.):install-scripts/utils.py
