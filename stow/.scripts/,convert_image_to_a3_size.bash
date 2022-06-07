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
echo x-offset = $x
echo y-offset = $y
echo input image = $(realpath "$in")

tmp="tmp.jpg"
convert "$in" -resize x3508 "$tmp"
out="resized_to_a3_$in"
convert "$tmp" -gravity center -crop 4961x+$x+$y "$out"
rm "$tmp"

echo "Done conversion. Output saved at:
$(realpath "$out")
"
