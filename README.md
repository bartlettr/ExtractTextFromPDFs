# PDFtoTXT
Bash script for extracting machine-readable text from PDFs using XpdfReader and Tesseract

## Setup

1. Install XpdfReader and Tesseract (developed using XpdfReader 4.0.0 and Tesseract 4.00 in macOS 10.14.3)
2. Copy shell script to home directory
3. PDF file(s) should be in 'pdfs' directory in project directory (e.g.: project/pdfs, with pdftotxt.sh in project)
4. Run shell script (e.g. open Terminal, *cd* to project directory, and enter command *sh pdftotxt.sh*)

## Script workflow

For the PDF file(s) in the /pdfs directory, XpdfReader converts each page to a PNG image using the PDF filenames as root filenames. Tesseract then converts each PNG image to text, resulting in one .txt file per PDF. An output directory is created in the /pdfs directory and all .txt files are moved there, and all PNG files are deleted.
