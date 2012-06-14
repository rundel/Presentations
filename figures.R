library(rgeos)

###############################################
#
# Boolean Operations
#
###############################################

x = readWKT("POLYGON ((0 0, 0 10, 10 10, 10 0, 0 0),(2 2,2 8,8 8,8 2,2 2))")
y = readWKT("POLYGON ((5 5, 15 5, 15 15, 5 15, 5 5))")

pdf("Figures/booleans1.pdf",width=14,height=3.5)
par(mfrow=c(1,4), mar=c(2.5,1,1,1), mgp=c(1,0,0), cex.lab=2, font.lab = 2)

plot(x, xlim=c(0,15),ylim=c(0,15), col=rgb(0,0,1,0.5), pbg="white"); title(xlab="X"); box(col="grey")
plot(y, xlim=c(0,15),ylim=c(0,15), col=rgb(1,0,0,0.5), pbg="white"); title(xlab="Y"); box(col="grey")

plot(0,type='n',axes=FALSE,xlab="",ylab="")

plot_xy = function(xlab) {
    plot(x, xlim=c(0,15),ylim=c(0,15), col=rgb(0,0,1,0.5),pbg="white")
    plot(y, add=TRUE,                  col=rgb(1,0,0,0.5))
    title(xlab=xlab)
    box(col="grey")
}
plot_xy("X and Y")
dev.off()

pdf("Figures/booleans2.pdf",width=14,height=3.5)
par(mfrow=c(1,4), mar=c(2.5,1,1,1), mgp=c(1,0,0), cex.lab=2, font.lab = 2)

plot_xy("gIntersection");  plot(gIntersection(x,y), add=TRUE, col="yellow", pbg="white"); box(col="grey")
plot_xy("gUnion");         plot(gUnion(x,y),        add=TRUE, col="yellow", pbg="white"); box(col="grey")
plot_xy("gDifference");    plot(gDifference(x,y),   add=TRUE, col="yellow", pbg="white"); box(col="grey")
plot_xy("gSymdifference"); plot(gSymdifference(x,y),add=TRUE, col="yellow", pbg="white"); box(col="grey")
dev.off()

###############################################
#
# Dimensionally Extended 9-Intersection Matrix
#
###############################################

x = readWKT("POLYGON((1 0,0 1,1 2,2 1,1 0))")
x.inter = x
x.bound = gBoundary(x)

y = readWKT("POLYGON((2 0,1 1,2 2,3 1,2 0))")
y.inter = y
y.bound = gBoundary(y)


xy.inter = gIntersection(x,y)
xy.inter.bound = gBoundary(xy.inter)

xy.union = gUnion(x,y)
bbox = gBuffer(gEnvelope(xy.union),width=0.5,joinStyle='mitre',mitreLimit=3)

x.exter = gDifference(bbox,x)
y.exter = gDifference(bbox,y)

defaultplot = function() {
    plot(bbox,border='grey')
    plot(x,add=TRUE,col=rgb(0,0,1,0.5),border=rgb(0,0,1,0))
    plot(y,add=TRUE,col=rgb(1,0,0,0.5),border=rgb(1,0,0,0))        
}


pat = gRelate(x,y)
patchars = strsplit(pat,"")[[1]]

pdf("Figures/de9im.pdf",height=5)
par(mfrow=c(3,3), font.main=2, font.lab=2, cex.main=1.5, cex.lab=1.5, mar = c(1,1.5,1.5,0), mgp=c(0,0,0))
defaultplot(); plot(gIntersection(x.inter,y.inter),add=TRUE,col='black');       title("Interior",xlab=paste("dim:",patchars[1]), ylab="Interior")
defaultplot(); plot(gIntersection(x.bound,y.inter),add=TRUE,col='black',lwd=2); title("Boundary",xlab=paste("dim:",patchars[2]))
defaultplot(); plot(gIntersection(x.exter,y.inter),add=TRUE,col='black');       title("Exterior",xlab=paste("dim:",patchars[3]))

defaultplot(); plot(gIntersection(x.inter,y.bound),add=TRUE,col='black',lwd=2); title(xlab=paste("dim:",patchars[4]), ylab="Boundary")
defaultplot(); plot(gIntersection(x.bound,y.bound),add=TRUE,col='black',pch=16);title(xlab=paste("dim:",patchars[5]))
defaultplot(); plot(gIntersection(x.exter,y.bound),add=TRUE,col='black',lwd=2); title(xlab=paste("dim:",patchars[6]))

defaultplot(); plot(gIntersection(x.inter,y.exter),add=TRUE,col='black');       title(xlab=paste("dim:",patchars[7]), ylab="Exterior")
defaultplot(); plot(gIntersection(x.bound,y.exter),add=TRUE,col='black',lwd=2); title(xlab=paste("dim:",patchars[8]))
defaultplot(); plot(gIntersection(x.exter,y.exter),add=TRUE,col='black',pbg="white"); title(xlab=paste("dim:",patchars[9]))
plot(x,add=TRUE,col=rgb(0,0,1,0.5),border=rgb(0,0,1,0))
plot(y,add=TRUE,col=rgb(1,0,0,0.5),border=rgb(1,0,0,0))
dev.off()


###############################################
#
# Prepared Geometries
#
###############################################

library(maptools)

data(wrld_simpl)
US = wrld_simpl[wrld_simpl@data$NAME == "United States",]

gt = GridTopology(c(-180,-90),c(0.5,0.5),c(720,360))
grid = SpatialGrid(gt)
sp = as(grid, "SpatialPoints")
proj4string(sp) = proj4string(US)

system.time(gIntersects(US,sp,byid=TRUE,prepared=TRUE))
system.time(gIntersects(US,sp,byid=TRUE,prepared=FALSE))
