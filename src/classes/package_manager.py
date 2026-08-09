import subprocess
from ..modules.utils import print_error, print_success

class PackageManager():
    SUPPORTED_PACKAGE_MANAGERS = ["apt", "dnf", "brew"]

    def __init__(self, package_manager: str) -> None:
        """
        :package_manager:   The package manager to use
        """
        if not package_manager in self.SUPPORTED_PACKAGE_MANAGERS:
            raise TypeError(f"Given package manager is not supported: {package_manager}")

        self.package_manager = package_manager

    def _run_command_return_result(self, command: list[str]) -> subprocess.CompletedProcess:
        """
        Runs a command and returns the result object of the command.
        """
        return subprocess.run(command, capture_output=True, text=True)

    def install_packages(self, packages: list[str] | str) -> bool:
        """
        Install one or several packages.
        """
        if not isinstance(packages, (str, list)):
            raise TypeError(f"Expected list or string instead got: {packages} of type: {type(packages)}")

        # Even if we got a string we convert it to a list.
        # Spliting a string of one word will procude a list of 1.
        # Ternary needed: .split() only exists on str, a list has no .split -
        # calling it on a list (e.g. BASIC_DEPS, WANTED_PACKAGES) crashes with
        # AttributeError, so a plain "packages.split()" isn't safe here.
        package_list = packages.split() if isinstance(packages, str) else packages

        base_command = f"sudo {self.package_manager} install -y".split()

        # Brew doesn't require neither sudo or '-y' flag.
        if self.package_manager == "brew":
            del base_command[0]
            del base_command[2]

        # list.extend() mutates base_command in place and returns None, so it
        # can't be assigned directly. `command` is named separately from
        # base_command because it's a distinct concept once packages are in
        # it (the full command to run, vs. the manager/install/-y prefix).
        base_command.extend(package_list)
        command = base_command

        install_result = self._run_command_return_result(command)

        # 0 is success in POSIX exit codes, but falsy in python.
        if install_result.returncode:
            print_error(f"Failed to install package(s): {package_list}")
            print_error(f"Failed install output: {install_result.stderr}")
            return False

        print_success("Package install completed")
        return True

    def update(self) -> bool:
        """
        Update remote repos of the package manager.
        """
        match self.package_manager:
            case "dnf":
                command = f"sudo {self.package_manager} makecache --refresh".split()

            case "apt":
                command = f"sudo {self.package_manager} update".split()

            case "brew":
                command = f"{self.package_manager} update".split()

        update_result = self._run_command_return_result(command)

        # 0 is success in POSIX exit codes, but falsy in python.
        if update_result.returncode:
            print_error(f"Failed to update, output: {update_result.stderr}")
            return False

        print_success(f"{self.package_manager} repo update completed")
        return True
