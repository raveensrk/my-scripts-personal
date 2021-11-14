#!/bin/bash

mkdir blurred_pictures

for file in ./*.jpg; do
  name=$(basename "$file")
  out="blurred_pictures/$name"
  cp "$file" "$out"
  facedetect "$file" | while read x y w h; do
    mogrify -gravity NorthWest -region "${w}x${h}+${x}+${y}" \
      -scale '10%' -scale '1000%' "$out"
  done
done
