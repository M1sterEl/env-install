import subprocess
from ..modules.utils import print_error, print_success

class PackageManager():
    SUPPORTED_PACKAGE_MANAGERS = ["apt", "dnf", "brew"]

    def __init__(self, package_manager: str) -> None:
        """
        :package_manager:   The package manager to use
        """
        if not package_manager in SUPPORTED_PACKAGE_MANAGERS:
            raise TypeError(f"Given package manager is not supported: {package_manager}")

        self.pkg_manger = package_manager

    def _run_command_return_result(command: list[str]) -> subprocess.CompletedProcess:
        """
        Runs a command and returns the result object of the command.
        """


    def install_packages(packages: list[str] | str) -> bool:
        """
        Install one or several packages.
        """
        if not isinstance(packages, (str, list)):
            raise TypeError(f"Expected list or string instead got: {packages} of type: {type(packages)}")

        # Even if we got a string we convert it to a list.
        # Spliting a string of one word will procude a list of 1.
        package_list = packages.split()

        base_command = f"sudo {self.package_manager} install -y".split()

        # Brew doesn't require neither sudo or '-y' flag.
        if self.package_manager == "brew":
            del base_command[0]
            del base_command[2]

        command = base_command.extend(package_list)

        install_result = subprocess.run(command, capture_output=True, text=True)

        # 0 is false in python but a success in this case.
        if not install_result.returncode:
            print_error(f"Failed to install package(s): {package_list}")
            print_error(f"Failed install output: {install_result.stderr}")
        else:
            print_success("Package insatll completed")

    def update() -> bool:
        """
        Update remote repos of the package manager.
        """
        match self.package_manager:
            case "dnf":
                command = f"sudo {self.package_manager} makecache --refresh".split()

            case "apt":
                command = f"sudo {self.package_manager} update".split()

            case "brew":
                command = f"brew {self.update}"

        update_result = subprocess.run(command, capture_output=True, text=True)

        # 0 is false in python but a success in this case.
        if not install_result.returncode:
            print_error(f"Failed to update, output: {install_result.stderr}")
        else:
            print_success(f"{self.package_manager} repo update completed")
