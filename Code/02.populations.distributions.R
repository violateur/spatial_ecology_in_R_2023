# Why do populations disperse over the landscape in a certain manner?

library(sdm)
library(terra)

file <- system.file("external/species.shp", package="sdm")

rana <- vect(file)

rana$Occurrence
# and you obtain presence/absence data
# the "0" is anyaway uncertain, as you could have just missed it, but maybe it was there

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
