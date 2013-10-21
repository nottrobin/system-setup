##
# Bash functions
# A bunch of functions to be run
# on shell login, or just during shell use
##

# .. multiplier - goes up n levels
# usage: # .. <num>
##
function ..() {
    if [ "$1" ]; then
        COUNTER=0
        while [ $COUNTER -lt $1 ]; do
            cd ..
            let COUNTER+=1
        done
    else
        cd ..
    fi
}

# Set some useful variables
##
function set_vars ()
{
    pdd=/nfs/personaldev
    pd=/nfs/personaldev/rwmorris
    svn=svn://subversion/symfony
    web=/var/www
    me="robin@vps.robinwinslow.co.uk"

    # Set variables for bash colours
    define_bash_colors
}

# Make bash completion work
##
function set_bash_completion ()
{
    if [ "$PS1" -a -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
}

# Set subversion path
##
function set_svn_path ()
{
    SVNPATH="svn://subversion/symfony/"
}

# Source global bash definitions
##
function source_global_bashrc ()
{
    if [ -f /etc/bashrc ]; then
        . /etc/bashrc
    fi
}

# Define a bunch of colour variables 
##
function define_bash_colors ()
{
    # basic colours
    red="\[\033[00;31m\]"
    green="\[\033[00;32m\]"
    yellow="\[\033[00;33m\]"
    blue="\[\033[00;34m\]"
    magenta="\[\033[00;35m\]"
    white="\[\033[00;37m\]"

    # bright colours
    h_red="\[\033[01;31m\]"
    h_green="\[\033[01;32m\]"
    h_yellow="\[\033[01;33m\]"
    h_blue="\[\033[01;34m\]"
    h_magenta="\[\033[01;35m\]"
    h_white="\[\033[01;37m\]"

}

# Setup a bunch of aliases
##
function set_aliases ()
{
    # system wide shortcuts	
    alias l='ls -lA'
    alias ll='ls -l'
    alias realpath="php -r 'echo realpath(getcwd()).PHP_EOL;'" # Get the real path of a symlinked dir
    alias clearmemcache="/export/home/msquire/bin/clearmemcache" # Clear memacache
    alias ks='kill -SIGWINCH $$'; # Fix weird terminal display issues
    alias unlock='sudo mach -dr ipc-redhat-5-buildroot-0 -f unlock'; # Unlock root for RPM builds
    alias distro='cat `ls /etc/*_ver* /etc/*-rel*`'; # Print out the name of the current distribution

    # Symfony related aliases
    alias svnls='svn ls svn://subversion/symfony'
    alias symfony='./symfony'
    alias si='./symfony'
    alias rcc='rm -rf log/ cache/' # Effectively clear cache	
    alias sfix='rm -rf log/ cache/ ; mkdir log cache ; ./symfony fix-perms' # Effectively, ./symfony fix
    alias svnexternals='svn pe svn:externals .'
    alias ssti="svn st --ignore-externals"
    alias sstc="svn st | egrep -v '^($|X |Performing)'"
    alias unixtime="date +%s"

    # PRM aliases
    alias prmqa='prm inspire-qa'
    alias prmdev='prm inspire-dev'
    alias prmlive='prm inspire-live'
    alias prmstage='prm inspire-stage'
    alias prmdevbatch='prm digital-dev-batch'
    alias prmqabatch='prm digital-qa-batch'
    alias prmstagebatch='prm digital-stage-batch'
    alias prmbatch='prm digital-live-batch'

    # Go to my server
    alias sshme='ssh robin@robinwinslow.co.uk'

    # Server aliases
    alias rw='sudo /etc/init.d/rw'
    alias nrw='sudo /etc/init.d/noderw'

    # Git alises
    alias up='git push && git push heroku'
}

# Prompt colours
##
function prompt_colours ()
{
    define_bash_colors # Import easy color variable names

    delimiter_color=$h_white
    environment_color=$h_green
    path_color=$h_blue
    command_color=$white
    branch_color=$green

    # Wherever we are, root is red
    [[ `whoami` == 'root' ]] && environment_color=$h_red;
}

# Make the prompt shorter
##
function prompt_short ()
{
    prompt_colours # Get prompt colour choices

    # The following string defines what is displayed on the terminal prompt
    # Colours variables will set the colour for all characters after that point until a new colour is specified
    # \u = username (e.g. rwmorris)
    # \h = hostname (e.g. bfb1-086)
    # $REALNAME = environment name (e.g. inspire-qa-web-01)
    # \W = working directory

    PS1="$delimiter_color[$path_color\W\$(__git_ps1 \"$delimiter_color|$branch_color%s\")$delimiter_color] # $command_color"
}

# Terminal prompt colours
##
function prompt_standard ()
{
    prompt_colours # Get prompt colour choices

    # The following string defines what is displayed on the terminal prompt
    # Colours variables will set the colour for all characters after that point until a new colour is specified
    # \u = username (e.g. rwmorris)
    # \h = hostname (e.g. bfb1-086)
    # $REALNAME = environment name (e.g. inspire-qa-web-01)
    # \W = working directory

    PS1="$delimiter_color[$environment_color\u@\h$delimiter_color:$path_color\W\$(__git_ps1 \"$delimiter_color|$branch_color%s\")$delimiter_color] # $command_color"
}

# Add some useful locations to the $PATH
##
function set_path ()
{
    PATH=~/bin:$PATH:/usr/sbin:$HOME/bin:/usr/local/bin:/usr/local/sbin; export PATH
}

# Set the default permissions for created directories and files
##
function set_umask()
{
    umask 002
}

# Make it so ssh keys don't prompt for passphrase
#
function enable_ssh_auto_login ()
{
    if [ -z "$TMUX" ]; then # we're not in a tmux session
        if [ ! -z "$SSH_TTY" ]; then # We logged in via SSH
            # if ssh auth variable is missing
            if [ -z "$SSH_AUTH_SOCK" ]; then
                export SSH_AUTH_SOCK="$HOME/.ssh/.auth_socket"
            fi

            # create the new auth session
            if [ ! -S "$SSH_AUTH_SOCK" ]; then
                `ssh-agent -a $SSH_AUTH_SOCK` > /dev/null 2>&1
                echo $SSH_AGENT_PID > $HOME/.ssh/.auth_pid
            fi

            if [ -z $SSH_AGENT_PID ]; then
                export SSH_AGENT_PID=`cat $HOME/.ssh/.auth_pid`
            fi

            # Add all default keys to ssh auth
            ssh-add 2>/dev/null
        fi
    fi
}

# Load a tmux session, if one doesn't exist
##
function load_tmux_session()
{
    # to keep the shell clean for headless calls
    if [ -z "$TMUX" ] && [[ $TERM != 'screen' ]]; then # we're not in a tmux session
        if [ ! -z "$SSH_TTY" ]; then # We logged in via SSH
            tmux attach;
        fi
    fi
}

# Load a screen session, if one doesn't exist
##
function load_screen_session()
{
    if [[ $TERM != 'screen' ]]; then
        screen -d -R -S $1;
    else
        echo "Screen session open";
    fi
}

function remotediff()
{
    if [[ $3 ]]; then
        remotefile=$3;
    else
        remotefile=$1
    fi
    ssh $2 cat $remotefile | diff $1 -;
}

# SVN helper functions
# ---

# View diff excluding whitespace and in vim
##
function svndiff() {
    svn diff --diff-cmd diff -x -wu "${@}" | vim - +'set filetype=diff'
}

# Shortcut to check out a project
##
function svnco() {
    svn co svn://subversion/symfony/$1 $2
    cd $2
    sfstart
}

# Shortcut to view a log
##
function svnlog() {
    if [ "$2" ]; then
        svn log $SVNPATH$1 -v --limit=$2
    else
        svn log $SVNPATH$1 -v
    fi
}

# Shortcut to clear symfony cache
##
function scc() {
if [ "$1" ]; then
    cachefile1=cache/*/prod/config/config_$1.yml.php
    cachefile2=cache/*/dev/config/config_$1.yml.php
    if [ -f $cachefile1 ]; then
        echo "Removing prod cache files..."
        rm -f $cachefile1
    fi
    if [ -f $cachefile2 ]; then
        echo "Removing dev cache files..."
        rm -f $cachefile2
    fi
    sctc
else
    ./symfony cc
fi
}

# Shortcut to clear only symfony template cache
##
function sctc() {
    cachedir1=cache/*/prod/template
    cachedir2=cache/*/dev/template
    if [ -d $cachedir1 ]; then
        echo "Removing prod template cache..."
        rm -rf $cachedir1
    fi
    if [ -d $cachedir2 ]; then
        echo "Removing dev template cache..."
        rm -rf $cachedir2
    fi
    echo "Done."
}

# ====
# OS specific setups
# ====

# Setup ubuntu
##
function ubuntu_setup() {
    # ~/.bashrc: executed by bash(1) for non-login shells.
    # see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
    # for examples

    # If not running interactively, don't do anything
    [ -z "$PS1" ] && return

    # don't put duplicate lines in the history. See bash(1) for more options
    # ... or force ignoredups and ignorespace
    HISTCONTROL=ignoredups:ignorespace

    # append to the history file, don't overwrite it
    shopt -s histappend

    # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
    HISTSIZE=1000
    HISTFILESIZE=2000

    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize

    # make less more friendly for non-text input files, see lesspipe(1)
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi

    # set a fancy prompt (non-color, unless we know we "want" color)
    case "$TERM" in
        xterm-color) color_prompt=yes;;
    esac

    # uncomment for a colored prompt, if the terminal has the capability; turned
    # off by default to not distract the user: the focus in a terminal window
    # should be on the output of commands, not on the prompt
    #force_color_prompt=yes

    if [ -n "$force_color_prompt" ]; then
        if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
            # We have color support; assume it's compliant with Ecma-48
            # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
            # a case would tend to support setf rather than setaf.)
            color_prompt=yes
        else
            color_prompt=
        fi
    fi

    if [ "$color_prompt" = yes ]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    else
        PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    fi
    unset color_prompt force_color_prompt

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
        xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
        *)
        ;;
    esac

    # enable color support of ls and also add handy aliases
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        #alias dir='dir --color=auto'
        #alias vdir='vdir --color=auto'

        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi

    # some more ls aliases
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'

    # Add an "alert" alias for long running commands.  Use like so:
    #   sleep 10; alert
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

    # Alias definitions.
    # You may want to put all your additions into a separate file like
    # ~/.bash_aliases, instead of adding them here directly.
    # See /usr/share/doc/bash-doc/examples in the bash-doc package.

    if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
    fi

    # enable programmable completion features (you don't need to enable
    # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
    # sources /etc/bash.bashrc).
    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
        . /etc/bash_completion
    fi

    export PATH=$PATH:~/bin

}

