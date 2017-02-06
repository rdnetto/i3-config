#!/bin/sh
# This is the more correct approach - on shuriken acpitemp shows 27 degrees (ambient), when coretemp is 76
echo "scale = 2; $(cat /sys/class/hwmon/hwmon2/temp1_input) / 800" | bc
