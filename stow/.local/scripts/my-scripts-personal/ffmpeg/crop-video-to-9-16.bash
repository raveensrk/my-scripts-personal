#!/bin/bash

# First version of ./shorts.bash script

date1 () {
    echo $(date +%Y%m%d%H%M%S)
}

set -e
# set -x

ffmpeg -i "$1" -vf "scale=-2:1080,crop=608:1080:700" -preset veryslow "9-16-crop-$1"
