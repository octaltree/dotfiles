#!/bin/sh

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
fcitx -r
start-pulseaudio-x11
redshift -O 4500k
xset r rate 170 60
xset b off
xset s off -dpms
