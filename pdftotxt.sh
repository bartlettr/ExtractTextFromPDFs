#!/bin/bash
# Bash shell script to remove special characters from PDF filenames and replace spaces with underscores
# Then convert each page of the renamed PDF file to a .txt file using XpdfReader and Tesseract
# Script developed using XpdfReader 4.0.0 and Tesseract 4.00 in macOS 10.14.3

# TIME: in total, process will take 15-20 seconds per page

# SETUP
# XpdfReader and Tesseract should be downloaded and installed
# This .sh file should be in a home directory (e.g. /home)
# All PDF files to be renamed should be in directory /home/pdfs
# Run shell script (e.g. open Terminal, *cd* to project directory, and enter command *sh pdftotxt.sh* or *sh pdftotxt.sh -eachpage*)

# RESULT
# Home directory will have new directories /home/pdfs/renamedPDFs and /home/pdfs/renamedPDFs/output_[timestamp]
# /home/pdfs/renamedPDFs includes PDF files renamed to eliminate special characters
# /home/pdfs/renamedPDFs/output_[timestamp] includes output .txt file(s)

set -e

# Rename PDF files to eliminate special characters and spaces
cd pdfs
pdffolder="renamedPDFs"
mkdir -p $pdffolder #make new directory pdfs/renamedPDFs, unless it already exists

FILES=*.pdf
for f in $FILES
do
 newfilename="${f%.*}" #remove file extension from original filename
 newfilename=`echo ${newfilename//[-.(),&]/}` #remove dots, commas, parentheses, dashes from filename
 newfilename=`echo ${newfilename// /_}` #replace spaces with underscores
 cp "${f}" "${pdffolder}/${newfilename}.pdf"
 echo "${f} renaming and copying complete"
done

echo "All files renamed and copied into renamedPDFs directory."

# Start OCR process with XpdfReader and Tesseract

# Directory to be used for PDF to TXT conversion is /renamedPDFs
#DIR=${pdffolder}

# Get timestamp
timestamp=$(date "+%Y%m%d-%H%M%S")
echo "Timestamp: $timestamp"
mkdir ${pdffolder}/output_$timestamp #create output directory in /pdfs for output TXT files

if  [[ $1 = "-eachpage" ]]; then
    echo "----------------------------------"
    echo " "
    echo "Option -eachpage turned on"
    echo "Each page in every PDF will produce one .txt file"
    echo " "
    echo "Ctrl-C to exit this process"
    echo " "
    echo "----------------------------------"
    # Uses PDFtoPNG command of XpdfReader to convert each page in each PDF to a PNG file
    FILES=${pdffolder}/*.pdf
    for f in $FILES
    do
     echo "Processing $f file..."
     basefilename=${f%%.*}
     pdftopng $f $basefilename
    done

    # Uses Tesseract to convert each PNG to .txt which results in one .txt per page in the PDF file
    FILES=${pdffolder}/*.png
    for f in $FILES
    do
      echo "Processing $f file..."
      txtfile=`echo $f | cut -d'.' -f1` #create filename variable which is PNG filename without file extension
      tesseract $f stdout >> "${txtfile}.txt" #tesseract OCR output to filename.txt, appending future outputs
      mv ${pdffolder}/*.txt ${pdffolder}/output_$timestamp #move new TXT file to output directory
      rm $f #delete PNG file
    done
else
    echo "----------------------------------"
    echo " "
    echo "You did not use option -eachpage"
    echo "Each PDF file will result in one .txt file"
    echo " "
    echo "Ctrl-C to exit this process"
    echo " "
    echo "----------------------------------"
    # Uses PDFtoPNG command of XpdfReader to convert each page in each PDF to a PNG file
    FILES=${pdffolder}/*.pdf
    for f in $FILES
    do
     echo "Processing $f file..."
     basefilename=${f%%.*}
     pdftopng $f $basefilename
    done

    # Uses Tesseract to convert each PNG to .txt, appending based on filename and adding End Of Page tag
    # which results in one .txt per original PDF file
    FILES=${pdffolder}/*.png
    p=0 #set page number to 0
    for f in $FILES
    do
      echo "Processing $f file..."
      txtfile=`echo $f | cut -d'-' -f1` #create filename variable which is PNG filename before first dash (no numbers or file extension)
        if [ ! -f "${txtfile}.txt" ]; then #if .txt document for this filename does not yet exist, restart page count
          p=1
        fi
      tesseract $f stdout >> "${txtfile}.txt" #tesseract OCR output to filename.txt, appending future outputs

      # Print <<<END OF PAGE $p>>> at end of each page
      # Change echo command below to suit your requirements or comment it out using # symbol
      echo "<<<END OF PAGE $p>>>" >> "${txtfile}.txt" #add page number
      ((p++)) #increment page number variable
    done

    mv ${pdffolder}/*.txt ${pdffolder}/output_$timestamp #move new TXT file to output directory
    rm ${pdffolder}/*.png #delete PNG files
fi

echo "PDFtoTXT done."
