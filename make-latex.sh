#!/bin/sh
#assemble and preprocess all the sources files

echo "Generating latex for pre.txt."
pandoc text/pre.txt --lua-filter=lua/epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/pre.tex
echo "Generating latex for intro.txt."
pandoc text/intro.txt --lua-filter=lua/epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/intro.tex
echo "Generating latex for epi.txt."
pandoc text/epi.txt --lua-filter=lua/epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/epi.tex

echo "Generating all latex files at latex directory."
for filename in text/ch*.txt; do
   echo "Generating $(basename "$filename" .txt).tex for $filename."
   [ -e "$filename" ] || continue
   pandoc --lua-filter=lua/extras.lua "$filename" --to markdown | pandoc --lua-filter=lua/extras.lua --to markdown | pandoc --lua-filter=lua/epigraph.lua --to markdown | pandoc --lua-filter=lua/figure.lua --to markdown | pandoc --lua-filter=lua/comment.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --wrap=none --to latex > latex/"$(basename "$filename" .txt).tex"
done

for filename in text/apx*.txt; do
   echo "Generationg $(basename "$filename" .txt).tex for $filename."
   [ -e "$filename" ] || continue
   pandoc --lua-filter=lua/extras.lua "$filename" --to markdown | pandoc --lua-filter=lua/extras.lua --to markdown | pandoc --lua-filter=lua/epigraph.lua --to markdown | pandoc --lua-filter=lua/figure.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --to latex > latex/"$(basename "$filename" .txt).tex"
done

echo "Generating book.tex using all other tex files."
pandoc -s latex/*.tex -o book/book.tex

echo "Generating PDF file for the Book!"
echo "Please Wait."
pandoc -N --quiet --variable "geometry=margin=1.2in" --variable mainfont="OpenSans-Regular.ttf" --variable sansfont="OpenSans-Regular.ttf" --variable monofont="OpenSans-Regular.ttf" --variable fontsize=12pt --variable version=2.0 book/book.tex --pdf-engine=xelatex --toc -o book/book.pdf

echo "Your PDF is ready you will find it in book directory."

#sed -i '' 's+Figure+Εικόνα+g' ./latex/ch0*
