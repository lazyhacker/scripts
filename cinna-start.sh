#!/bin/bash

/usr/bin/autorandr --match-edid --load H-120

sleep 1
~/dotfiles/startconky.sh
sleep 1
/usr/bin/nitrogen --restore
