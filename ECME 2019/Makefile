all: ECME2019.html ECME2019.pdf

ECME2019.html: ECME2019.Rmd
	Rscript -e "rmarkdown::render('ECME2019.Rmd')"
	
ECME2019.pdf: ECME2019.html
	Rscript -e "pagedown::chrome_print('ECME2019.html')"
