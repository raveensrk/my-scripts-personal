#!/bin/bash

pushd $HOME

case "$1" in
    *mkv|*webm|*mp4|*mp3|*flac|*opus|*mp3?source*|*youtube.com/watch*|*youtube.com/playlist*|*youtu.be*)
        youtube-dl -o "~/tmp/%(title)s.%(ext)s" "$1" ;;
    *png|*jpg|*jpeg|*gif|*svg)
        wget -P ~/tmp/ "$1"
        gwenview "tmp/${1##*/}" ;;
    *pdf)
        wget -P ~/tmp/ "$1"
        firefox "tmp/${0##*/}" ;;
    *)
        firefox $1 ;;
esac

popd
