#!/bin/bash

set -e
set -x

ffmpeg.exe -i "$1" -preset veryfast "reencoded-$1"
