#!/bin/bash

while [ "$1" ]; do
    case "$1" in
        --url)
            shift
            url="$1"
            ;;
        --ss)
            shift
            ss="-ss $1"
            ;;
        --to)
            shift
            to="-to $1"
            ;;
        --help|-h)
            help
            exit 0
            ;;
        *)
            echo -e "${RED}Wrong option!${NC}"
            exit 2
            ;;
    esac
    shift
done 

[ "$url" = "" ] && echo -e "${RED}Missing --url option...${NC}" && exit 2

# yt-dlp -f "bv+ba/b" "$url" --get-filename --restrict-filenames --merge-output-format mp4 -o %(title)s_%(id)s.%(ext)s --ppa "ffmpeg_i1:$ss $to"
file_name=$(yt-dlp --no-playlist -f "bv+ba/b" "$url" --get-filename --restrict-filenames --merge-output-format mp4 -o %\(title\)s_%\(id\)s.%\(ext\)s)
yt-dlp --no-playlist -f "bv+ba/b" "$url" --restrict-filenames --merge-output-format mp4 -o %\(title\)s_%\(id\)s.%\(ext\)s
ffmpeg $ss $to -i "$file_name" -preset veryslow "clip_${file_name}"
open "clip_${file_name}"
