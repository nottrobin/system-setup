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

**NB:** First backup and remove your existing `.bashrc`, `.bash_profile`, `.vim` and `.tmux.conf` files from your home directory.

```
cd ~
git clone git@github.com:nottrobin/.shellconfig.git
cd .shellconfig
./setup.sh # creates symlinks in your home directory
```

If you get an error trying to clone, you it might be a certificate problem. See:
http://stackoverflow.com/questions/3777075/https-github-access/4454754#comment-11700318

My global config contains a fix to this, using `http.sslVerify=no` in the global git config.

