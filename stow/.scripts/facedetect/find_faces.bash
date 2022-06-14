#!/bin/bash

# https://www.thregr.org/~wavexx/software/facedetect/

mkdir pictures_with_faces
mkdir pictures_without_faces

for file in ./*.jpg; do
    name=$(basename "$file")
    if facedetect -q "$file"; then
        mv "$file" "pictures_with_faces/$name"
    else
        mv "$file" "pictures_without_faces/$name"
    fi
done
