#!/usr/bin/sh

ffmpeg -i shiny_demo.mov -r 20 -f gif - | gifsicle --optimize=3 --delay=5 > shiny_demo.gif
ffmpeg -i wercker_score.mov -r 20 -f gif - | gifsicle --optimize=3 --delay=5 > wercker_score.gif