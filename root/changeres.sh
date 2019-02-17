#! /bin/bash
DISPLAY=:0.$1 sudo -u abc xrandr --size $2x$3
