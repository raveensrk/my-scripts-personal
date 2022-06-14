#!/bin/bash

# set -x
# set -e

mkdir extracted_faces

count=0

for file in ./*.jpg; do
  name=$(basename "$file")
  i=0

  count=$(($count + 1))
  # echo $count
  # [[ "$count" -eq "5" ]] && exit

  facedetect "$file" | while read x y w h; do

    # echo $file
    # echo x=${x}
    # echo y=${y}
    # echo w=${w}
    # echo h=${h}
    inc=500
    x=$((${x} - ${inc}))
    y=$((${y} - ${inc}))
    [[ $x -lt 0 ]] && x=0
    [[ $y -lt 0 ]] && y=0
    w=$((${w}*2))
    h=$((${h}*2))
    # echo x=${x}
    # echo y=${y}
    # echo w=${w}
    # echo h=${h}


    convert "$file" -crop ${w}x${h}+${x}+${y} "extracted_faces/${name%.*}_${i}.${name##*.}"
    i=$(($i+1))
  done
done
