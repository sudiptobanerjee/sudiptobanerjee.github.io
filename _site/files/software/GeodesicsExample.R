source("distonearth.R")

colorado <- read.table("SitesInput.txt", header=T)

lat <- as.numeric(colorado$lat)
lon <- as.numeric(colorado$lon)
loc <- cbind(lon,lat)

dist <- geodetic.distance.matrix(lon,lat)

max.dist <- max(dist)

#dist <- geodetic.distance.dataframe(colorado,lat,lon)

max.dist <- max(dist)

dist <- rdistearth(loc)

max.dist <- max(dist)

#Using "fields" package by Nychka

library(fields)

dist.fields <- rdist.earth(loc,miles=F)
max.dist.fields <- max(dist.fields)

#Euclidean distances in fields package

dist.euclid <- rdist(loc)*6371*pi/180
max.dist.euclid <- max(dist.euclid)

#Chordal distance
dist.chord <- distance.chord.matrix(lon,lat)
max.dist.chord <- max(dist.chord)
 
#Naive Euclid
dist.stretch <- distance.stretch.matrix(lon,lat)
max.dist.stretch <- max(dist.euclid)

#Fuentes' centroid-based transformation
loc.transformed <- lonlat.to.miles(loc)
fuentes.dist <- rdist(loc.transformed)
max.fuentes.dist <- max(fuentes.dist)

#Chicago-Minneapolis example
Chicago <- c(-87.63,41.88)
Minneapolis <- c(-93.22,44.89)
newloc <- rbind(Chicago,Minneapolis)

#Geodesic
ChMn.geodesic <- rdistearth(newloc)[2,1]
#Chord
ChMn.chord <- rdistchord(newloc)[2,1]
#Naive Euclidean
ChMn.euclid <- rdisteuclid(newloc)[2,1]
#Fuentes' Projection
ChMn.transformed <- lonlat.to.miles(newloc)
ChMn.fuentes <- rdist(ChMn.transformed)[2,1] 

#New York-New Orleans example
NY <- c(-73.97,40.78)
NO <- c(-90.25,29.98)
newloc <- rbind(NY,NO)

#Geodesic
NYNO.geodesic <- rdistearth(newloc)[2,1]
#Chord
NYNO.chord <- rdistchord(newloc)[2,1]
#Naive Euclidean
NYNO.euclid <- rdisteuclid(newloc)[2,1]
#Fuentes' centroid-based Projection
NYNO.transformed <- lonlat.to.miles(newloc)
NYNO.fuentes <- rdist(NYNO.transformed)[2,1] 


#Map Projections from mapproj
library(mapproj)

ChMn.mercator <- mapproject(c(Chicago[1],Minneapolis[1]),c(Chicago[2],Minneapolis[2]),projection="mercator")
NYNO.mercator <- mapproject(c(NY[1],NO[1]),c(NY[2],NO[2]),projection="mercator")
colorado.mercator <- mapproject(lon,lat,projection="mercator")

ChMn.mercator.loc <- cbind(ChMn.mercator$x,ChMn.mercator$y)
NYNO.mercator.loc <- cbind(NYNO.mercator$x,NYNO.mercator$y)
colorado.mercator.loc <- cbind(colorado.mercator$x,colorado.mercator$y)

ChMn.mercator.dist <- rdist(ChMn.mercator.loc)[2,1]*6371
NYNO.mercator.dist <- rdist(NYNO.mercator.loc)[2,1]*6371
colorado.mercator.max.dist <- max(rdist(colorado.mercator.loc)*6371)

ChMn.sinusoidal <- mapproject(c(Chicago[1],Minneapolis[1]),c(Chicago[2],Minneapolis[2]),projection="sinusoidal")
NYNO.sinusoidal <- mapproject(c(NY[1],NO[1]),c(NY[2],NO[2]),projection="sinusoidal")
colorado.sinusoidal <- mapproject(lon,lat,projection="sinusoidal")

ChMn.sinusoidal.loc <- cbind(ChMn.sinusoidal$x,ChMn.sinusoidal$y)
NYNO.sinusoidal.loc <- cbind(NYNO.sinusoidal$x,NYNO.sinusoidal$y)
colorado.sinusoidal.loc <- cbind(colorado.sinusoidal$x,colorado.sinusoidal$y)

ChMn.sinusoidal.dist <- rdist(ChMn.sinusoidal.loc)[2,1]*6371
NYNO.sinusoidal.dist <- rdist(NYNO.sinusoidal.loc)[2,1]*6371
colorado.sinusoidal.max.dist <- max(rdist(colorado.sinusoidal.loc)*6371)


#Manual Example

x <- c(Chicago[1],Minneapolis[1])*6371*pi/180
y.rad <- c(Chicago[2],Minneapolis[2])*pi/180
y <- 6371*log(tan(pi/4 + y.rad/2))

ChMn.mercator.dist.manual <- rdist(cbind(x,y))[2,1]

detach(package:fields)
