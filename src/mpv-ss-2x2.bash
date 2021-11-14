#!/bin/bash

# Play 4 videos side by side 2x2

[ `command -v mpv.exe` ] && mpv="mpv.exe" || mpv="mpv"
$mpv "$1" --external-file="$2" --external-file="$3" --external-file="$4" --lavfi-complex='[vid1] [vid2] hstack [t1]; [vid3] [vid4] hstack [t2]; [t1] [t2] vstack [vo]'
