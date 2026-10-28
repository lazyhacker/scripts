#!/usr/bin/env bash

# Work around for issue with Alacritty not getting focus after it
# is launched. https://github.com/linuxmint/cinnamon/issues/13382 

set -euo pipefail

alacritty &
PID=$!

sleep 0.5

xdotool windowactivate $(xdotool search --pid $PID | tail -n 1)
