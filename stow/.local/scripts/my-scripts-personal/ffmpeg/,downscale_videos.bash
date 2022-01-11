#!/bin/bash

date1 () {
    echo $(date +%Y%m%d%H%M%S)
}

set -e
# set -x

echo "$1"

ffmpeg -i "$1" -vf scale=-2:650 -preset veryfast "downscaled-$1"
