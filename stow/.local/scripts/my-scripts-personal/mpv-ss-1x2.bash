#!/bin/bash

# Play 2 videos side by side

[ `command -v mpv.exe` ] && mpv="mpv.exe" || mpv="mpv"
$mpv "$1" --external-file="$2" --lavfi-complex='[vid1] [vid2] hstack [vo]'
