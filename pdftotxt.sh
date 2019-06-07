#!/bin/bash
# Bash shell script to convert PDF files to .txt files using XpdfReader and Tesseract
# XpdfReader and Tesseract should be downloaded and installed
# This script developed using XpdfReader 4.0.0 and Tesseract 4.00
set -e

# Copy this file to folder with all PDF files to be converted in subfolder /pdfs
DIR="pdfs"

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
for f in $FILES
do
  echo "Processing $f file..."
  txtfile=`echo $f | cut -d'.' -f1`
  tesseract $f stdout >> "${txtfile}.txt"
  echo "============== END OF PAGE" >> "${txtfile}.txt"
done

# Create output directory in /pdfs, move all .txt files to output directory, delete .png files
mkdir ${DIR}/output_$timestamp
mv ${DIR}/*.txt ${DIR}/output_$timestamp
rm ${DIR}/*.png
echo "PDFtoTXT done."
