#!/bin/bash

set -e 
# set -x 

usage () { 
    echo "This benchmark is done for mp4 encoding..."
    echo "./presets_benchmark -i input.ext" 
}

while [ "$1" != "" ]; do
    # echo 1 $1
    case "$1" in
        -i) 
            shift 
            # echo 2 $1
            in="$1"
            echo input file = "$in"
            shift
            ;; 
        -ext) 
            shift 
            # echo 3 $1
            ext="$1"
            echo Output extension is "$ext".
            read -p "Proceed [y/n]:" proceed
            if [[ $proceed == y ]]; then
                echo Proceeding...
            else
                exit
            fi
            shift
            ;;
        *)
            echo ERROR! Check Usage...
            usage
            exit 2
            ;;
    esac
done



[ -d benchmark_results ] || mkdir benchmark_results


pushd benchmark_results

rm -rf *

if [[ "$in" == "" ]]; then
    cp "../samples/in.webm" .
    in="in.webm"
fi

if [[ $ext == "" ]]; then
    ext="mp4"
fi

/usr/bin/time -f %e --output=1_veryslow_time.log   ffmpeg -y -i "$in" -preset veryslow       1_veryslow.$ext    2>&1 | tee 1_veryslow.log
/usr/bin/time -f %e --output=2_slower_time.log     ffmpeg -y -i "$in" -preset slower         2_slower.$ext      2>&1 | tee 2_slower.log
/usr/bin/time -f %e --output=3_slow_time.log       ffmpeg -y -i "$in" -preset slow           3_slow.$ext        2>&1 | tee 3_slow.log 
/usr/bin/time -f %e --output=4_medium_time.log     ffmpeg -y -i "$in" -preset medium         4_medium.$ext      2>&1 | tee 4_medium.log 
/usr/bin/time -f %e --output=5_fast_time.log       ffmpeg -y -i "$in" -preset fast           5_fast.$ext        2>&1 | tee 5_fast.log 
/usr/bin/time -f %e --output=6_faster_time.log     ffmpeg -y -i "$in" -preset faster         6_faster.$ext      2>&1 | tee 6_faster.log 
/usr/bin/time -f %e --output=7_veryfast_time.log   ffmpeg -y -i "$in" -preset veryfast       7_veryfast.$ext    2>&1 | tee 7_veryfast.log 
/usr/bin/time -f %e --output=8_superfast_time.log  ffmpeg -y -i "$in" -preset superfast      8_superfast.$ext   2>&1 | tee 8_superfast.log 
/usr/bin/time -f %e --output=9_ultrafast_time.log  ffmpeg -y -i "$in" -preset ultrafast      9_ultrafast.$ext   2>&1 | tee 9_ultrafast.log 
popd
