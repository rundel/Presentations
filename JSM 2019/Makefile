all: JSM2019.html JSM2019.pdf

JSM2019.html: JSM2019.Rmd
	Rscript -e "rmarkdown::render('JSM2019.Rmd')"
	
JSM2019.pdf: JSM2019.html
	Rscript ../webshot.R JSM2019.html
	