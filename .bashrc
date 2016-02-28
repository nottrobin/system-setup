# .bashrc
# This gets loaded whenever a new shell is instantiated
##

# Load in some useful bash functions
##
source `dirname ${BASH_SOURCE[0]}`/.git-prompt.sh
source `dirname ${BASH_SOURCE[0]}`/.bash_functions.sh

# Run some bash functions
##
set_vars                    # Add my custom bash variables
set_bash_completion         # Make sure tab completion is turned on
set_path                    # Add my custom locations to $PATH
set_svn_path                # Add the SVNPATH
set_aliases                 # Add custom aliases

prompt_standard             # Setup prompt colours. You can add a colour like "h_green" as an argument if you want.
hub_alias                   # If "hub" is installed, alias it to "git"
virtualenvwrapperconfig     # Setup python's virtualenvwrapper config
preserve_history            # Concatenate history across multiple terminal windows

# Disable starting of byobu
# The best way to start byobu is by changing the terminal settings:
# From Dustin Kirkland (author): http://askubuntu.com/a/296434
#start_byobu                 # Run byobu whenever a terminal is created

