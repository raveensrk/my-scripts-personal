#!/bin/bash

while [ "$1" ]; do
    case "$1" in
        --url)
            shift
            url="$1"
            ;;
        --ss)
            shift
            ss="$1"
            ;;
        --to)
            shift
            to="$1"
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

if [ "$ss" = "" ] && [ "$to" = "" ]; then
    
else
clip_time=$(echo "clip_ss_${ss}_to_${to}" | tr ":" "-")
echo $clip_time
out="${clip_time}_${file_name}"
echo $out
ss="-ss $ss"
to="-to $to"
fi


ffmpeg $ss $to -i "$file_name" -preset veryfast "$out"

open "$out"

