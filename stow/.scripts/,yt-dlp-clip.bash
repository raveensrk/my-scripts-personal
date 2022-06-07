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
        --mp3)
            mp3="1"
            ;;
        --mp3-only)
            mp3_only="1"
            ;;
        --scale-width)
            shift
            scale="-vf scale=$1:-2"
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


yt-dlp --write-subs --write-auto-subs --no-playlist -f "bv+ba/b" "$url" --restrict-filenames --merge-output-format mp4 -o %\(title\)s_%\(id\)s.%\(ext\)s

if [ "$ss" = "" ] && [ "$to" = "" ]; then
    orig_file_name="orig_${file_name}"
    mv "${file_name}" "$orig_file_name"

    if [ "$scale" != "" ]; then
        tmp="tmp.mp4"
        mv "$orig_file_name" "$tmp" 
        ffmpeg -i "$tmp" -preset veryfast $scale "$orig_file_name"
        rm "$tmp"
    fi

    if [ ! "$mp3_only" = "1" ]; then
        out="${file_name}.mp4"
        ffmpeg -i "$orig_file_name" -preset veryfast "$out"
    fi

    if [ "$mp3" = "1" ] || [ "$mp3_only" = "1" ]; then
        out2="${file_name}.mp3"
        ffmpeg -i "$orig_file_name" -preset veryfast "$out2"
    fi

    rm "${orig_file_name}"
else
    clip_time=$(echo "clip_ss_${ss}_to_${to}" | tr ":" "-")
    echo $clip_time
    out="${clip_time}_${file_name}"
    echo $out
    ss="-ss $ss"
    to="-to $to"
    ffmpeg $ss $to -i "$file_name" -preset veryfast "$out"
fi


if [ ! "$mp3_only" = "1" ]; then
    mpv "$out"
fi

if [ "$mp3" = "1" ] || [ "$mp3_only" = "1" ]; then
    mpv "$out2"
fi

