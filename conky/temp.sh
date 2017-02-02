#!/bin/sh
echo "scale = 2; $(cat /sys/class/hwmon/hwmon2/temp1_input) / 800" | bc
