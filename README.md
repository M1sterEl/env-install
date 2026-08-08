# ENV-INSTALL
This is a personal project meant to help install a specific work environment.
The project is designed to allow for the environment to be installed in air gapped networks as well as normal networks, though it is more of a best effort then a guarantee.

If you found this randomly then congrats, in any other case then you are probably a friend so welcome, please read the rest.

The project **Currently** sets up, ish (in order of most likely to work):
1. git (and lazygit)
2. nvim
3. shell (oh-my-zsh and custom aliases)
4. rofi
5. i3 (hard to test so might work)


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
This will install lazygit and copy a .gitconfig with pre-defined git aliases.


### Setup nvim
Using the main env-install.py script just run:
```bash
# If you have python3.10 in your path
./env-install.py setup <target_os> nvim

# Or if you don't have python3.10 in your path.
python3 ./env-install.py setup <target_os> nvim

# For more information on the supported flags you can use the -h flag.
```
This will install nvim v0.10.0 as well as set up all the related files (maps, settings and plugins) in the given dir when asked by the script during installation.

All of the plugins are submodules in the repo and are copied to the given dir.

### Nvim Setup explained
This is an explanation of the structure of nvim inside of the given dir path (default is ~/.config/nvim) 

All of the plugin dirs are under the plugins dir.

The init.lua file just loads the plugins file under the lua dir.

Under the lua dir there are 3 files:
1. plugins.lua - This is where all of the plugins are defined, the path to plugins are hard coded to allow for nvim to run anywhere in the system. The **plugin manager for this installation is Lazy**.
2. maps.lua - This is where most of the custom mappings are defined, some mappings need to be defined when defining the settings for their respective plugins and will be located in the `settings.lua` file (at the top file there are comments to say which maps are defined in the `settings.lua` file).
3. settings.lua - This is where all of the settings for some plugins are defined. For example; lspconfig and telescope. Some plugins will contains mappings (as explained in the `maps.lua` entry) and if there are any more mappings in the `maps.lua` it should be mentiond near the relevant plugin.

### Everything Else
Currently the rest of the environment wasn't converted to python (from bash) and is not yet part of the main `env-intstall.py` script.

For other relevant environment setups, look at the *modules* dir for relevant bash scripts for each environment section.

## Air-Gapped network
WIP
