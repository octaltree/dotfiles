#!/bin/bash

summary=`echo -n "$2"| tr "\n" " "`
body=`echo -n "$3"| tr "\n" " "`
icon=`echo -n "$4"| tr "\n" " "`
urgency=`echo -n "$5"| tr "\n" " "`

echo "$icon	$urgency	$summary	$body" >> ~/.dunst_history
