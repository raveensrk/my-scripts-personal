convert -size 200x150 xc:orange -font monospace -pointsize 100 -fill red -annotate +20+80 'KX' -fill black -annotate +23+83 'KX' -trim +repage logo.png

convert logo.png -resize 150x150 -gravity center -background black  -extent 150x150 logo2.png
