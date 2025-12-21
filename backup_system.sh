#!/bin/sh

if [ ! -f rsync-rootdir-excludes.txt ]; then
    echo 'rsync-rootdir-excludes.txt not file.  Aborting...'
    exit 1
fi

if [[ -z $1 ]]; then
    echo 'Need path to backup directory.  Aborting...'
else
    echo 'Backing up to '$1'system/Fedora'`cat /etc/system-release | grep -ow -E [[:digit:]]+` 
    rsync -aAXv / --exclude-from=rsync-rootdir-excludes.txt $1/system/Fedora`cat /etc/system-release | grep -ow -E [[:digit:]]+`
fi
