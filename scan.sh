#!/bin/bash
#set -x

# REQUIRES:
#
# scanner configured with sane
# imagemagick
# tesseract-ocr
# tesseract-ocr-eng

TEMP_DIR=$(mktemp -d)
PREFIX=$1

if [ -z "${OUTPUT_DIR}" ]; then
  OUTPUT_DIR=`pwd`
fi

# UNCOMMENT FOR TESTING
#mkdir processed
#TEMP_DIR=`pwd`/processed
echo "Temp dir: $TEMP_DIR"
echo "Output dir: $OUTPUT_DIR"

# Scan the document
scanadf -o $TEMP_DIR/$PREFIX-%d.pbm --source "Automatic Document Feeder(left aligned,Duplex)" --mode "24 bit Color" 

# Convert to PNG and rotate 180
find $TEMP_DIR -name "$PREFIX-*.pbm" \
  | xargs -I {} basename {} .pbm \
  | xargs -P 4 -I {} convert -rotate 180 $TEMP_DIR/{}.pbm $TEMP_DIR/{}.png 
rm $TEMP_DIR/*.pbm

# Reverses the numeric order of the files. Needed because the output of
# adfscan makes the first page scanned the last.
reverse() {
	PREFIX=$1
	TEMP_DIR=$2
	# create a temporary directory
	mkdir -p $TEMP_DIR/reverse

	# Reverse numbers
	images=(`ls $TEMP_DIR/$PREFIX*.png | sort -V`)
	max=${#images[*]}

	# loop through array keys and subtract the key from maximum number to reverse
	for i in "${!images[@]}"; do 
	  # rename to the temporary directory, with three-digit zero padding
	  mv -- "${images[$i]}" $TEMP_DIR/reverse/$(printf "$PREFIX-%03d.png" $(($max - i)))
	done

	# move files back and remove temporary directory
	mv $TEMP_DIR/reverse/*.png $TEMP_DIR
	rm -rf $TEMP_DIR/reverse
}

reverse $PREFIX $TEMP_DIR

# Create the searchable pdf
ls $TEMP_DIR/$PREFIX*.png | tesseract - "$OUTPUT_DIR/$(date "+%Y-%m-%d")-$PREFIX" pdf

# Done!
rm -rf $TEMP_DIR
exit
