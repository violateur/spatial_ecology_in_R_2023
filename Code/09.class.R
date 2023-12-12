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

m1992c<-im.classify(m1992,num_clusters=2)
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

