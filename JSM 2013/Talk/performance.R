library(RcppGP)

n = 500 * (1:15)
l = length(n)
n_rep = 20


set.seed(1234)
s = matrix(runif(max(n)*2),ncol=2)


exp_cov = cov_model( list(type = "exponential", params = list(
                           list( name = "sigmaSq",
                                 dist = "ig",
                                 trans = "log",
                                 start = 1,
                                 tuning = 0.01,
                                 hyperparams = c(0.1, 0.1)
                               ),         
                           list( name = "phi",
                                 dist = "Unif",
                                 trans = "logit",
                                 start = 1,
                                 tuning = 0.01,
                                 hyperparams = c(0, 100)
                               )            
                     )) )
noop = cov_model( list(type = "noop", 
                       params = list( 
                                        list( name = "tauSq",
                                              dist = "IG",
                                              trans = "log",
                                              start = 1,
                                              tuning = 0.01,
                                              hyperparams = c(0.1, 0.1)
                                            )
                )) )


d = list()
cat("Building distance matrices.")

d[[l]] = as.matrix(dist(s))
for(i in (l-1):1)
{   
    d[[i]] = d[[l]][1:n[i],1:n[i]]
}

#######################

cov = matrix(NA,ncol=4,nrow=l)
cov[,1] = n


for(i in 1:l)
{
    cat(n[i],":\n",sep="")
    #.Call("check_gpu_mem", PACKAGE="RcppGP")

    cov[i,2] = benchmark_cov(exp_cov, d[[i]], c(0.5,2), n_rep)
    cov[i,3] = benchmark_cov_gpu(exp_cov, d[[i]], c(0.5,2), n_rep)
    cov[i,4] = cov[i,2] / cov[i,3]
}

pdf("figs/cov_bench.pdf",width=8, height=5)
par(mfrow=c(1,2), mar=c(5, 4, 2, 2) + 0.1)
plot(cov[,1], cov[,2], type='o', ylab="Time (secs)", xlab="n", col="blue",pch=16)
lines(cov[,1], cov[,3], type='o', col="orange",pch=16)
legend("topleft",c("CPU","GPU"),col=c("blue","orange"),lty=1,pch=16)


plot(cov[,1], cov[,4], type='o', ylab="Relative Performance", xlab="n", col="green", pch=16)
dev.off()


#######################

inv_cov = matrix(NA,ncol=4,nrow=l)
inv_cov[,1] = n


for(i in 1:l)
{
    cat(n[i],":\n",sep="")
    #.Call("check_gpu_mem", PACKAGE="RcppGP")

    inv_cov[i,2] = benchmark_inv_cov(exp_cov, d[[i]], c(0.5,2), n_rep)
    inv_cov[i,3] = benchmark_inv_cov_gpu(exp_cov, d[[i]], c(0.5,2), n_rep)
    inv_cov[i,4] = inv_cov[i,2] / inv_cov[i,3]
}


pdf("figs/inv_cov_bench.pdf",width=8, height=5)
par(mfrow=c(1,2), mar=c(5, 4, 2, 2) + 0.1)
plot( inv_cov[,1], inv_cov[,2], type='o', ylab="Time (secs)", xlab="n", col="blue",pch=16)
lines(inv_cov[,1], inv_cov[,3], type='o', col="orange",pch=16)
legend("topleft",c("CPU","GPU"),col=c("blue","orange"),lty=1,pch=16)


plot(inv_cov[,1], inv_cov[,4], type='o', ylab="Relative Performance", xlab="n", col="green", pch=16)
dev.off()


#######################

chol_cov = matrix(NA,ncol=4,nrow=l)
chol_cov[,1] = n


for(i in 1:l)
{
    cat(n[i],":\n",sep="")
    #.Call("check_gpu_mem", PACKAGE="RcppGP")

    chol_cov[i,2] = benchmark_chol_cov(exp_cov, d[[i]], c(0.5,2), n_rep)
    chol_cov[i,3] = benchmark_chol_cov_gpu(exp_cov, d[[i]], c(0.5,2), n_rep)
    chol_cov[i,4] = chol_cov[i,2] / chol_cov[i,3]
}




pdf("figs/chol_cov_bench.pdf",width=8, height=5)
par(mfrow=c(1,2), mar=c(5, 4, 2, 2) + 0.1)
plot( chol_cov[,1], chol_cov[,2], type='o', ylab="Time (secs)", xlab="n", col="blue",pch=16)
lines(chol_cov[,1], chol_cov[,3], type='o', col="orange",pch=16)
legend("topleft",c("CPU","GPU"),col=c("blue","orange"),lty=1,pch=16)


plot(chol_cov[,1], chol_cov[,4], type='o', ylab="Relative Performance", xlab="n", col="green", pch=16)
dev.off()


#calc_cov(m, d2, c(0.5,1))
#calc_cov_gpu(m, d2, c(0.5,1))
#
#sum( calc_inv_cov(m, d2, c(0.5,1)) - calc_inv_cov_gpu(m, d2, c(0.5,1)) )
#
#sum( calc_inv_cov(m, d1, c(0.5,1)) - calc_inv_cov_gpu(m, d1, c(0.5,1)) )



#
#
#x=rep(0,5)
#for (i in 1:100)
#    x = x + system.time(calc_inv_cov_gpu(m, d2, c(0.5,1)))
#
#x
#

