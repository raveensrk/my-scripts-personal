#!/bin/bash

set -x
set -e

help () {
    echo "This script converts 21:9 video to 16:9 with proper padding"
}

while [ "$1" ]; do
    case "$1" in
        --help)
            help
            exit 0
            ;;
        -i)
            shift
            in="$(realpath $1)"
            ;;
        *)
            help
            exit 2
            ;;
    esac
    shift
done

width=$(mediainfo "$in" --Inform="Video;%Width%")
height=$(mediainfo "$in" --Inform="Video;%Height%")
name=$(basename "$in")
out="out-$name.mp4"

[ -d converted_21x9_to_16x9 ] || mkdir converted_21x9_to_16x9
pushd converted_21x9_to_16x9

if [ $width != 1920 ]; then
    echo "This file \“${i}\“ is not of width 1920, converting..."
    echo "WidthxHeight = ${width}x${height}"
    ffmpeg -i "$in" -vf "scale=w=1920:h=-2,pad=width=1920:height=1080:x=0:y=(oh-ih/2)"  -preset veryfast -r 30 $out
else
    echo "No need to convert this file is already 1920 in width..."
    echo "WidthxHeight = ${width}x${height}"
    ffmpeg -i "$in" -preset veryfast -r 30 $out
fi

out_width=$(mediainfo "$out" --Inform="Video;%Width%")
out_height=$(mediainfo "$out" --Inform="Video;%Height%")
echo "WidthxHeight = ${out_width}x${out_height}"
# mpv $out
popd

exit 0
