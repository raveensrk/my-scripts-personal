#!/bin/bash

# This script will get a youtube channels rss feed


get () {
    url="$1"
    rss="${url##*/}"
    rss="https://www.youtube.com/feeds/videos.xml?channel_id=${rss}"
    echo $rss
}

get "$1"
