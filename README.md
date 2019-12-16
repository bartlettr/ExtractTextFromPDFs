# PDFtoTXT
Bash script for extracting machine-readable text from PDFs using XpdfReader and Tesseract

## Setup

1. Install XpdfReader and Tesseract (developed using XpdfReader 4.0.0 and Tesseract 4.00 in macOS 10.14.3)
2. Copy shell script (pdftotxt.sh) to project directory
3. PDF file(s) should be in 'pdfs' directory in project directory (e.g.: home/pdfs, with pdftotxt.sh in home).
4. Run shell script (e.g. open Terminal, *cd* to project directory, and enter command *sh pdftotxt.sh* or *sh pdftotxt.sh -eachpage*

<img src="/images/OriginalFolder.png" width="600">
![Project directory with pdftotxt.sh file and two PDF files in a /pdfs folder](/images/OriginalFolder.png)

## Script workflow

For the PDF file(s) in the /pdfs directory, special characters (including dashes) will be removed and spaces will be replaced by underscores, then the file is copied to a new /pdfs/renamedPDFs directory. Using the resulting PDF files in pdfs/renamedPDFs, XpdfReader converts each page to a PNG image using the PDF filenames as root filenames. Tesseract then converts each PNG image to text. Based on the root filenames, the text files are appended in sequence resulting in one .txt file per original PDF file (e.g.: first_pdf_document.txt, second_pdf_document.txt). An output directory with date and time stamps is created in the /pdfs/renamedPDFs directory; all .txt files are moved there and all PNG files are deleted.

![](/images/OneTxtPerDoc.png)

If the **-eachpage** option is used, the only difference is that there is no appending of text files and each page from the original PDF becomes an individual text file (1 PDF page = 1 text file, e.g.: first_pdf_document-000001.txt, first_pdf_document-000002.txt, etc.).

![](/images/OneTxtPerPage.png)
