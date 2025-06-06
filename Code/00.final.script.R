#final script including all the different scripts during lectures.

#-----------

#Summary:
#01 Beginning
#02.1 Population Density
#02.2 Population Distributions
#03.1 Community Multivariate Analysis
#03.2 Community Overlap
#04 Remote sensing visualisation
#05 Spectral Indices
#06 Time Series
#07 External Data
#08 Copernicus Data
#09 Classification
#10 Variability
#11 Principal Component Anlysis

#-----------


#01 Beginning
# R as a calculator
2 + 3

# Assign to an object
zima <- 2 + 3
zima

duccio <- 5 + 3
duccio

final <- zima * duccio
final

final^2

# array
sophi <- c(10, 20, 30, 50, 70) # microplastics 
# fcuntions have parentheses and inside them there are arguments

paula <- c(100, 500, 600, 1000, 2000) # people

plot(paula, sophi)

plot(paula, sophi, xlab="number of people", ylab="microplastics")


people <- paula
microplastics <- sophi

plot(people, microplastics)
plot(people, microplastics, pch=19)
# https://www.google.com/search?client=ubuntu-sn&hs=yV6&sca_esv=570352775&channel=fs&sxsrf=AM9HkKknoSOcu32qjoErsqX4O1ILBOJX4w:1696347741672&q=point+symbols+in+R&tbm=isch&source=lnms&sa=X&ved=2ahUKEwia9brkm9qBAxVrQvEDHbEYDuMQ0pQJegQIChAB&biw=1760&bih=887&dpr=1.09#imgrc=lUw3nrgRKV8ynM

plot(people, microplastics, pch=19, cex=2)
plot(people, microplastics, pch=19, cex=2, col="blue")

#------------

#02.1 Population Density

install.pcakages("spatstat") 
library(spatstat)
library(terra)

# let's use the bei data:
# data description:
# https://CRAN.R-project.org/package=spatstat
#we used point data
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

#the function density is for point data
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

#--------------

#02.2 Population Distributions

# Why do populations disperse over the landscape in a certain manner?

library(sdm) #species distribution modelling
library(terra)

file <- system.file("external/species.shp", package="sdm")

rana <- vect(file)

rana$Occurrence
# and you obtain presence/absence data
# the "0" is anyaway uncertain, as you could have just missed it, but maybe it was there. maybe you didnt just find the specie. 

# to look at the data
plot(rana)
plot(rana, cex=.5)
# the points that you see a could be both absence or presence data

# Selecting presences
rana [rana$Occurrence==1,]
# because we just selected all the points equal to 1 (presences)
pres <- rana [rana$Occurrence==1,]
pres
pres$Occurrence
plot(pres, cex=.5)

# exercise: select absences and call the abse
abse <- rana [rana$Occurrence==0,]
abse
abse$Occurrence
plot(abse, cex=.5)

# you could also use "!=" to pick the things "different from", so the opposite of "=="

# exercise: plot presences and absences, one next to each other
par(mfrow=c(1,2))
plot(pres, cex=.5)
plot(abse, cex=.5)

# exercise: plot presences and absences altogether, but with different colours
# first of all, close the multiframe. to do it, use the function dev.off(). this is especially useful in the case of graphical problems
dev.off()
# and then, plot one and add the points of the other
plot(pres, col="darkblue", cex=.7)
points(abse, col="lightblue4", cex=.7)

# Predictors: environmental variables

# elevation predictor
# with the system.file function we are going into the external folder
elev <- system.file("external/elevation.asc", package="sdm")
elev
elevmap <- rast(elev)
elevmap
# rasters are images, not vectors
plot(elevmap)
points(pres, cex=.5)
# this way we can look for correlations between this predictor (elevation) and the presence of individuals
# in this case, individuals, Rana temporaria prefers medium elevations

# temperature predictor
temp <- system.file("external/temperature.asc", package="sdm")
temp
tempmap <- rast(temp)
tempmap
plot(tempmap)
points(pres, cex=.5)
# we can say that Rana temporaria tries to avoid low temperatures

# exercise: do the same with vegetation cover
vege <- system.file("external/vegetation.asc", package="sdm")
vege
vegemap <- rast(vege)
vegemap
plot(vegemap)
points(pres, cex=.5)
# Rana temporaria loves areas characterized by a high vegetation cover (greater chances of survival)

# with precipitation
prec <- system.file("external/precipitation.asc", package="sdm")
prec
precmap <- rast(prec)
precmap
plot(precmap)
points(pres, cex=.5)
# Rana temporaria prefers a high precipitation level

# Final multiframe
par(mfrow= c(2,2))
plot(elevmap)
points(pres, cex=.5)
plot(tempmap)
points(pres, cex=.5)
plot(vegemap)
points(pres, cex=.5)
plot(precmap)
points(pres, cex=.5)

