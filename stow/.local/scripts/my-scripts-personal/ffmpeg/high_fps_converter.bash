#!/bin/bash

# Convert videos to 60 fps in webm format vp8

set -x
set -e

date1() {
    date +%Y%m%d%H%M%S
}

IN="$1"

PRESET="-preset veryslow"
CODEC="-c:v libvpx"
SCALE="scale=-2:1080"
OUT="60fps-$(basename "$1").mp4"

[ `command -v ffmpeg.exe` ] && ffmpeg=ffmpeg.exe
[ `command -v mpv.exe` ] && mpv=mpv.exe

$ffmpeg -i "$IN" -filter:v "$SCALE,minterpolate='mi_mode=mci:mc_mode=aobmc:vsbmc=1:fps=60'" $PRESET "$OUT"

$mpv --loop "$OUT"
