# .bashrc
# This gets loaded whenever a new shell is instantiated
##

# Load in some useful bash functions
##
if [ -f $HOME/.shellconfig/.bash_functions.sh ]; then
    . $HOME/.shellconfig/.bash_functions.sh
elif [ -f $HOME/.bash_functions.sh ]; then
    . $HOME/.bash_functions.sh
fi

# Run some bash functions
##
source_global_bashrc        # Import global settings
set_vars                    # Add my custom bash variables
set_bash_completion         # Make sure tab completion is turned on
set_path                    # Add my custom locations to $PATH
set_svn_path                # Add the SVNPATH
set_aliases                 # Add custom aliases
set_terminal_prompt_colours # Setup prompt colours

# These are within IF blocks so they only run when there is a terminal
if [[ $TERM == 'screen' ]]; then
    # Only if we're already in tmux
    enable_ssh_auto_login   # Make it so autologin so other terminals will work
elif [[ $TERM == 'xterm' ]]; then
    # Otherwise load tmux (if we have a terminal)
    load_tmux_session 'rw-default' # Open a screen session
fi

