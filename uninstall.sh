#!/bin/sh

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

uninstallfile()
{
    # Get filenames
    backupname=$backupdir/$1;
    if [ ! -z $2 ]; then
        installname=$installdir/$2;
    else
        installname=$installdir/$1
    fi
    
    # Remove existing file
    if [ -L $installname ]; then
        rm $installname && echo " - Removed link $installname";
        [ -e $backupname ] && mv $backupname $installname && echo " - Replaced original $installname";
    fi
}

# Setup normal files
for filename in '.bashrc' '.bash_profile' '.bash_functions.sh' '.tmux.conf' '.vim'; do
    uninstallfile $filename && echo "Uninstalled $filename";
done

# Setup global git config (needs special name)
uninstallfile '.globalgitconfig' '.gitconfig' && echo "Uninstalled .gitconfig";

# Try to remove backup directory (should now be empty)
rmdir $backupdir && echo "+ Removed backup directory";

