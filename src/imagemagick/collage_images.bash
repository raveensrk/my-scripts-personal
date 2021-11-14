#!/bin/bash

# This script will create a verical collage of thhe the images provided
# (WxH)
# Max output size = 1000x1000
# Max imput size = 500x

set -x

files="$(find -name "plot_fft.jpg" | xargs)"
outname="montage.jpg"

oargs="-size 1920x"
iargs="-geometry 1000x"
gm montage -font ps:helvetica:25 -fill red -label "%i" -tile 1x3 $iargs $files $outname
