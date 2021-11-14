#!/bin/bash

# set -e
# set -x

mkdir collage

date1() {
    echo $(date +%Y%m%d%H%M%S)
}

path="$1"

echo collage = $i
gm montage -background black -geometry 3000x3000 $(ls $path/*.{jpg,png,jpeg} | shuf | head -9) -tile 2x2 -geometry 2000x2000 collage/collage-$(date1).jpg
