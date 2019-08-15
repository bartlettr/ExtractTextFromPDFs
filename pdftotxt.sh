#!/bin/bash
# Bash shell script to remove special characters from PDF filenames and replace spaces with underscores
# Then convert each renamed PDF file to a .txt file using XpdfReader and Tesseract
# Script developed using XpdfReader 4.0.0 and Tesseract 4.00 in Mac OS 10.14.3

# SETUP
# XpdfReader and Tesseract should be downloaded and installed
# This .sh file should be in a home directory (e.g. /home)
# All PDF files to be renamed should be in directory /home/pdfs
# Run shell script (e.g. open Terminal, *cd* to project directory, and enter command *sh pdftotxt.sh*)

set -e

# Rename PDF files to eliminate special characters and spaces
cd pdfs
mkdir -p renamedPDFs #make new directory pdfs/renamedPDFs, unless it already exists

FILES=*.pdf
for f in $FILES
do
 newfilename=`echo ${f%????}` #remove file extension (last 4 chracters) from original filename
 newfilename=`echo ${newfilename//[-.(),]/}` #remove dots, commas, parentheses, dashes from filename
 newfilename=`echo ${newfilename// /_}` #replace spaces with underscores
 cp "${f}" "renamedPDFs/${newfilename}.pdf"
 echo "${f} renaming and copying complete"
done

echo "All files renamed and copied into renamedPDFs directory."

# Start OCR process with XpdfReader and Tesseract

# Directory to be used for PDF to TXT conversion is /renamedPDFs
DIR="renamedPDFs"

# Get timestamp
timestamp=$(date "+%Y%m%d-%H%M%S")
echo $timestamp

# Uses PDFtoPNG command of XpdfReader to convert each page in each PDF to a PNG file
FILES=${DIR}/*.pdf
for f in $FILES
do
 echo "Processing $f file..."
 pdftopng $f $f
done

# Uses Tesseract to convert each PNG to .txt, appending based on filename and adding End Of Page tag
# which results in one .txt per original PDF file
FILES=${DIR}/*.png
p=0 #set page number to 0
for f in $FILES
do
  echo "Processing $f file..."
  txtfile=`echo $f | cut -d'.' -f1` #create filename variable which is PNG filename without numbers or file extension
    if [ ! -f "${txtfile}.txt" ]; then #if .txt document for this filename does not yet exist, restart page count
      p=1
    fi
  tesseract $f stdout >> "${txtfile}.txt" #tesseract OCR output to filename.txt, appending future outputs
  echo "<<<END OF PAGE $p>>>" >> "${txtfile}.txt" #add page number
  ((p++)) #increment page number variable
done

# Create output directory in /pdfs, move all .txt files to output directory, delete .png files
mkdir ${DIR}/output_$timestamp #include timestamp in output folder name for clarity
mv ${DIR}/*.txt ${DIR}/output_$timestamp
rm ${DIR}/*.png
echo "PDFtoTXT done."
