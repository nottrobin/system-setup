#!/bin/sh

# Check for dependencies
command -v readlink >/dev/null 2>&1 || {
    echo >&2 "readlink is required for install.";
    echo >&2 "Manually remove symlinks to the config files no longer want and restore original files from the backups directory.";
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
    link=`readlink -f $installname`;
    if [ "${link#*$projectdir}" != "$link" ]; then
        rm $installname && echo " - Removed link $installname";
        [ -e $backupname ] && mv $backupname $installname && echo " - Replaced original $installname";
    	return 0; # Uninstalled
    elif [ -e $installname ] && grep "#nottrobin-shellconfig" .bashrc > /dev/null 2>&1; then
        sed -i '/#nottrobin-shellconfig/d' $installname && echo " - Removed source line from $installname";
    else
        return 1; # Didn't uninstall
    fi

}

# Setup normal files
for filename in '.bashrc' '.bash_profile' '.tmux.conf' '.vim'; do
    uninstallfile $filename && echo " - == Uninstalled $filename";
done


# Setup global git config (needs special name)
uninstallfile '.globalgitconfig' '.gitconfig' && echo " - == Uninstalled .gitconfig";

# Setup global git config (needs special name)
uninstallfile '.user-preferences.sublime-settings' '.config/sublime-text-3/Packages/User/Preferences.sublime-settings' && echo " - == Uninstalled sublime user profile";

# Try to remove backup directory (should now be empty)
[ -e $backupdir ] && rmdir $backupdir && echo " - Removed backup directory";

