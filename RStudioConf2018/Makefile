all: rstudio_conf_2017.html rstudio_conf_2017.pdf

rstudio_conf_2017.pdf: rstudio_conf_2017.html
	# npm install decktape
	decktape remark rstudio_conf_2017.html rstudio_conf_2017.pdf

rstudio_conf_2017.html: rstudio_conf_2017.Rmd
	Rscript -e 'rmarkdown::render("rstudio_conf_2017.Rmd")'