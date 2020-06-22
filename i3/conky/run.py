#!/usr/bin/python3
# Bootstrap script for starting Conky on multiple monitors

import os
import sys
import subprocess
import re
from subprocess import DEVNULL


CONKY_FILE = os.environ["HOME"] + "/.config/i3/conky/conkyrc.lua"


class Screen:
    def __init__(self, w, h, x, y):
        self.w = w
        self.h = h
        self.x = x
        self.y = y

    def top_right_corner(self):
        return (self.x + self.w, 0)


def get_screens():
    # Format: "DVI-I-1 connected primary 1920x1200+0+0 (normal left inverted right x axis y axis) 518mm x 324mm"
    dim_re = re.compile(br" (\d+)x(\d+)\+(\d+)\+(\d+) ")

    output = subprocess.check_output("xrandr")
    lines = [line for line in output.split(b"\n") if b" connected" in line]
    return map(lambda m: Screen(*map(int, m.groups())),
              filter(lambda x: x is not None,
                     map(dim_re.search,
                         lines)))


def get_conky_width():
    with open(CONKY_FILE, "r") as f:
        line = list(filter(lambda x: "maximum_width" in x, f.readlines()))[0]

    return int(re.search(r"\d+", line).group(0))


def main():
    # Clean up stale instances
    subprocess.call(["killall", "conky"], stdout=DEVNULL, stderr=DEVNULL)

    # parse width from file
    panel_width = get_conky_width()

    # Spawn a process for each screen
    for s in get_screens():
        (x, y) = s.top_right_corner()
        subprocess.check_call([
            "conky",
            "-c", CONKY_FILE,
            "--alignment", "top_left",  # needed to work correctly on multiple screens
            "-x", str(x - panel_width),
            "-y", str(y)
        ])


if(__name__ == "__main__"):
    main()
