# 5/10 population ecology 

#a package is needed 

install.packages("spatstat")
library(spatstat)

bei
#plottind te data
plot(bei)

#to change the dimension of the spots: 
plot(bei, cex=.5)

#change the symbol -pch
plot(bei, cex=.2, pch=19)

#let's look the other additional dataset: bei.extra
bei.extra

#plot bei.extra
plot(bei.extra)

#let's use only part of the dataset: use $ to address just elev and then plot elev. then assign the name to the object
bei.extra$elev
plot(bei.extra$elev)
elevation<- bei.extra$elev
plot(elevation)
#the same assignment but with a different path
elevation2<-bei.extra[[1]]
plot(elevation2)

install.packages("vegan")
library(vegan)



