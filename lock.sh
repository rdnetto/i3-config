#!/bin/bash

OLD=$(tempfile)
xrandr > $OLD
RES=$(awk '/[*]/{print $1}' $OLD | head -n1)

# Next doesn't have a version in this size
if [ "$RES" == "1920x1200" ]; then
    RES="1920x1080"
fi

# lock screen
i3lock -n -e -f -t -i /usr/share/wallpapers/Next/contents/images/$RES.png

NEW=$(tempfile)
xrandr > $NEW

echo $OLD
echo $NEW
cmp -s $OLD $NEW || /home/reuben/bin/toggle-screens.sh
rm $OLD $NEW

