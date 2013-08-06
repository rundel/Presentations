library(stringr)
library(lubridate)
library(proj4)
library(timezone)
library(sunshine)
library(RcppGP)

sites = list(eno_west = 2009:2012,
             eno_east = 2009:2011,
             hardwood = 2009:2012,
             warming  = 2009:2013)

setwd("~/Dropbox/Desktop/Presentations/JSM 2013/Talk/")

data_dir = "~/Dropbox/Desktop/Sensor Networks/Data"


locs = read.csv(file.path(data_dir,"locations.csv"),as.is=TRUE)
tmp = project(as.matrix(locs[,c("Xutm","Yutm")]),"+proj=utm +north +zone=17",inv=TRUE,ellps.default=NA)
colnames(tmp) = c("long","lat")
locs = cbind(locs, tmp)
rm(tmp)


site = "warming" #"eno_east"

files = dir("Data/",paste0(site,"*"))


nodes = str_split( 
            str_replace(
                str_replace(files,"\\.Rdata",""),
                paste0(site,"_"),
                ""
            ), "\\."
        )


j=which(files == "warming_S08Q.1.Rdata")

file = files[j]
node = nodes[[j]][1]
probe = nodes[[j]][2]

x = mean( locs[locs$site==site & locs$node==node,"long"], na.rm=TRUE )
y = mean( locs[locs$site==site & locs$node==node,"lat"], na.rm=TRUE )

tz = find_tz(x,y)       

cat(file,"... \n")

load(file.path("Data",file))

comb = comb[ year(comb$timestamp) %in% sites[[site]], ]

date = unique(comb$date)


d = data.frame(date,noon=solar( ymd(date), x, y, tz=tz )$noon)

comb = merge(comb,d)

comb$diff = abs(comb$timestamp-comb$noon)
units(comb$diff) = "hours"

comb = comb[comb$diff <= 2,]

x = 1   
comb$k = sqrt(x^2+tan(comb$zenith)^2) / (x+1.7744*(x+1.182)^(-0.733))

comb$LAI = comb$R / comb$k



beta = list( prior = "normal",
             hyperparam = list(mu  = rep(0,1),
                               sig = rep(1000000,1) )
           )


nugget_cov = list(type = "nugget", params = list(
                        list( name = "tauSq",
                              dist = "ig",
                              trans = "log",
                              start = 2,
                              tuning = 0.1,
                              hyperparams = c(2, 2)
                            )           
                 ))

perexp_cov = list(type = "periodic_exponential", params = list(
                        list( name = "sigmaSq",
                              dist = "ig",
                              trans = "log",
                              start = 1,
                              tuning = 0.1,
                              hyperparams = c(2, 2)
                            ),         
                        list( name = "phi",
                              dist = "unif",
                              trans = "logit",
                              start = 1,
                              tuning = 0.1,
                              hyperparams = c(0, 2)
                            ),
                        list( name = "gamma",
                              dist = "fixed",
                              start = 365.25
                            ),
                        list( name = "decay",
                              dist = "unif",
                              trans = "logit",
                              start = 0.003,
                              tuning = 0.002,
                              hyperparams = c(0, 0.1)
                            )            
                 ))

cm = cov_model(nugget_cov, perexp_cov)


LAI = tapply(comb$LAI,comb$date,mean,na.rm=TRUE)
LAI = LAI[is.finite(LAI)]
LAI = LAI[LAI >= 0]

date=ymd(names(LAI))
day = date - min(date)
units(day) = "days"

day = matrix(as.numeric(day),ncol=1)

m = spLM_RcppGP( LAI ~ 1, 
                 coords=day,
                 beta = beta,
                 cov_model = cm,
                 #modified_pp = TRUE,
                 #knots=knots,
                 n_samples=5000,
                 verbose=TRUE, 
                 n_report=1000, 
                 n_adapt=3000,
                 gpu=FALSE
               )

m_gpu = spLM_RcppGP( LAI ~ 1, 
                     coords=day,
                     beta = beta,
                     cov_model = cm,
                     #modified_pp = TRUE,
                     #knots=knots,
                     n_samples=5000,
                     verbose=TRUE, 
                     n_report=1000, 
                     n_adapt=3000,
                     gpu=TRUE
                   )

pdf("cpu.pdf")
plot(window(m$params,start=3001,thin=4))
dev.off()

pdf("gpu.pdf")
plot(window(m_gpu$params,start=3001,thin=4))
dev.off()


#save.image(file=file.path("tmp",file))
#
#load(file=file.path("tmp",file))


pred_day = as.matrix(min(day):max(day),ncol=1) + 1/24
pred_X = as.matrix( rep(1, length(pred_day)), ncol=1 )

m_pred = spPredict_RcppGP(m, pred_day, pred_X, start=3001, thin=2, verbose=TRUE, n_report=100, gpu=FALSE)
m_gpu_pred = spPredict_RcppGP(m_gpu, pred_day, pred_X, start=3001, thin=2, verbose=TRUE, n_report=100, gpu=TRUE)

pdf("figs/LAI.pdf",width=8,height=4)
par(mar=c(3, 4, 2, 2) + 0.1)
plot(date,LAI,pch=16,cex=0.5)
dev.off()

date_pred = c(min(date)+hours(24*pred_day))


#for(i in 1:ncol(m_gpu_pred$y_pred))
#{
#  lines(d$date, m_gpu_pred$y_pred[,i],col=adjustcolor("blue",0.1))
#}


pdf("figs/LAI_pred.pdf",width=8,height=4)
par(mar=c(3, 4, 2, 2) + 0.1)

plot(date,LAI,pch=16,cex=0.5)
lines(date_pred,apply(m_pred$y_pred,1,mean),col='blue',lwd=2)
lines(date_pred,apply(m_gpu_pred$y_pred,1,mean),col='orange',lwd=2)

dev.off()


pdf("figs/LAI_pred_gpu.pdf",width=8,height=4)
par(mar=c(3, 4, 2, 2) + 0.1)

plot(date,LAI,pch=16,cex=0.5,main="GPU")
lines(date_pred,apply(m_gpu_pred$y_pred,1,median),col='orange',lwd=2)
lines(date_pred,apply(m_gpu_pred$y_pred,1,quantile,probs=0.025),col='orange',lwd=1,lty=2)
lines(date_pred,apply(m_gpu_pred$y_pred,1,quantile,probs=0.975),col='orange',lwd=1,lty=2)
dev.off()



pdf("figs/LAI_pred_cpu.pdf",width=8,height=4)
par(mar=c(3, 4, 2, 2) + 0.1)

plot(date,LAI,pch=16,cex=0.5,main="CPU")
lines(date_pred,apply(m_pred$y_pred,1,median),col='blue',lwd=2)
lines(date_pred,apply(m_pred$y_pred,1,quantile,probs=0.025),col='blue',lwd=1,lty=2)
lines(date_pred,apply(m_pred$y_pred,1,quantile,probs=0.975),col='blue',lwd=1,lty=2)
dev.off()

#save.image(file=file.path("tmp",file))

stop()



