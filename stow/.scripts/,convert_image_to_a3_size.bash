#!/bin/bash

help () {
    echo "
+-----+
|Usage|
+-----+
,convert_image_to_a3_size.bash -i image.jpg

+--------+
|Optional|
+--------+
-x \$x-offset
-y \$y-offset
Default value is \"0\" for both
"

}

while [ "$1" ]; do
    case "$1" in
        --input|-i)
            shift
            in="$1"
            ;;
        --center-fit|-cf)
            cf="yes"
            ;;
        --debug|-d)
            set -x
            ;;
        --x-offest|-x)
            shift
            x="${1}"
            ;;
        --y-offest|-y)
            shift
            y="${1}"
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

x=${x:-0}
y=${y:-0}
cf=${cf:-no}
echo x-offset = $x
echo y-offset = $y
echo input image = $(realpath "$in")

out="resized_to_a3_$in"

if [ "$cf" = "yes" ]; then
    magick "$in" -resize 4961x3508 -background black \
           -compose Copy \
           -gravity center \
           -extent 4961x3508  \
           "$out"
else
    tmp="resized_tmp.jpg"
    convert "$in" -resize x3508 "$tmp"
    convert "$tmp" -gravity center -crop 4961x+$x+$y "$out"
    rm "$tmp"
fi

echo "Done conversion. Output saved at:
$(realpath "$out")
"
