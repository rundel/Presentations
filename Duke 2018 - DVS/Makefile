all: Duke2018-DVS.html Duke2018-DVS.pdf

Duke2018-DVS.html: Duke2018-DVS.Rmd
	Rscript -e "rmarkdown::render('Duke2018-DVS.Rmd')"

Duke2018-DVS.pdf: Duke2018-DVS.html
	decktape remark Duke2018-DVS.html Duke2018-DVS.pdf --chrome-arg=--allow-file-access-from-files
