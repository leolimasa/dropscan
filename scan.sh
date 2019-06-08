#!/bin/bashs

# REQUIRES:
#
# scanner configured with sane
# imagemagick
# tesseract-ocr
# tesseract-ocr-eng

# Scan the document
scanadf -o $1-%d.pbm --source "Automatic Document Feeder(left aligned,Duplex)" --mode "24 bit Color" 

# Convert to PNG
#for FILENAME in $(ls *.pbm); do convert -rotate 180 $FILENAME ${FILENAME%.*}.png ;done
#rm *.pbm

reverse() {
	# create a temporary directory
	mkdir -p ./tmp

	# Reverse numbers
	images=(*.png)
	max=${#images[*]}

	# loop through array keys and subtract the key from maximum number to reverse
	for i in "${!images[@]}"; do 
	  # rename to the temporary directory, with three-digit zero padding
	  mv -- "${images[$i]}" ./tmp/$(printf "$1-%03d.png" $(($max - i)))
	done

	# move files back and remove temporary directory
	mv ./tmp/*.png .
	rmdir ./tmp
}

#reverse $1
