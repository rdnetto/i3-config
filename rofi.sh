#!/bin/sh
# Helper script to call rofi with customizations

# Using glue_pro_blue theme
rofi $@ \
    -location 2 -width 80   \
    -terminal /usr/bin/konsole  \
    -color-enabled              \
    -color-window '#393939, #393939, #268bd2'                   \
    -color-normal '#393939, #ffffff, #393939, #268bd2, #ffffff' \
    -color-active '#393939, #268bd2, #393939, #268bd2, #205171' \
    -color-urgent '#393939, #f3843d, #393939, #268bd2, #ffc39c' \

# Android theme
#   -color-window '#273238, #273238, #1e2529'                   \
#   -color-normal '#273238, #c1c1c1, #273238, #394249, #ffffff' \
#   -color-active '#273238, #80cbc4, #273238, #394249, #80cbc4' \
#   -color-urgent '#273238, #ff1844, #273238, #394249, #ff1844'
