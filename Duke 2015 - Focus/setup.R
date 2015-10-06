suppressMessages(library(fields))

cov_func = function(d, sigma2, phi) 
{
    sigma2 * exp( -(d * phi)^2 )
}

init_n = 20
sigma2 = 1
phi = 1

set.seed(10052015)

init_x = sort(runif(init_n,-3,3))
init_d = as.matrix(dist(init_x))
init_cov = cov_func(init_d, sigma2, phi) + diag(0.001, nrow(init_d))

init_y = chol(init_cov) %*% rnorm(init_n)


n = 500
x = sort(runif(n,-3,3))
d = rdist(x)
d_btw = rdist(x,init_x)

cov = cov_func(d, sigma2, phi) + diag(0.1, nrow(d))
cov_btw = cov_func(d_btw, sigma2, phi)

cond_mu = cov_btw %*% solve(init_cov, init_y)
cond_S  = cov - cov_btw %*% solve(init_cov, t(cov_btw))

y = cond_mu + chol(cond_S) %*% rnorm(n)



### Fit GP model

library(tgp)

gp = bgp(X=x, Z=y, XX=seq(-3.5,3.5,len=1000), corr="exp")


### Spatial Data

load("data/frm.Rdata")
library(raster)
library(dplyr)
library(maptools)

data(wrld_simpl)

r = raster(nrows=75, ncols=75, xmn=-125, xmx=-67, ymn=24, ymx=50)
res$cells = cellFromXY(r,res[,1:2])
res2 = res %>% group_by(cells) %>% summarize(pm25 = mean(pm25))

r[res2$cells] = res2$pm25

locs = data.frame(xyFromCell(r,1:length(r[])))
colnames(locs) = c("longitude","latitude")

sub = !is.na(rasterize(wrld_simpl[209,],r)[])

locs = locs[sub, ]


sp_gp = bgp(X=res[,1:2], Z=res$pm25, XX=locs, corr="exp")

### Save

save(x,y,gp,
     r,res,locs,sub,sp_gp,
     file="data.Rdata")