# Setup Lubuntu
##
function lubuntu_setup ()
{
    # ~/.bashrc: executed by bash(1) for non-login shells.
    # see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
    # for examples

    # If not running interactively, don't do anything
    [ -z "$PS1" ] && return

    # don't put duplicate lines in the history. See bash(1) for more options
    # ... or force ignoredups and ignorespace
    HISTCONTROL=ignoredups:ignorespace

    # append to the history file, don't overwrite it
    shopt -s histappend

    # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
    HISTSIZE=1000
    HISTFILESIZE=2000

    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize

    # make less more friendly for non-text input files, see lesspipe(1)
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi

    # set a fancy prompt (non-color, unless we know we "want" color)
    case "$TERM" in
        xterm-color) color_prompt=yes;;
    esac

    # uncomment for a colored prompt, if the terminal has the capability; turned
    # off by default to not distract the user: the focus in a terminal window
    # should be on the output of commands, not on the prompt
    #force_color_prompt=yes

    if [ -n "$force_color_prompt" ]; then
        if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
            # We have color support; assume it's compliant with Ecma-48
            # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
            # a case would tend to support setf rather than setaf.)
            color_prompt=yes
        else
            color_prompt=
        fi
    fi

    if [ "$color_prompt" = yes ]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    else
        PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    fi
    unset color_prompt force_color_prompt

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
        xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
        *)
        ;;
    esac

    # enable color support of ls and also add handy aliases
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        #alias dir='dir --color=auto'
        #alias vdir='vdir --color=auto'

        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi

    # some more ls aliases
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'

    # Add an "alert" alias for long running commands.  Use like so:
    #   sleep 10; alert
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

    # Alias definitions.
    # You may want to put all your additions into a separate file like
    # ~/.bash_aliases, instead of adding them here directly.
    # See /usr/share/doc/bash-doc/examples in the bash-doc package.

    if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
    fi

    # enable programmable completion features (you don't need to enable
    # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
    # sources /etc/bash.bashrc).
    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
        . /etc/bash_completion
    fi
}

