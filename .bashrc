# .bashrc
# This gets loaded whenever a new shell is instantiated
##

# Load in some useful bash functions
##
source $HOME/.bash_functions.sh;

# OS Specific setup
##
issue=`cat /etc/issue`;
# Ubuntu
[[ $issue =~ 'Ubuntu' ]] && ubuntu_setup;
# Lubuntu
[[ $issue =~ 'Lubuntu' ]] && lubuntu_setup;

# Run some bash functions
##
source_global_bashrc        # Import global settings
set_vars                    # Add my custom bash variables
set_bash_completion         # Make sure tab completion is turned on
set_path                    # Add my custom locations to $PATH
set_svn_path                # Add the SVNPATH
set_aliases                 # Add custom aliases
set_terminal_prompt_colours # Setup prompt colours

if [[ $TERM == 'screen' ]]; then
    # Must be within tmux session - so we keep initial login shell clean
    enable_ssh_auto_login   # Make it so autologin to other terminals will work
fi

# If we have the expected default 'xterm' terminal
# load tmux
# We're not doing this for every terminal
# to keep the shell clean for headless calls
[[ $TERM == 'xterm' ]] && load_tmux_session 'rw-default'

