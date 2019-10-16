all: EdinbR2019.html EdinbR2019.pdf

EdinbR2019.html: EdinbR2019.Rmd
	Rscript -e "rmarkdown::render('EdinbR2019.Rmd')"
	
EdinbR2019.pdf: EdinbR2019.html
	Rscript -e "pagedown::chrome_print('EdinbR2019.html')"
