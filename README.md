Shell config
===

This is my shell config, including:

- bash functions - a collection of useful functions for setting up my bash shell
- .bashrc - setup the bash shell, by loading some of the bash functions
- .vim - my vim setup - including syntax highlighting and other tweaks
- .tmux.conf - My setup for tmux, the "better than screen" terminal multiplexer
- .bash_profile - mostly empty. Just makes sure .bashrc gets run.
- .globalgitconfig - My git configuration.

Usage
---

- Backup and remove your existing .bashrc, .bash_profile, .vim and .tmux.conf files from your home directory
- fork my repository to your own github
- cd ~
- git clone git@github.com:<username>/.shellconfig.git
- cd .shellconfig
- ./setup.sh # creates symlinks in your home directory

That's it.

