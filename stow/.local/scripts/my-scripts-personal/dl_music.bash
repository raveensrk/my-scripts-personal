#!/bin/bash

# Download music from youtube

pushd "/mnt/HDD-1TB/Music Collections/Music"

youtube-dl \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 "$1" \
    --add-metadata \
    -i \
    --embed-thumbnail \
    --metadata-from-title  "%(artist)s  -  %(title)s" \
    
    
