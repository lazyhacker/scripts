#!/bin/sh

if [ ! -f rsync-rootdir-excludes.txt ]; then
    echo 'rsync-rootdir-excludes.txt not file.  Aborting...'
    exit 1
fi

if [[ -z ${BACKUP_DRIVE} ]]; then
    echo 'BACKUP_DRIVE not set.  Aborting...'
else
    echo 'Backing up to '$BACKUP_DRIVE'system/Fedora'`cat /etc/system-release | grep -ow -E [[:digit:]]+` 
    rsync -aAXv / --exclude-from=rsync-rootdir-excludes.txt $BACKUP_DRIVE/system/Fedora`cat /etc/system-release | grep -ow -E [[:digit:]]+`
fi
