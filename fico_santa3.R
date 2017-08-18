library(geosphere)
library(dplyr)
library(maps)
rm(list=ls())
setwd("I:/kaggle/FICO_santa/")
bulk <- read.csv("gifts.csv")
cpy.bulk <- bulk
# hist(cpy.bulk$Longitude, breaks = 360)

###Exploratory###

# min.trips <- sum(Weight)/1000
# distHaversine(c(Longitude[1],Latitude[1]),c(Longitude[2],Latitude[2])) #Haversine dist example
# dists.pt.1 <- vector(mode = "numeric", length = nrow(bulk))
# for(i in 2:nrow(bulk)){
#   dists.pt.1[i] <- distHaversine(c(Longitude[1],Latitude[1]),c(Longitude[i],Latitude[i]))
# }
# summary(dists.pt.1)
# dists.n.pole <- vector(mode = "numeric", length = nrow(bulk))
# for(i in 1:nrow(bulk)){
#   dists.n.pole[i] <- distHaversine(c(0,90),c(Longitude[i],Latitude[i]))
# }
# summary(dists.n.pole)
# closest.pt.n.pole <- bulk[which.min(dists.n.pole), ]
# closest.pt.n.pole
# points(closest.pt.n.pole$Longitude, closest.pt.n.pole$Latitude, col="blue", pch=20)
# antarctic <- subset(bulk, Latitude < -60)

cpy.bulk <- arrange(cpy.bulk, Longitude)
# View(head(cpy.bulk))

curr.wt <- 0
tripid <- 1
giftrow <- 1
trip.id <- vector(mode = "numeric", length = nrow(cpy.bulk))
gift.id <- vector(mode = "numeric", length = nrow(cpy.bulk))
latitudes <- vector(mode = "numeric", length = nrow(cpy.bulk))
max.wgts <- vector(mode = "numeric", length = 1431)
i <- 1

while(nrow(cpy.bulk) > 0){
    if (curr.wt + cpy.bulk$Weight[i] <= 999) {
        curr.wt <- curr.wt + cpy.bulk$Weight[i]
        gift.id[giftrow] <- cpy.bulk$GiftId[i]
        trip.id[giftrow] <- tripid
        latitudes[giftrow] <- cpy.bulk$Latitude[i]
        giftrow <- giftrow + 1
        i <- i + 1
    } else if (curr.wt + cpy.bulk$Weight[i] > 1000) {
        i <- i + 1
    } else {
        max.wgts[tripid] <- curr.wt
        curr.wt <- 0
        tripid <- tripid + 1
        cpy.bulk <- cpy.bulk[!cpy.bulk$GiftId %in% gift.id, ]
        cpy.bulk <- arrange(cpy.bulk, Longitude)
        i <- 1
        cat(paste(" ..", tripid))
    }
}

max.wgts <- max.wgts[1:1431]
answer.key <- data.frame(gift.id, trip.id, latitudes)
View(answer.key)
answer.key2 <- arrange(answer.key, trip.id, desc(latitudes))
View(answer.key2)
final.key <- data.frame(answer.key2$gift.id, answer.key2$trip.id)
write.csv(final.key, "submission3.csv")
