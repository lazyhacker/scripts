#!/bin/sh

if [ ! -f rsync-homedir-excludes.txt ]; then
    echo 'rsync-homedir-excludes.txt not found. Aborting...'
    exit 1
fi

if [[ -z ${BACKUP_DRIVE} ]]; then
    echo 'BACKUP_DRIVE not set. Aborting...'
else
    # Removed the invalid flag; rsync handles recursive traversal natively.
    # nice and ionice protect your system from freezing up under heavy I/O/memory load.
    RSYNC_OPTS="-aP --exclude-from=rsync-homedir-excludes.txt"

    if [ "$1" == full ]; then
        DEST="$BACKUP_DRIVE/$USER/$(date +%F)"
        echo "Backing up to $DEST"
        nice -n 19 ionice -c 3 rsync $RSYNC_OPTS /home/$USER "$DEST"
    else
        DEST="$BACKUP_DRIVE/$USER/current"
        echo "Backing up to $DEST"
        nice -n 19 ionice -c 3 rsync $RSYNC_OPTS --delete /home/$USER "$DEST"
    fi
fi
