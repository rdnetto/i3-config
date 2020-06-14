#!/usr/bin/python3
import os
import sys

# Currently only supports /sys/class/backlight/intel_backlight/brightness (used on sylph)
# Note that you must be in the video group to have write access to it
ROOT = "/sys/class/backlight/intel_backlight/"

def main(mode):
    current = read("brightness")
    max = read("max_brightness")
    dir = {"up": 1, "down": -1}[mode]
    offset = dir * 0.05 * max
    new = int(current + offset)

    if (new < 0):
        new = 0
    elif (new > max):
        new = max

    with open(ROOT + "brightness", "w") as f:
        print(str(new))
        f.write(str(new))


def read(filename):
    with open(ROOT + filename) as f:
        return float(f.read())


if __name__ == "__main__":
    if (len(sys.argv) == 2):
        main(sys.argv[1])
    else:
        print("USAGE: adjust_brightness.py [up|down]")

