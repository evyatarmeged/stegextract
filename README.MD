# Stegextract
Extract hidden files and strings from image

## Description
Stegextract will detect the image type and will look for any trailing data after the image closing bytes.<br>
Stegextract can detect basic hidden files but is not the solution for any color/pixel/filter/LSB related Steganography.<br>
Also, manually reviewing the hexdump is sometimes inevitable in cases of highly complex embedded files.
Currently supports JPG, PNG, and GIF.

## Installation
```
sudo curl https://github.com/evyatarmeged/stegextract/blob/master/stegextract.sh > /bin/stegextract
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
