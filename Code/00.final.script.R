#final script including all the different scripts during lectures.

#-----------

#Summary:
#01 Beginning
#02.1 Population Density
#02.2 Population Distributions
#03 Communities

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

#03 Community Multivariate Analysis

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
