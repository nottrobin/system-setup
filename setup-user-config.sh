#!/bin/sh

# Check for dependencies
command -v readlink >/dev/null 2>&1 || {
    echo >&2 "readlink is required for install.";
    echo >&2 "Consider manually adding symlinks to the config files you want.";
    echo >&2 "Exiting.";
    exit 1;
}

backupdir='replaced';
mergeddir='merged';

# Find home directory
installdir=$HOME;
[ ! -d $installdir ] && installdir='~';
[ ! -d $installdir ] && installdir='..';
[ ! -d $installdir ] && echo "can't find home directory" && exit 0;

# Find this directory
scriptpath=$(readlink -f $0);
projectdir=`dirname "$scriptpath"`
[ ! -d $projectdir ] && echo "can't get current directory" && exit 0;

backupdir=$projectdir/$backupdir;
mergeddir=$projectdir/$mergeddir;

installfile()
{
    echo " - == Installing $1";

    # Get filenames
    localname=$projectdir/$1;
    backupname=$backupdir/$1;
    source=$3;

    # If a different option was supplied for install name, use that
    if [ ! -z $2 ]; then
        installname=$installdir/$2;
    else
        installname=$installdir/$1;
    fi

    link=`readlink -f $installname`;

    # Doesn't exist, create symlink (simplest)
    if ! [ -e $installname ]; then
        ln -s $localname $installname && echo " - Created symlink to .shellconfig";

    # If one of our links
    elif [ -L $installname ] && [ "${link#*$projectdir}" != "$link" ]; then 
        # Remove old link and create new one
        rm $installname && echo " - Removed old link to .shellconfig";
	ln -s $localname $installname && echo " - Created symlink to merged file";

    # If we're to source it
    elif [ -e $installname ] && [ $source ]; then
        echo "source $localname; #nottrobin-shellconfig" >> $installname && echo " - Sourced from .shellconfig";

    # Exists but not sourceable
    elif [ -e $installname ]; then
        # Make directories if they don't exist
        [ ! -e $backupdir ] && mkdir $backupdir && echo " - Made backup directory";

        # Back up the existing file
        cp -r $installname $backupname && echo " - Backed up original file";

        # Remove original file
        rm -r $installname && echo " - Removed original file";

	# Link to our version
	ln -s $localname $installname && echo " - Created symlink to our file";
    fi
}

# Setup normal files
for filename in '.tmux.conf' '.vim' '.bazaar'; do
    installfile $filename && echo " - == Installed $filename";
done

# Source bash files
for filename in '.bashrc'; do
    installfile $filename $filename true && echo " - == Installed $filename";
done

# Setup global git config (needs special name)
installfile '.globalgitconfig' '.gitconfig' && echo " - == Installed .gitconfig";

# Setup global git config (needs special name)
if [ -d $installdir/.config/sublime-text-3/Packages ]; then
    mkdir -p $installdir/.config/sublime-text-3/Packages/User
    installfile '.user-preferences.sublime-settings' '.config/sublime-text-3/Packages/User/Preferences.sublime-settings' && echo " - == Installed sublime user settings";
fi

echo "~~ Setting applied. Restart your terminal to see the changes. ~~"
