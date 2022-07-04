#!/opt/homebrew/bin/bash

# https://trac.ffmpeg.org/wiki/HowToBurnSubtitlesIntoVideo

help () {
    echo "Look inside the file."
}


while [ "$1" ]; do
    case "$1" in
        --help|-h)
            help
            exit 0
            ;;
        --input|-i)
            shift
            input_file="$1"
            ;;
        --subtitle|-s)
            shift
            subtitle_file="$1"
            ;;
        --ss)
            shift
            ss="-ss $1"
            ;;
        --to)
            shift
            to="-to $1"
            ;;
        --output|-o)
            shift
            output="$1"
            ;;
        *)
            echo "Wrong Argument...!"
            help
            exit 2
            ;;
    esac
    shift
done

ffmpeg $ss $to -copyts \
       -i "$input_file" \
       $ss $to \
       -vf subtitles="$subtitle_file" \
       -preset veryslow \
       "$output" \
    && \
    open "$output"
