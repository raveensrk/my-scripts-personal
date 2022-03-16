#!/bin/bash

set -e
set -x

# A script to concat videos with the string concat.mp4

# read -p "Enter file extention to concat, for example \"mp4\": " ext
ls -1 | grep -v "concat.mp4" | sed "s/^/file '/g" | sed "s/$/'/g" > .concat.txt
cat .concat.txt

read -p "Continue press enter or exit with Ctrl-c"

# preset="-codec copy"
# preset="-vf scale=1920:-2 -preset veryfast"
preset="-vf fps=30 -preset veryfast"

ffmpeg -f concat -safe 0 -i .concat.txt $preset concat.mp4

# or
# ffmpeg -f concat -safe 0 -i <(printf "file '$PWD/%s'\n" ./*.wav) -c copy output.wav
