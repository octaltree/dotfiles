#!/bin/bash

cur="$1"
root=`cd "$cur" && git rev-parse --show-toplevel 2>/dev/null`

if [ "$root" = "" ]; then
  basename "$cur"
else
  base=`basename "$root"`
  n=`echo "$root"| wc -c`
  rel=`echo "$cur" | cut -c "$n-"`
  echo "$base$rel"
fi
