#!/bin/bash

set -e
set -x

# read -p "Enter file extention to concat, for example \"mp4\": " ext
ls -1 | grep -v "concat.mp4"  > .concat.txt
sed -i "s/^/file '/g" .concat.txt
sed -i "s/$/'/g" .concat.txt
cat .concat.txt

read -p "Continue press enter or exit with Ctrl-c"

preset="-codec copy"
# preset="-vf scale=1920:-2 -preset veryfast"

ffmpeg -f concat -safe 0 -i .concat.txt $preset concat.mp4

# or
# ffmpeg -f concat -safe 0 -i <(printf "file '$PWD/%s'\n" ./*.wav) -c copy output.wav
