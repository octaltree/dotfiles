#!/bin/sh

fcitx -r
start-pulseaudio-x11
redshift -O 4500k
setxkbmap -option ctrl:swapcaps
xset r rate 200 50
xset b off
