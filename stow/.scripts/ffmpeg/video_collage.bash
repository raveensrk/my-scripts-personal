#!/bin/bash

# This script creates a side by side view from 2 videos, gifs or images

# History
# v1: Supports video files
# v2: TODO: GIFS

date1() {
    date +%Y%m%d%H%M%S
}

set -e
# set -x

usage() {
    echo "
    USAGE:

    -h
        Help
    -i
        input file
    -I
        Input Args
    -c
        crop
        Default crop = width = 1080
        For no crop pass iw
    -s
        Use the shortest time
    -v
        Use vstack
    "
}

crop="1080"
preset="-preset ultrafast"

while [ "$1" ]; do
    case "$1" in
        -h)
            shift
            echo "Showing usage!"
            usage
            exit 0
        ;;
        -i)
            shift
            file=$(realpath "$1")
            if [[ -f "$file" ]]; then
                echo File found. Proceeding...
            else
                echo No file found!!!
                exit 2
            fi
            input+=("$(realpath "$1")")
            shift
        ;;
        -I)
            shift
            opts+=("$1")
            shift
        ;;
        -f)
            shift
            filter+=("$1")
            shift
        ;;
        -c)
            shift
            echo "$1"
            crop="$1"
            shift
        ;;
        -s)
            shift
            short="short"
        ;;
        -v)
            shift
            stack="vstack"
        ;;
        *)
            shift
            echo "Invalid option: \"$1\""
            echo "Check usage..."
            usage
            exit 2
        ;;
    esac
done

if [[ $stack == "" ]]; then
    stack="hstack"
fi

in0="${input[0]}"
in1="${input[1]}"

echo "${in0}"
echo "${in1}"

in0_ext="${in0##*\.}"
echo "${in0_ext}"
in1_ext="${in1##*\.}"
echo "${in1_ext}"

case $in0_ext in
    gif)
        echo 'Converting in0 gif to mp4...'
        ffmpeg -i "$in0" -vf scale=-2:1080 $preset in0.mp4
        in0="in0.mp4"
    ;;
    png | jpg | jpeg)
        echo 'Converting in0 image to mp4...'
        ffmpeg -framerate 1 -i "$in0" -vf scale=-2:1080 $preset in0.mp4
        in0="in0.mp4"
    ;;
esac

case $in1_ext in
    gif)
        echo 'Converting in1 gif to mp4...'
        ffmpeg -i "$in1" -vf scale=-2:1080 $preset in1.mp4
        in1="in1.mp4"
    ;;
    png | jpg | jpeg)
        echo 'Converting in1 image to mp4...'
        ffmpeg -framerate 1 -i "$in1" -vf scale=-2:1080 $preset in1.mp4
        in1="in1.mp4"
    ;;
esac

in0_ext="${in0##*\.}"
echo "${in0_ext}"
in1_ext="${in1##*\.}"
echo "${in1_ext}"

if [[ $in0_ext != "gif" ]]; then
    if [[ $in1_ext != "gif" ]]; then
        in0_dur=$(echo $(mediainfo --Inform="Video;%Duration%" "$in0") | bc)
        in0_dur=$(echo "($in0_dur/1)" | bc)
        
        echo in0_dur = $in0_dur
        
        in1_dur=$(echo $(mediainfo --Inform="Video;%Duration%" "$in1") | bc)
        in1_dur=$(echo "($in1_dur/1)" | bc)
        
        echo in1_dur = $in1_dur
        
        # Divide / 1 to remove fractional part of the duration from mediainfo
        # Media info prints fractions for videos in seconds
        
        # Take Shortest time of the 2x input time
        if [[ $short == short ]]; then
            if [[ $in0_dur -ge $in1_dur ]]; then
                out_dur="${in1_dur}ms"
            else
                out_dur="${in0_dur}ms"
            fi
        else
            if [[ $in0_dur -ge $in1_dur ]]; then
                out_dur="${in0_dur}ms"
            else
                out_dur="${in1_dur}ms"
            fi
        fi
    fi
else
    out_dur=""
fi

echo out_dur = "$out_dur"
echo crop option = "$crop"

# Check if the files has audio streams

in0_audio_streams=$(ffprobe -i "$in0" -show_streams -select_streams a -loglevel error | wc -l)
in1_audio_streams=$(ffprobe -i "$in1" -show_streams -select_streams a -loglevel error | wc -l)

if [ "$in0_audio_streams" -eq 0 ]; then
    echo "in0_audio_streams is empty"
    if [ "$in1_audio_streams" -eq 0 ]; then
        echo "in1_audio_streams is empty"
        amerge=""
    else
        echo "in1_audio_streams is present"
        amerge=";[1:a]amerge=inputs=1[a]"
        amap="-map [a]"
    fi
    
else
    echo "in0_audio_streams is present"
    if [ "$in1_audio_streams" -eq 0 ]; then
        echo "in1_audio_streams is empty"
        amerge=";[0:a]amerge=inputs=1[a]"
        amap="-map [a]"
    else
        echo "in1_audio_streams is present"
        amerge=";[0:a][1:a]amerge=inputs=2[a]"
        amap="-map [a]"
    fi
fi

if [[ $stack == "vstack" ]]; then
    scale="1920:-2"
else
    scale="-2:1080"
fi

ffmpeg -stream_loop -1 -i "$in0" -stream_loop -1 -i "$in1" \
-filter_complex \
"[0:v] scale=$scale,crop='min($crop,iw)':ih:270:0 [left]; \
    [1:v] scale=$scale,crop='min($crop,iw)':ih:270:0 [right]; \
[left][right] $stack=inputs=2 [left+right] $amerge" -map [left+right] $amap -t "$out_dur" $preset -r 60 out.mp4

ffmpeg -i out.mp4 -q:v 1 -vframes 1 $preset out.jpg

if [ "$(command -v mpv.exe)" ]; then
    echo "command \"mpv.exe\" exists on system"
    mpv.exe --loop=inf out.mp4
    explorer.exe .
fi

echo "Do you Want to Rename? y/n:"
read -r choice

if [[ $choice == y ]]; then
    echo "Enter name:"
    read -r oname
    oname="$oname-out-$(date1).mp4"
    mv out.mp4 "$oname"
    echo Output file location = $(realpath $oname)
else
    echo Output file location = $(realpath out.mp4)
fi
