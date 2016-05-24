#!/bin/sh

OLD=$(tempfile)
xrandr > $OLD

# lock screen
i3lock -n -e -f -t -i /usr/share/wallpapers/Next/contents/images/$(awk '/[*]/{print $1}' $OLD | head -n1).png

NEW=$(tempfile)
xrandr > $NEW

echo $OLD
echo $NEW
cmp -s $OLD $NEW || /home/reuben/bin/toggle-screens.sh
rm $OLD $NEW

