#!/bin/bash

set -x
set -e

if [ "$1" = --help ]; then
    echo Go to the dir containing video files. Execute this script. This script will convert all 21:9 videos into 16:9.
    exit 0
fi

# case "$1" in
#     --help)
#         echo Go to the dir containing video files. Execute this script. This script will convert all 21:9 videos into 16:9.
#         exit 0
#         ;;
#     *)
#         echo Unknown Option
#         exit 2
#         ;;
# esac

for file in *; do
    21x9_to_16x9_converter.bash -i "$file"
done
