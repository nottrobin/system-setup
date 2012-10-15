#!/bin/sh

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
    # Get filenames
    localname=$projectdir/$1;
    backupname=$backupdir/$1;
    mergedname=$mergeddir/$1;

    # If a different option was supplied for install name, use that
    if [ ! -z $2 ]; then
        installname=$installdir/$2;
    else
        installname=$installdir/$1;
    fi

    # Backup existing file
    if [ -e $installname ]; then
        # If it was our simlink, just remove it
        link=`readlink -f $installname`;
        if [ "${link#*$projectdir}" != "$link" ]; then
            rm $installname && echo " - Removed old link to .shellconfig";
        fi

        # Make directories if they don't exist
        [ ! -e $backupdir ] && mkdir $backupdir && echo " - Made backup directory";
        [ ! -e $mergeddir ] && mkdir $mergeddir && echo " - Made merged directory";
        
        # Back up the existing file
        cp $installname $backupname && echo " - Backed up original file";

        # Create merged file
        cat $installname $localname > $mergedname && echo " - Created merged file";
        
        # Remove original file
        rm $installname && echo " - Removed original file";

	# Link to the merged version
	ln -s $mergedname $installname && echo " - Created symlink to merged file";
    else
	# Link to our version
	ln -s $localname $installname && echo " - Created symlink to .shellconfig";
    fi

}

# Setup normal files
for filename in '.bashrc' '.bash_profile' '.bash_functions.sh' '.tmux.conf' '.vim'; do
    installfile $filename && echo " - == Installed $filename";
done

# Setup global git config (needs special name)
installfile '.globalgitconfig' '.gitconfig' && echo " - == Installed .gitconfig";

