#!/bin/bash

# This script will take all the files in the input argument and crop to the
# width and height specified
# WxH+x+y
# WxH = size of the crop
# x and y pixel location should be the top left pixel of the crop,
# from the bottom left pixel of the image

gm convert "$1" -crop 307x60+857+471 "cropped-$1"
