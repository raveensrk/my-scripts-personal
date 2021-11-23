#!/bin/bash

set +x

path_to_face_img="/path/face.jpg"

for file in $( realpath $2 ); do
    echo Checking: $file
    facedetect -q --search $path_to_face_img $file
    echo $?
    # if [[ $? -eq 0 ]]; then
    #     echo Found Status:  0
    #     echo $file > found.log
    # else
    #     echo Found Status: !0
    # fi
done


for file in $( realpath $2 ); do
    echo Checking $file
    awk -F ',' '{print $2}' $(face_recognition $1 $2)
    echo $?
    # | grep -v "unknown_person" | grep -v "no_persons_found"
done
