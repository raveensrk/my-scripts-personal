#!/bin/bash

# Download music from youtube

# pushd "/mnt/HDD-1TB/Music Collections/Music"

yt-dlp \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    -i \
    --embed-thumbnail \
    --metadata-from-title  "%(artist)s  -  %(title)s" \
    "$1" \

 #        --external-downloader axel \


    
    
