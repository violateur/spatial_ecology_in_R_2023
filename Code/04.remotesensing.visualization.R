# This is a script to visualize satellite data

library(devtools) # packages in R are also called libraries

# install the imageRy package from GitHub
devtools::install_github("ducciorocchini/imageRy")

library(imageRy)
library(terra)

# list the data
im.list()

b2 <- im.import("sentinel.dolomites.b2.tif")

# let's plot b2 with a specific colour palette
clb <- colorRampPalette(c("darkgrey","grey","lightgrey")) (100)
plot(b2, col=clb)

# exercise: let's do the same with the green band from Sentinel-2 (band 3)
b3 <- im.import("sentinel.dolomites.b3.tif")
clg <- colorRampPalette(c("darkgrey","grey","lightgrey")) (100)
plot(b3, col=clg)

# import the red band from Sentinel-2 (band 4)
b4 <- im.import("sentinel.dolomites.b4.tif") 
plot(b4, col=cl)

# import the NIR band from Sentinel-2 (band 8)
b8 <- im.import("sentinel.dolomites.b8.tif") 
plot(b8, col=cl)

# multiframe
par(mfrow=c(2,2))
plot(b2, col=cl)
plot(b3, col=cl)
plot(b4, col=cl)
plot(b8, col=cl)

# stack images
stacksent <- c(b2, b3, b4, b8)
dev.off() # it closes devices
plot(stacksent, col=cl)

plot(stacksent[[4]], col=cl)

# Exercise: plot in a multiframe the bands with different color ramps
par(mfrow=c(2,2))

clb <- colorRampPalette(c("dark blue", "blue", "light blue")) (100)
plot(b2, col=clb)

clg <- colorRampPalette(c("dark green", "green", "light green")) (100)
plot(b3, col=clg)

clr <- colorRampPalette(c("dark red", "red", "pink")) (100)
plot(b4, col=clr)

cln <- colorRampPalette(c("brown", "orange", "yellow")) (100)
plot(b8, col=cln)

# RGB space
# stacksent: 
# band2 blue element 1, stacksent[[1]] 
# band3 green element 2, stacksent[[2]]
# band4 red element 3, stacksent[[3]]
# band8 nir element 4, stacksent[[4]]
im.plotRGB(stacksent, r=3, g=2, b=1)

# now let's make a move of "one"
im.plotRGB(stacksent, r=4, g=3, b=2)
# this is useful as what reflects the infrared is exactly the vegetation (green)

# let's put the infrared on top of the green component
im.plotRGB(stacksent, r=3, g=4, b=2)
# white and violet represent rocks in this case

# let's move the infrared to the blue component
im.plotRGB(stacksent, r=3, g=2, b=4)
# in this case he vegetation will be blue


# what about the "pairs" function? --> it's useful to identify correlations between variables
?pairs
pairs(stacksent)
