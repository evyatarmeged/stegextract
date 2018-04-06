#!/usr/bin/env bash


if [ $# -eq 0 ]; then
  echo "Usage: stegextract <file>"
	exit 1
fi

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$package - Extract hidden data from images"
      echo " "
      echo "Usage: stegextract <file> [options]"
      echo "-h, --help                Print this and exit"
      echo "--force-format            Use this image format instead of detecting"
      echo "-o, --outfile             Specify an outfile"
      exit 0
      ;;
		--force-format)
      shift
      ext=$1
      ;;
    -o|--output)
      shift
      dumpfile=$1
      ;;
  *)
    echo "$1 is not a recognized flag"
    exit 1
	esac
done


extract() {
	# This is for Rar! currently
	xxd -c1 -p $1 | tr "\n" " " | sed -n -e 's/.*\( 52 61 72 21 \)\(.*\).*/\2/p' | xxd -r -p > outfile;
	rm $dumpfile
#	data=$(file $dumpfile)
#	echo 'Extracted file data: '${data##*:}
}

jpeg() {
	echo 'JPG image detected';
	output=$(xxd -c1 -p $1 | tr "\n" " " | sed -n -e 's/.*\( ff d9 \)\(.*\).*/\2/p' | xxd -r -p > $dumpfile)
	extract $dumpfile
}

png() {
	echo 'PNG image detected';
	output=$(xxd -c1 -p $1 | tr "\n" " " | sed -n -e 's/.*\( 49 45 4e 44 ae 42 60 82 \)\(.*\).*/\2/p' | xxd -r -p)
	extract $output
}



case ${ext,,} in
  # Lazy format detection
	'jpg'|'jpeg')
		jpeg $1
		;;
	'png')
		png $1
		;;
	'gif')
		echo 'gif'
		;;
	*)
		echo 'Unsupported image format'
		exit 1
		;;
esac


echo 'Extracting strings...'
strings $1 > $dumpfile'_strings'
echo 'Done'