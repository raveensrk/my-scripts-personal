#!/bin/bash

# set -x
set -e

source ~/.bash_prompt 

usage() {
    echo This script will crop any video into 9:16 ratio for youtube shorts
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
        --x-offest|-x)
            shift
            xoffset="$1"
            ;;
        --subtitle|-s)
            shift
            subtitle="$1"
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

preset="-preset veryslow"
out="shorts-output.mp4"

if ((fit == 1)); then
    ffmpeg $trim -i "$input" -vf "scale=w=iw:h=iw*16/9:force_original_aspect_ratio=decrease,pad=iw:iw*16/9:(ow-iw)/2:(oh-ih)/2" $preset $out
elif ((crop == 1)); then
    set -x
    ffmpeg $trim -copyts -i "$input" $trim -filter_complex "[0:v]crop=ih*9/16:ih:$xoffset:0[v1];[v1]subtitles=$subtitle[v2];[0:a]amerge=inputs=1[a]" -map [v2] -map [a] $preset $out
    set +x
fi

yellow
echo Output file:
realpath $out
nc

mpv=${mpv:-mpv}
$mpv --loop $out
