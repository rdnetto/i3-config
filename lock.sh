#!/bin/bash

OLD=$(tempfile)
xrandr > $OLD

# lock screen
i3lock -n -e -f -t -i /home/renee/.config/i3/wallpapers/transbianSky.png

NEW=$(tempfile)
xrandr > $NEW

echo $OLD
echo $NEW
cmp -s $OLD $NEW || /home/renee/bin/toggle-screens.sh
rm $OLD $NEW

