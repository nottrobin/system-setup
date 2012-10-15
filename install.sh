#!/bin/sh

# Check for dependencies
command -v readlink >/dev/null 2>&1 || {
    echo >&2 "readlink is required for install.";
    echo >&2 "Consider manually adding symlinks to the config files you want.";
    echo >&2 "Exiting.";
    exit 1;
}

backupdir='replaced';

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

installfile()
{
    # Get filenames
    localname=$projectdir/$1;
    backupname=$backupdir/$1;
    if [ ! -z $2 ]; then
        installname=$installdir/$2;
    else
        installname=$installdir/$1
    fi

    # Backup existing file
    if [ -e $installname ]; then
        if [ -L $installname ]; then
            rm $installname && echo " - Removed link $installname";
        else
            [ ! -e $backupdir ] && mkdir $backupdir && echo "+ Made $backupdir";
            mv $installname $backupname && echo " - Moved $installname to $backupname";
        fi
    fi

    # Link to our version
    ln -s $localname $installname && echo " - Created symlink $installname=>$localname";
}

# Setup normal files
for filename in '.bashrc' '.bash_profile' '.bash_functions.sh' '.tmux.conf' '.vim'; do
    installfile $filename && echo "Installed $filename";
done

# Setup global git config (needs special name)
installfile '.globalgitconfig' '.gitconfig' && echo "Installed .gitconfig";

