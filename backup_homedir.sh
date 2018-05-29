#!/bin/sh

if [ ! -f rsync-homedir-excludes.txt ]; then
    echo 'rsync-homedir-excludes.txt not file.  Aborting...'
    exit 1
fi

if [[ -z ${BACKUP_DRIVE} ]]; then
    echo 'BACKUP_DRIVE not set.  Aborting...'
else

    if [ "$1" == full ]; then
        echo 'Backing up to ' $BACKUP_DRIVE'/'$USER/`date +%F`
        rsync -aP --exclude-from=rsync-homedir-excludes.txt  /home/$USER $BACKUP_DRIVE/$USER/`date +%F`
    else
        echo 'Backing up to ' $BACKUP_DRIVE'/'$USER/current
        rsync -aP --exclude-from=rsync-homedir-excludes.txt  /home/$USER $BACKUP_DRIVE/$USER/current
    fi
fi
