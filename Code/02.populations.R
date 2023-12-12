install.pcakages("spatstat")
library(spatstat)
library(terra)

# let's use the bei data:
# data description:
# https://CRAN.R-project.org/package=spatstat
bei 
plot(bei) 
plot(bei, pch=19, cex=.5) 

#select the elements
bei.extra
plot(bei.extra)
plot(bei.extra[[1]])

#second way to select the elements
plot(bei.extra[[1]])
plot(bei, pch=19, cex=.5, add=T) 

density_map <- density(bei)

#multiframe
par(mfrow=c(2,1))
plot(bei.extra[[1]])
plot(density_map)

cl <- colorRampPalette(c("black", "red", "orange", "yellow"))(100)
plot(bei.extra[[1]], col=cl)
plot(density_map, col=cl)

#-----
bei.rast <- rast(bei.extra[[1]])
density.rast <- rast(density_map)

randompoints <- spatSample(bei.rast, 100, "random", as.points = TRUE)
bei.points <- terra::extract(bei.rast, randompoints)
density.points <- terra::extract(density.rast, randompoints)
 
pointmaps <- data.frame(bei.points[1:2], density.points[2])

names(pointmaps)

attach(pointmaps)
plot(lyr.1, lyr.1.1)