#------------

#03.1 Community Multivariate Analysis

#the first study we did is a multivariate analisys on communities

library(vegan) #vegan = vegetation analysis, but can also be applied to animals

data(dune)
head(dune)

# in order to see just the first 6 rows of the data
head(dune)

# in order to see just the last 6 rows of the data
tail(dune)

# decorana means "detrended correspondence analysis"; it's a type of analysis
ord <- decorana(dune)
ord

# in order to build a propoer graph, given by the lenghts of the four axes
ldc1 <- 3.7004
ldc2 <- 3.1166
ldc3 <- 1.30055
ldc4 <- 1.47888
# you could also use "=" instead of "<-"

# for the total length
total = ldc1 + ldc2 + ldc3 + ldc4

# and to calculate the percentage of each axis
pldc1 = ldc1 * 100 / total
pldc2 = ldc2 * 100 / total
pldc3 = ldc3 * 100 / total
pldc4 = ldc4 * 100 / total

# for the percentage of two axes
pldc1 + pldc2

# to create a plot based exactly on those two axes
plot(ord)

# Call:
# decorana(veg = dune) 

# Detrended correspondence analysis with 26 segments.
# Rescaling of axes with 4 iterations.

#                   DCA1   DCA2
# Eigenvalues     0.5117 0.3036
# Decorana values 0.5360 0.2869
# Axis lengths    3.7004 3.1166
#                    DCA3    DCA4
# Eigenvalues     0.12125 0.14267
# Decorana values 0.08136 0.04814
# Axis lengths    1.30055 1.47888

plot(ord)

#------------

#03.2 Community Overlap
# Relation among species in time

library(overlap)

data(kerinci)
head(kerinci)
tail(kerinci)

# to obtain some general information about the dataset
summary(kerinci)

# to analyse the movement of just one species during the day
tiger <- kerinci[kerinci$Sps=="tiger",]

# to add the column of "circular time" to the dataset
kerinci$TimeRad <- kerinci$Time * 2 * pi

# let's relaunch the "tiger", now with the parameter "TimeRad"
tiger <- kerinci[kerinci$Sps=="tiger",]

# let's name the variable "TimeRad" for "tiger"
TimeRadTiger <- tiger$TimeRad

# to plot the peaks in time of a certain species
densityPlot(TimeRadTiger, rug=TRUE)
# the rug is useful to obtain a smoother curve

# exercise: do the same with macaque
macaque <- kerinci[kerinci$Sps=="macaque",]
TimeRadMacaque <- macaque$TimeRad
densityPlot(TimeRadMacaque, rug=TRUE)

# to overlap the plot and, thus, identify juicy information
overlapPlot(TimeRadTiger, TimeRadMacaque)

#------------

#04 Remote sensing visualisation

# This is a script to visualize satellite data

install.packages("devtools")
install.packages("terra")

library(devtools)
library(terra)
# install the imageRy package from GitHub
devtools::install_github("ducciorocchini/imageRy")

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

#------------

#05 Spectral Indices

## Vegetation indices

library(imageRy)
library(terra)

im.list()

m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")
# this image has been processed
# bands: 1=NIR, 2=RED, 3=GREEN

im.plotRGB(m1992, r=1, g=2, b=3)
# this way, all the vegetation "will become" red
# you can write the same input even this way:
im.plotRGB(m1992, 1, 2, 3)
# therefore inverting the colours is easier:
im.plotRGB(m1992, 2, 1, 3)
im.plotRGB(m1992, 2, 3, 1)
# what seems bare soil, in this case, it's water (which usually should be black)

# let's look at the 2006 images
m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
im.plotRGB(m2006, r=1, g=2, b=3)
im.plotRGB(m2006, 1, 2, 3)
im.plotRGB(m2006, 2, 1, 3)
im.plotRGB(m2006, 2, 3, 1)

# import the recent image
m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
im.plotRGB(m2006, r=2, g=3, b=1)

# build a multiframe with 1992 and 2006 images
par(mfrow=c(1,2))
im.plotRGB(m1992, r=2, g=3, b=1)
im.plotRGB(m2006, r=2, g=3, b=1)

# DVI = NIR - RED 
# bands: 1=NIR, 2=RED, 3=GREEN

dvi1992 = m1992[[1]] - m1992[[2]]
plot(dvi1992)

cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)
plot(dvi1992, col=cl)

# exercise: calculate dvi of 2006
dvi2006 = m2006[[1]] - m2006[[2]]
plot(dvi2006, col=cl)

# NDVI
ndvi1992 = (m1992[[1]] - m1992[[2]]) / (m1992[[1]] + m1992[[2]])
ndvi1992 = dvi1992 / (m1992[[1]] + m1992[[2]])
plot(ndvi1992, col=cl)

