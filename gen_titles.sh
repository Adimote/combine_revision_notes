#!/bin/bash
# Get the directory of this script so it can be run from anywhere
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

shopt -s nullglob # In case there are no pptx or ppt files

echo "Converting all pptx to pdf (this may take some time)"
for f in *.{pptx,ppt}; do
    BASE_FILENAME=${f%%.*} # Just get the name of the file, no extension
    if [ ! -f "$BASE_FILENAME.pdf" ]; then
        echo " + Converting '$f'..."
        unoconv -f pdf "$f"
    fi
done

shopt -u nullglob # Undo that option
echo "Adding title pages to all pdfs"
for f in *.pdf
do
        echo "\\begin{{document}}\\title{{`sed 's/_/\\\\_/g' <<< \"$f\"`}}\\end{{document}}" | pandoc --from latex -o "${f}__titlepage.pdf";
        stapler sel "${f}__titlepage.pdf" "$f" "${f}__withtitlepage.pdf";
done

echo "Combining all pdfs to one mega pdf"
stapler sel *__withtitlepage.pdf out.pdf

echo "Cleaning up"
rm *__titlepage.pdf
rm *__withtitlepage.pdf

echo "Created pdf out.pdf"
