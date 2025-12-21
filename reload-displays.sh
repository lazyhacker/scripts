#!/bin/sh

autorandr -c --match-edid

sleep 1

/usr/bin/nitrogen --force-setter=xinerama --restore

killall conky; conky
