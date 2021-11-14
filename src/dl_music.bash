#!/bin/bash

# Download music from youtube

youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 "$1" --add-metadata -i