# NDVI
ndvi2006 = dvi2006 / (m2006[[1]] + m2006[[2]])
plot(ndvi2006, col=cl)

# par
par(mfrow=c(1,2))
plot(ndvi1992, col=cl)
plot(ndvi2006, col=cl)

clvir <- colorRampPalette(c("violet", "dark blue", "blue", "green", "yellow"))(100) # specifying a color scheme
par(mfrow=c(1,2))
plot(ndvi1992, col=clvir)
plot(ndvi2006, col=clvir)

# speediing up calculation
ndvi2006a <- im.ndvi(m2006, 1, 2)
plot(ndvi2006a, col=cl)
# pay attention that putting the NIF in the blue increases the attention of the viewer (so it's good)

#---------

#06 Time Series

library(terra)
library(imageRy)

im.list()
#import the dara 
EN01<-im.import("EN_01.png")
EN13<-im.import("EN_13.png")

par(mfrow=c(2,1))
im.plotRGB.auto(EN01)
im.plotRGB.auto(EN13)

#using the first element (band) of images
dif=EN01[[1]]-EN13[[1]]

#palette
cldif<-colorRampPalette(c("blue","white","red"))(100)
plot(dif,col=cldif)
dev.off()

plot(dif)


g2000<-im.import("greenland.2000.tif")
clg<-colorRampPalette(c("black","blue","white","red"))(100)
plot(g2000,col=clg)

g2005<-im.import("greenland.2005.tif")
g2010<-im.import("greenland.2010.tif")
g2015<-im.import("greenland.2015.tif")

plot(g2015,col=clg)

par(mfrow=c(2,2))
plot(g2000,col=clg)
plot(g2015,col=clg)
plot(g2010,col=clg)
plot(g2005,col=clg)

stackg<-c(g2000,g2005,g2015,g2010)

#exercise: make the differences between the first and final elements of the stack
gdif<-g2000[[1]]-g2015[[1]]
clgdif<-colorRampPalette(c( "blue","white","red"))(100)
plot(gdif,col=clgdif)
#now you see the most vulnerable parts of land to temperatures
#for next time import the data from earth observatory

#---------------

#07 External Data

library(terra)
# set the working directory based on your path:
# setwd("youtpath")
# W***** users: C:\\path\Downloads -> C://path/Downloads
# my absolute wd
setwd("/Users/Cat/Desktop/SPATIAL ECOLOGY R")
naja23<-rast("najaf2021.jpeg")
naja03<-rast("najaraf2003.jpeg")
naja23
naja03
par(mfrow=c(2,1))
plotRGB(naja03, r=1, g=2,b=3)
plotRGB(naja23, r=1, g=2, b=3)


najafdif<- naja03[[1]]-naja23[[1]]
cl<-colorRampPalette(c("brown", "grey","orange"))(100)
plot(najafdif, col=cl)

#download your own preferred image

laguna<-rast("laguna.jpeg")
laguna

# The Mato Grosso image can be downloaded directly from EO-NASA:
mato <- rast("matogrosso_l5_1992219_lrg.jpg")
plotRGB(mato, r=1, g=2, b=3) 
plotRGB(mato, r=2, g=1, b=3) 


#exercise: make a RGB plot using different years
im.plotRGB(stackg, r=1, g=2, b=3) #western part: higher temperatures like usa, in the middle the temperature is higher in the long period.

#--------------

#08 Copernicus Data

# https://land.copernicus.vgt.vito.be/PDF/portal/Application.html#Browse;Root=71027541;Collection=1000282;DoSearch=true;Time=NORMAL,NORMAL,1,JANUARY,2022,28,NOVEMBER,2023;isReserved=false
#use copernicus data

library(ncdf4)
library(terra)

setwd("C:/Users/Diego C/Downloads")

soilmoisture <- rast("c_gls_SSM1km_202311250000_CEURO_S1CSAR_V1.2.1.nc")
soilmoisture
plot(soilmoisture)
# there are 2 elements, let's use the first one
plot(soilmoisture[[1]])
# let's change the colours
cl <- colorRampPalette(c("red", "orange", "yellow")) (100)
plot(soilmoisture[[1]], col=cl)

# how to crop the stack to a specific extent: define a variable and then crop an image to a certain extent
ext <- c(20, 23, 55, 57)   # minimum longitude, maximum longitude, minimum latitude, maximum latitude
soilmoisturecrop <- crop(soilmoisture, ext)
soilmoisturecrop
plot(soilmoisturecrop)
plot(soilmoisturecrop[[1]], col=cl)

# cropping images is very useful for burnt areas, as they are very small on the planet

# let's do the same with an image created exactly 1 year before
setwd("C:/Users/Diego C/Downloads")
soilmoisture22 <- rast("c_gls_SSM1km_202211250000_CEURO_S1CSAR_V1.2.1.nc")
soilmoisture22
plot(soilmoisture22)
plot(soilmoisture22[[1]])
cl <- colorRampPalette(c("red", "orange", "yellow")) (100)
plot(soilmoisture[[1]], col=cl)

