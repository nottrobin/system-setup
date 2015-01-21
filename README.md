System setup
===

These are files to setup my Ubuntu system, including:

- setup-system.sh - Prompt to install software and install system-wide and user config
- setup-user-config.sh - Link user config files from this directory
- remove-user-config.sh - Unlink user config files from this directory
- .bash_functions.sh - a collection of useful functions for setting up my bash shell
- .bashrc - setup the bash shell, by loading some of the bash functions
- .vim - my vim setup - including syntax highlighting and other tweaks
- .tmux.conf - My setup for tmux, the "better than screen" terminal multiplexer
- .bash_profile - mostly empty. Just makes sure .bashrc gets run.
- .globalgitconfig - My git configuration.

Usage
---

### Setup a new system

``` bash
./setup-system.sh  # 
```

### Just link the user config files

``` bash
./setup-user-config.sh  # links config files from this directory
```

Your existing files will be backed up in ./replaced

### Unlink the user config files

```
./remove-user-config.sh
```
