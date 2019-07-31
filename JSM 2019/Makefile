all: JSM2019.html JSM2019.pdf

JSM2019.html: JSM2019.Rmd
	Rscript -e "rmarkdown::render('JSM2019.Rmd')"
	
JSM2019.pdf: JSM2019.html
	`npm  bin`/decktape remark JSM2019.html JSM2019.pdf --chrome-arg=--disable-web-security
	