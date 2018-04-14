# Stegextract
Bash script to extract hidden files and strings from images.

## Description
Stegextract will detect the input image type and will look for any trailing data after the closing bytes.<br>
It will then try to detect and extract embedded files by magic numbers. Short byte combinations such as JPEG's `FFD8 FFE0`
might sometimes create false positives.<br>
Stegextract is not the solution for any color/pixel/filter/LSB related Steganography.<br>
Also, manually reviewing the hexdump is sometimes inevitable in cases of highly complex embedded files.

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
--force-format            Force this image format instead of detecting
-o, --outfile             Specify an outfile

```
## POC:
![poc](poc.gif)

The above runs on the `flag.gif` image from the `examples` folder.
