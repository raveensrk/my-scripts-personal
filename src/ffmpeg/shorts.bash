#!/bin/bash

# set -x
set -e

usage() {
    echo This script will crop any video into 9:16 ratio
    echo shorts.bash -i input.mp4
    echo options:
    echo --fit
    echo --crop \(default\)
    echo --trim \"-ss 00 -to 01\"
}

while [ "$1" ]; do
    case $1 in
        -h | --help)
            usage
            exit
            ;;
        -i)
            shift
            input=$(realpath "$1")
            ;;
        --fit)
            fit=1
            ;;
        --crop)
            crop=1
            ;;
        --trim)
            shift
            trim="$1"
            ;;
        *)
            echo wrong option...
            exit 2
            ;;
    esac
    shift
done

if [ -f "${input}" ]; then
    echo "File \"${input}\" exists"
else
    echo "File \"${input}\" missing!"
    exit 2
fi

: "${crop:=0}"
: "${fit:=0}"
: "${trim:=""}"

if [[ ($crop == 0) && ($fit == 0) ]]; then
    crop=1
fi

preset="-preset veryfast"
out="shorts-output.mp4"

if ((fit == 1)); then
    ffmpeg $trim -i "$input" -vf "scale=w=iw:h=iw*16/9:force_original_aspect_ratio=decrease,pad=iw:iw*16/9:(ow-iw)/2:(oh-ih)/2" $preset $out
elif ((crop == 1)); then
    # ffmpeg $trim -i "$input" -vf "scale=-2:1080,crop=608:1080" output.mp4
    # w/h = 9/16; w = 9*h/16
    ffmpeg $trim -i "$input" -vf "crop=ih*9/16:ih" $preset $out
fi

mpv="mpv.exe"
[ command -v "mpv.exe" ] || mpv="mpv"
$mpv --loop $out
