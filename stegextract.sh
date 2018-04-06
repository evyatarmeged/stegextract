#!/usr/bin/env bash


if [ $# -eq 0 ]; then
  echo "Usage: stegextract <file> [options]"
  echo "stegextract -h for help"
	exit 0
fi

while (( "$#" )); do
  case "$1" in
    -h|--help)
      echo "Extract hidden data from images"
      echo " "
      echo "Usage: stegextract <file> [options]"
      echo "-h, --help                Print this and exit"
      echo "--force-format            Force this image format instead of detecting"
      echo "-o, --outfile             Specify an outfile"
      exit 0
			;;
    "-o"|"--outfile")
      outfile=$2
      shift 2
      ;;
    "--force-format")
      ext=$2
      shift 2
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      image="$1"
      shift
      ;;
  esac
done

if [ ! -f $image ]; then
  echo "$0: File $image not found."
  exit 1
fi

if [ -z ${outfile+x} ]; then
 outfile=${image%.*}"_dumps";
fi

jpeg() {
	# Grab everything after 0xFF 0xD9
	echo "Detected image format: JPG";
	xxd -c1 -p $image | tr "\n" " " | sed -n -e "s/.*\( ff d9 \)\(.*\).*/\2/p" | xxd -r -p > $outfile
}

png() {
	# Grab everything after "IEND.B`" chunk
	echo "Detected image format: PNG";
	xxd -c1 -p $image | tr "\n" " " | sed -n -e "s/.*\( 49 45 4e 44 ae 42 60 82\)\(.*\).*/\2/p" | xxd -r -p > $outfile
}

gif() {
	# Grab everything after "0x00 0x3B"
	echo "Detected image format: GIF"
	xxd -c1 -p $image | tr "\n" " " | sed -n -e "s/.*\( 00 3b\)\(.*\).*/\2/p" | xxd -r -p > $outfile
}

if [[ ! -z ${ext+x} ]]; then
	case ${ext,,} in
  # Lazy format detection
	"jpg"|"jpeg")
		jpeg
		;;
	"png")
		png
		;;
	"gif")
		gif
		;;
	*)
		echo "Unsupported image format"
		exit 1
		;;
	esac
else
	# Look for SOI bytes in xxd output to detect image type
	HEAD=$(xxd $image 2> /dev/null  | head)
	if [[ $(grep IHDR <<< $HEAD) ]]; then
		png
	elif [[ $(grep ffd8 <<< $HEAD) ]]; then
		jpeg
	elif [[ $(grep GIF89a <<< $HEAD) ]]; then
		gif
	else
		echo "Cannot recognize image format"
		exit 1
	fi
fi

data=$(file $outfile)
data=${data##*:}
result=$(echo $data | head -n1 | sed -e 's/\s.*$//')
if [ $result = "empty" ]; then
	echo "No hidden data found in file";
	rm $outfile
	exit 1
else
	echo "Extracted hidden file data: "$data
	echo "Extracting strings..."
	strings -6 $image > $outfile"_strings"
	echo "Done"
fi