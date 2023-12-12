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

#exercise: make a RGB plot using different years
im.plotRGB(stackg, r=1, g=2, b=3) #western part: higher temperatures like usa, in the middle the temperature is higher in the long period.


