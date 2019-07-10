all: UseR2019.html UseR2019.pdf

UseR2019.html: UseR2019.Rmd
	Rscript -e "rmarkdown::render('UseR2019.Rmd')"
	
UseR2019.pdf: UseR2019.html
	Rscript ../webshot.R UseR2019.html
	