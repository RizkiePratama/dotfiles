#!/bin/bash

# Terminate existing process
killall -q polybar

# Wait existing polybar to be killed
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch
polybar &
echo "Polybar Started..."
