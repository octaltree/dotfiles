#!/bin/bash

i3status | while :; do
  read line
  if echo "$line"| grep name >/dev/null; then
    x=`free -h| grep Mem| awk '{print $7}'`
    j="{\"name\":\"memAvail\", \"full_text\": \"memAvail $x\"}"
    echo "$line"|\
      sed 's/^\([,]*\[\)\(.*\)$/\1a66860f7-5ea6-4f0e-8454-f3ca30e815c7,\2/'|\
      sed "s/a66860f7-5ea6-4f0e-8454-f3ca30e815c7/$j/"
  else
    echo "$line"
  fi
done
