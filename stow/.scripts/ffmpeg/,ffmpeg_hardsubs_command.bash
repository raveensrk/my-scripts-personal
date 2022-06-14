#!/opt/homebrew/bin/bash

# https://trac.ffmpeg.org/wiki/HowToBurnSubtitlesIntoVideo

help () {

    echo "Look inside the file."

}


while [ "$1" ]; do
    case "$1" in
        --help|-h)
            help
            ;;
        *)
            echo "Wrong Argument...!"
            help
            exit 2
            
    esac
    shift
done

ffmpeg -ss 07:00 -to 07:20 -copyts \
       -i "$input_file" \
       -ss 07:00 -to 07:20 \
       -vf subtitles="$subtitles_file" \
       -preset veryfast \
       "$out" \
    && \
    open the_boys_s0304_printing_money.mp4
