#!/bin/bash

set -e
# set -x

usage () {
    echo "./add_caption.bash -i inputfile.mp4 -c caption.txt"
    echo "Example Contents of single line caption.txt"
    echo "Hello World"
    echo "or"
    echo "Example Contents of multi line caption.txt"
    echo "Hello"
    echo "World"
}

while [[ "$1" ]]; do
    case "${1}" in
        -i)
            shift
            in="$1"
            echo "Input File = $in"
        ;;
        -c)
            shift
            caption="$1"
            echo "item = 2 or item = 3"
        ;;
        -h)
            usage
        ;;
        *)
            echo "ERROR! Wrong argument..."
            usage
            exit 2
        ;;
    esac
    shift
done

# https://stackoverflow.com/questions/17623676/text-on-video-ffmpeg
# ffmpeg -i input.mp4 -vf "drawtext=fontfile=/path/to/font.ttf:text='Stack Overflow':fontcolor=white:fontsize=24:box=1:boxcolor=black@0.5:boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" -codec:a copy output.mp4

ffmpeg -i "$in" -vf "drawtext=textfile='$caption':fontcolor=yellow:fontsize=70:box=1:boxcolor=black@0.5:boxborderw=5:x=(w-text_w)/2:y=h-th-10" -preset veryfast out.mp4

# mpv.exe cause i was using wsl

if [ "$(command -v mpv.exe)" ]; then
    echo "command \"mpv.exe\" exists on system"
    mpv.exe --loop=inf out.mp4
    explorer.exe .
fi
