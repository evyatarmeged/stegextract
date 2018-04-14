# Stegextract
Bash script to extract hidden files and strings from images.

## Description
Stegextract will detect the input image type and will look for any trailing data after the closing bytes.<br>
If ran with `-a, --analyze` It will also try to detect embedded files by magic numbers.
Short byte combinations such as JPEG's `FFD8 FFE0` might sometimes create false positives.<br>
Manually reviewing the hexdump is sometimes inevitable in cases of highly complex embedded files.<br>
Stegextract is not the solution for any color/pixel/filter/LSB related Steganography, nor does it try to be. It
relies on magic numbers, hexdumps and binary data alone.<br>

## Supported Formats
##### Input Images
- PNG
- JPG
- GIF
##### Embedded File Lookup
- PNG
- JPG
- GIF
- RAR
- ZIP

## Installation
```
sudo curl https://raw.githubusercontent.com/evyatarmeged/stegextract/master/stegextract.sh > /bin/stegextract
sudo chmod +x /bin/stegextract
```

## Usage
```
stegextract <file> [options]
-h, --help                Print this and exit
-o, --outfile             Specify an outfile
-a, --analyze             Perform a deep analysis of embedded files
--force-format            Force this image format instead of detecting
```

## POC:
![poc](poc.gif)

The above runs on the `flag.gif` image from the `examples` folder.
