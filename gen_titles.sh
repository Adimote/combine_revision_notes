echo "Converting all pptx to pdf (this may take some time)"
unoconv -f pdf *.pptx
unoconv -f pdf *.ppt

echo "Adding title pages to all pdfs"
for f in *.pdf
do
        python title_gen.py "$f" | pandoc --from latex -o "${f}__titlepage.pdf";
        stapler sel "${f}__titlepage.pdf" "$f" "${f}__withtitlepage.pdf";
done

echo "Combining all pdfs to one mega pdf"
stapler sel *__withtitlepage.pdf out.pdf

echo "Cleaning up"
rm *__titlepage.pdf
rm *__withtitlepage.pdf

echo "Created pdf out.pdf"

