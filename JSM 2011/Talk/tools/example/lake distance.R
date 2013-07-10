library(rgeos)

set.seed(1)
txt = rep("",5)
for(i in 1:5) {
	xc = floor(runif(1,1,25))
	yc = floor(runif(1,1,25))
	
	xpts = round(rnorm(10,0,0.5),3)
	ypts = round(rnorm(10,0,0.5),3)
	
	txt[i] = paste("MULTIPOINT(",paste( "(",xpts+xc," ",ypts+yc,")",sep="",collapse="," ),")",sep="")
}

wkt = paste( "GEOMETRYCOLLECTION(",paste(txt,collapse=","),")", sep="")
lake_pts = readWKT(wkt)
pdf("lake_plot1.pdf")
plot(lake_pts,pch=16)
dev.off()

hull=gConvexHull(lake_pts,byid=TRUE)
pdf("lake_plot2.pdf")
plot(lake_pts,pch=16)
plot(hull,add=TRUE)
dev.off()


lakes = gBuffer(hull,byid=TRUE,width=1,quadsegs=10)
pdf("lake_plot3.pdf")
plot(lakes,col=1:5+1)
plot(lake_pts,add=TRUE,pch=16)
plot(hull,add=TRUE)
dev.off()

pdf("lake_plot4.pdf")
plot(lakes,col=1:5+1)
dev.off()

pts = matrix( runif(100,1,25),ncol=2)
pts_wkt = paste( "GEOMETRYCOLLECTION(", paste(paste("POINT(",pts[,1]," ",pts[,2],")",sep=""),collapse=",") ,")", sep="")
pts_sp = readWKT(pts_wkt)
pdf("lake_plot5.pdf")
plot(lakes,col=1:5+1)
plot(pts_sp,add=TRUE,pch=1)
dev.off()


cols = apply(gDistance(pts_sp,lakes,byid=TRUE),2,which.min)
pdf("lake_plot6.pdf")
plot(lakes,col=1:5+1)
plot(pts_sp,pch=16,col=cols+1,add=TRUE)
plot(pts_sp,pch=1,add=TRUE)
dev.off()