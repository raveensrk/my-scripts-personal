#!/bin/bash

# This script converts mp4 to webm vp8, with a max size of 4 mb for
# image boards

# https://rentry.co/8o2nn#webm-for-retards

# This is the method you'll want to use for most of your WebMs since it's the one that gives you the best quality WebMs. I'm going to assume that you know what all the parameters from the single pass section do and that you have already downloaded ffmpeg.

# Run ff-prompt.bat
# Change the working directory using the following command: cd "C:\path\to\the\folder\where\your\video\is\located"
# Now paste these 2 commands with the proper parameters. Paste the second one after the first one is finished.
# 1
# 2
# ffmpeg -i input.mp4 -ss START -to END -c:v libvpx -threads 3 -quality good -cpu-used 0 -lag-in-frames 16 -auto-alt-ref 1 -qcomp 1 -b:v 1000K -an -sn -y -f webm -pass 1 NUL
# ffmpeg -i input.mp4 -ss START -to END -c:v libvpx -threads 3 -quality good -cpu-used 0 -lag-in-frames 16 -auto-alt-ref 1 -qcomp 1 -b:v 1000K -an -sn -y -f webm -pass 2 output.webm
# The numerical values themselves need to be adjusted for each webm. Both commands need to be identical except for their last parameters. You can easily predict what bitrate you're going to need in order to get a file of a certain filesize with this formula: FileSize*8/Time. FileSize is in KB and time is in seconds. If I want a 3000 kB WebM which is 15 seconds long, its target bitrate would be 3000*8/15 = 1600 kB. So the parameter we would have to use would be -b:v 1600K.

# /g/entoomen should use /dev/null instead of NUL.

set -e
set -x

infile="$(realpath "$1")"
name=$(basename "$infile")
name=${name%%\.*}

outfile="webm-${name}.webm"

indur=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$infile")

bitrate=$(echo 4000 \* 8 / "$indur" | bc)

FFMPEG="ffmpeg"

dir="converted"

if [ -d $dir ]; then
    echo "directory \"$dir\" exists"
else
    mkdir $dir
fi

cd $dir

$FFMPEG -i "$infile" -c:v libvpx -threads 3 -quality good -cpu-used 0 -lag-in-frames 16 -auto-alt-ref 1 -qcomp 1 -b:v "${bitrate}"k -y -f webm -pass 1 NUL
$FFMPEG -i "$infile" -c:v libvpx -threads 3 -quality good -cpu-used 0 -lag-in-frames 16 -auto-alt-ref 1 -qcomp 1 -b:v "${bitrate}"k -y -f webm -pass 2 "$outfile"

mpv-ss-1x2() {
    du -h "$1" "$2"
    mpv "$1" --external-file="$2" --lavfi-complex='[vid1] [vid2] hstack [vo]'
}

mpv-ss-1x2 "$infile" "$outfile"

cd ..
