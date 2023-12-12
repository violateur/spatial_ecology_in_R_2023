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
