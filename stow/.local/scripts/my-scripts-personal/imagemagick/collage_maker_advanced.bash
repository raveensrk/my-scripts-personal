#!/bin/bash

# set -e
# set -x

date1 () {
    echo $(date +%Y%m%d%H%M%S)
}

echo This script doesnot work properly
exit 2


input=()
while getopts ":s:i:" options; do
    case "${options}" in
        s)
            size=${OPTARG}
            ;;
        i)
            input+=($(realpath $OPTARG))
            ;;
        :)
            echo "Error: -${OPTARG} requires an argument."
            exit 2
            ;;
        *)
            exit 2
            ;;
    esac
done

find_dimensions () {
    input=$1
    w=()
    h=()
    for i in  ${input[@]}; do
        # echo $i
        w+=($(gm identify -format "%w" $i))
        h+=($(gm identify -format "%h" $i))
        # echo ${w[@]}
        # echo ${h[@]}
    done

    maxw=0
    maxh=0
    totalw=0
    totalh=0
    minw=10000
    minh=10000

    for i in ${w[@]}; do
        totalw=$(( $totalw + $i ))
        echo $i
        [[ $maxw -lt $i ]] && maxw=$i;
        [[ $minw -gt $i ]] && minw=$i;
    done

    for i in ${h[@]}; do
        totalh=$(( $totalh + $i ))
        [[ $maxh -lt $i ]] && maxh=$i;
        [[ $minh -gt $i ]] && minh=$i;
    done
    # echo maxw $maxw
    # echo maxh $maxh

    echo $totalw $totalh
}

# find_dimensions ${input[@]}

# size="$1"
# paths="$@"
outname="collage_$(date1).jpg"
mkdir image_collage_output; pushd image_collage_output

mkdir tmp; pushd tmp

cnt=0
resized=()
for i in  ${input[@]}; do
    name="tmp_$cnt.jpg"
    cp $i $name
    gm convert -resize x$maxh $name resized_$name
    # display resized_$name
    resized+=($(realpath "resized_$name"))
    cnt=$(($cnt+1))
done

# cnt=0
# cropped=()
# for i in  ${resized[@]}; do
#     name=$i
#     gm convert -crop ${minw}x$maxh $name cropped_$name
#     cropped+=("cropped_$name")
#     display cropped_$name
#     cnt=$(($cnt+1))
# done

popd

find_dimensions ${input[@]}

# size="${totalw}x${maxh}"
# gm montage -background black -geometry $size  ${resized[@]} -tile 2x tmp_out.jpg
gm montage -background black -geometry x1080 ${input[@]}  tmp_out.jpg
# gm montage -background black $paths -tile 3x3 -geometry 3000x3000  ./collage/collage-$(date1).jpg

display tmp_out.jpg

read -p "Do you want to save? y/n: " choice

if [[ $choice == y ]]; then
    mv tmp_out.jpg $outname
    echo Output file location = `realpath $outname`
else
    echo Output file location = `realpath tmp_out.jpg`
fi

popd
