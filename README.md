Shell config
===

This is my shell config, including:

- .bash_functions.sh - a collection of useful functions for setting up my bash shell
- .bashrc - setup the bash shell, by loading some of the bash functions
- .vim - my vim setup - including syntax highlighting and other tweaks
- .tmux.conf - My setup for tmux, the "better than screen" terminal multiplexer
- .bash_profile - mostly empty. Just makes sure .bashrc gets run.
- .globalgitconfig - My git configuration.

Usage
---

To install:

```
git clone git@github.com:nottrobin/.shellconfig.git
.shellconfig/install.sh # creates symlinks in your home directory
```

Your existing files will be backed up in .shellconfig/replaced

To uninstall - and move your original files back into your home directory:

```
.shellconfig/uninstall.sh
```

If you get an error trying to clone:

- Make sure you're using the read-only URL: `git://github.com/nottrobin/.shellconfig.git`.
- You might be getting a [certificate problem](http://stackoverflow.com/questions/3777075/https-github-access/4454754#comment-11700318). Try `env GIT_SSL_NO_VERIFY=true`.

Once you've installed my config, the .globalgitconfig contains a fix to the certificate problem, using `http.sslVerify=no`.

