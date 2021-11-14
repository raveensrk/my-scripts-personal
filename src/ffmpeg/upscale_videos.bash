#!/bin/bash

date1 () {
    echo $(date +%Y%m%d%H%M%S)
}

set -e
# set -x

echo $1

read -p "Enter output file name: " name

ffmpeg -i "$1" -vf scale=-2:1080 $name