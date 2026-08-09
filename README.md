# ENV-INSTALL
This is a personal project meant to help install a specific work environment.
The project is designed to allow for the environment to be installed in air gapped networks as well as normal networks, though it is more of a best effort then a guarantee.

If you found this randomly then congrats, in any other case then you are probably a friend so welcome, please read the rest.

The project **Currently** sets up, ish (in order of most likely to work):
1. git (and lazygit)
2. nvim
3. shell (oh-my-zsh and custom aliases)
4. rofi
5. i3 - implemented (`src/modules/setup_install_i3.py`) but **not yet wired into the `env-install.py` CLI**, so it can't be run through `setup <target_os> i3` yet.


# Prerequisites
The project requires python>=3.10, as well as a few non-standard python packages:
- git
- requests

Other, non python, assumed packages:
- brew (for macos only)
- git
- fuse (not for running the setup, but for the installed appimage of nvim runtime to work)

# Usage
Currently there are no releases (though there might be in the future if I will want to fix the pipeline and make it useful). The way to use this is to **clone the repo in a non air-gapped network**, and then follow the appropriate installation instructions.

The supported os' are (other os' might experience technical difficulties):
- macos Tahoe
- debian=13.0
- fedora

## Non Air-Gapped network
This is the easy option. Just clone the repo to the pc you want the environment on, and follow the relevant instructions from the top dir of the repo.

### Setup All
Currently not implemented

### Setup git
Using the main env-install.py script just run:
```bash
# If you have python3.10 in your path
./env-install.py setup <target_os> git

# Or if you don't have python3.10 in your path.
python3 ./env-install.py setup <target_os> git

# For more information on the supported flags you can use the -h flag.
```
This will copy a .gitconfig with pre-defined git aliases to `$HOME`, and install lazygit using the target os' package manager.

The `-o/--offline` flag is accepted but offline lazygit install isn't implemented yet (it raises `NotImplementedError`); the .gitconfig copy itself works the same either way, since it's just a local file copy.

On fedora, lazygit isn't in the default dnf repos, so this first enables the `dejan/lazygit` copr repo (`sudo dnf copr enable -y dejan/lazygit`) before installing.


### Setup nvim
Using the main env-install.py script just run:
```bash
# If you have python3.10 in your path
./env-install.py setup <target_os> nvim

# Or if you don't have python3.10 in your path.
python3 ./env-install.py setup <target_os> nvim

# For more information on the supported flags you can use the -h flag.
```
This will install nvim v0.12.4 as well as set up all the related files (maps, settings and plugins) in the given dir when asked by the script during installation (default `~/.config/nvim`).

All of the plugins are submodules in the repo and are copied to the given dir.

Supported flags:
- `-o/--offline` - install the nvim.appimage from `offline-dir/nvim/nvim.appimage` instead of downloading it, and skip syncing the plugin submodules before copying them (they're copied from whatever `offline-dir/nvim/nvim-plugins` already has checked out).
- `-m/--manually-install-nvim` - skip installing the nvim binary entirely (only the config/plugins are set up).
- `-l/--lsp-install` - not implemented yet, currently raises `NotImplementedError` if passed.

### Nvim Setup explained
This is an explanation of the structure of nvim inside of the given dir path (default is ~/.config/nvim) 

All of the plugin dirs are under the plugins dir.

The init.lua file just loads the plugins file under the lua dir.

Under the lua dir there are 3 files:
1. plugins.lua - This is where all of the plugins are defined, the path to plugins are hard coded to allow for nvim to run anywhere in the system. The **plugin manager for this installation is Lazy**.
2. maps.lua - This is where most of the custom mappings are defined, some mappings need to be defined when defining the settings for their respective plugins and will be located in the `settings.lua` file (at the top file there are comments to say which maps are defined in the `settings.lua` file).
3. settings.lua - This is where all of the settings for some plugins are defined. For example; lspconfig and telescope. Some plugins will contains mappings (as explained in the `maps.lua` entry) and if there are any more mappings in the `maps.lua` it should be mentiond near the relevant plugin.

### Modules
Each subcommand of `env-install.py` is implemented as a module under `src/modules`:
- `__init__.py` - registers each module's argparse subparser so `env-install.py` can dispatch to it.
- `install_basic_deps.py` - updates the package manager and installs universal deps (curl, python3-pip) needed before anything else runs.
- `install_oh_my_zsh.py` - installs zsh and oh-my-zsh.
- `install_setup_nvim.py` - installs the nvim appimage (online or from the offline dir) and copies over the maps/settings/plugins files.
- `setup_git.py` - copies the .gitconfig and installs lazygit.
- `setup_install_i3.py` - installs the i3 window manager and personal deps (e.g. jq for workspace naming).
- `setup_install_rofi.py` - installs rofi and swaps dmenu_run for rofi in the i3 config.
- `setup_shell.py` - copies the .zshrc and installs nice-to-have shell packages (fzf, fd-find).
- `update_submodules.py` - updates all git submodules to the latest commit on their tracked branch.

### Everything Else
i3 (`src/modules/setup_install_i3.py`) is implemented but not wired into the `env-install.py` CLI yet - `i3_parser` isn't in `env-install.py`'s `parser_list`, so `setup <target_os> i3` doesn't exist as a subcommand yet.

## Air-Gapped network
Offline support is partial and best-effort, per-module:

- **nvim**: pass `-o/--offline`. It copies the nvim binary from `offline-dir/nvim/nvim.appimage` and the plugins from `offline-dir/nvim/nvim-plugins` (already-checked-out submodules) instead of downloading/syncing them. So before going air-gapped, make sure submodules are checked out (`./env-install.py update submodules`, or `git clone --recurse-submodules`) on a machine that still has network access, then copy the whole repo (offline-dir included) over.
- **git**: pass `-o/--offline`. The `.gitconfig` copy works fine offline (it's just a local file copy), but lazygit install isn't implemented for offline yet - it raises `NotImplementedError`.
- **basic-deps, omz, rofi, shell**: no offline flag exists yet. They all call the target os' package manager (apt/dnf/brew) directly, so they need a reachable package repo (real network, or a local mirror you set up yourself) - this repo doesn't vendor any `.deb`/`.rpm` packages for them.

`offline-dir/nvim/needed-apts` and `offline-dir/nvim/lsps` exist in the repo but aren't referenced anywhere in `src/` yet - they are reserved for the not-yet-implemented `-l/--lsp-install` nvim flag.
