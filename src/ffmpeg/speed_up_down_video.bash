#!/bin/bash

set -e
set -x

if [ "-h" = $1]; then
    echo USAGE:
    echo To Speed up by 2x: speed_up_down_video.bash "file" "0.5"
    echo To Slowdown by 2x: speed_up_down_video.bash "file" "2"
fi

ffmpeg -i "$1" -filter:v "setpts=$2*PTS" -an -preset veryfast "speed-$2-$1"
