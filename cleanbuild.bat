cd .\content\
latexmk -C
cd ..
del .\TUM_Thesis_Template.bbl
latexmk -C
latexmk -pdf .\TUM_Thesis_Template.tex
latexmk -pdf .\TUM_Thesis_Template.tex