ext <- c(20, 23, 55, 57)   # minimum longitude, maximum longitude, minimum latitude, maximum latitude
soilmoisture22crop <- crop(soilmoisture22, ext)
soilmoisture22crop
plot(soilmoisture22crop)
plot(soilmoisture22crop[[1]], col=cl)

#------------

#09 Classification

library(terra)
library(imageRy)
library(ggplot2)

im.list()
sun <- im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

sunc <- im.classify(sun)
plotRGB(sun, 1, 2, 3)
plot(sunc)

##### now with matogrosso 
m2006<-im.import("matogrosso_ast_2006209_lrg.jpg")
m1992<-im.import("matogrosso_l5_1992219_lrg.jpg")
plotRGB(m1992)

m1992c<-im.classify(m1992,num_clusters=2) #im.classify tell the amount of classes you want to use to classify
plot(m1992c) #1 and 2 represent the two classes human and forest. human=1 and forest=2

m2006c<-im.classify(m2006,num_clusters=2)
plot(m2006c)

par(mfrow=c(1,2))
plot(m1992c[[1]])
plot(m2006c[[1]])

f1992<-freq(m1992c)
f1992
tot1992<-ncell(m1992c)
#to get the percentage frequency:
p1992 <-f1992*100 / tot1992
p1992
#forest: 83%; human: 17%

f2006<-freq(m2006c)
f2006
tot2006<-ncell(m2006c)
#to get the percentage frequency:
p2006 <-f2006*100 / tot2006
p2006
#forest: 45; human: 55

#building the final table
class<- c("forest","human")
y1992<-c(83,17)
y2006<-c(45,55)

tabout<-data.frame(class,y1992,y2006)
tabout

#final output
p1992<-ggplot(tabout,aes(x=class,y=y1992,color=class))+geom_bar(stat="identity", fill="white")
p2006<-ggplot(tabout,aes(x=class,y=y2006,color=class))+geom_bar(stat="identity", fill="white")
par(mfrow=c(1,2))
plot(p1992)
plot(p2006)

#------------

#10 Variability

# measurement of RS based variability. there are diff indices for measuring behavior of several data altogether 
#it is based on multivariate analysis

library(imageRy)
library(terra)
library(viridis)

im.list()

sent <- im.import("sentinel.png")

# band 1 = NIR
# band 2 = red
# band 3 = green

im.plotRGB(sent, r=1, g=2, b=3)
im.plotRGB(sent, r=2, g=1, b=3)

nir <- sent[[1]]
plot(nir)

# moving window
# focal
sd3 <- focal(nir, matrix(1/9, 3, 3), fun=sd)
plot(sd3)

viridisc <- colorRampPalette(viridis(7))(255)
plot(sd3, col=viridisc)

# Exercise: calculate variability in a 7x7 pixels moving window
sd7 <- focal(nir, matrix(1/49, 7, 7), fun=sd)
plot(sd7, col=viridisc)

# Exercise 2: plot via par(mfrow()) the 3x3 and the 7x7 standard deviation
par(mfrow=c(1,2))
plot(sd3, col=viridisc)
plot(sd7, col=viridisc)

# original image plus the 7x7 sd
im.plotRGB(sent, r=2, g=1, b=3)
plot(sd7, col=viridisc)

#--------------

#11 Principal component analysis

#in order to make a calculation (ex variability) we should choose that single layer, but it cannot be subjectively. you must compact all the dataset
#in just one band and use that band (PC1) to make calculations

library(imageRy)
library(terra)
library(viridis)

im.list()

sent <- im.import("sentinel.png")

pairs(sent)

# perform PCA on sent
sentpc <- im.pca(sent)
pc1 <- sentpc$PC1

viridisc <- colorRampPalette(viridis(7))(255)
plot(pc1, col=viridisc)

# calculating standard deviation ontop of pc1
pc1sd3 <- focal(pc1, matrix(1/9, 3, 3), fun=sd)
plot(pc1sd3, col=viridisc)

pc1sd7 <- focal(pc1, matrix(1/49, 7, 7), fun=sd)
plot(pc1sd7, col=viridisc)

par(mfrow=c(2,3))
im.plotRGB(sent, 2, 1, 3)
# sd from the variability script:
plot(sd3, col=viridisc)
plot(sd7, col=viridisc)
plot(pc1, col=viridisc)
plot(pc1sd3, col=viridisc)
plot(pc1sd7, col=viridisc)

# stack all the standard deviation layers
sdstack <- c(sd3, sd7, pc1sd3, pc1sd7)
names(sdstack) <- c("sd3", "sd7", "pc1sd3", "pc1sd7")
plot(sdstack, col=viridisc)


