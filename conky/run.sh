#!/bin/bash
# Bootstrap script for starting Conky on multiple monitors

# clean up stale instances
killall conky

# TODO: implement
conky -c $HOME/.config/i3/conky/conkyrc.lua

