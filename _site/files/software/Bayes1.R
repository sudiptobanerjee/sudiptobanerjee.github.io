set.seed(1234)

library(geoR)

Data <- read.table("TempPptElevData.txt", header=T)

Y1 <- Data$Temperature
Y2 <- Data$Precipitation
Elevation <- Data$Elevation

sites <- cbind(Data$Longitude[1:50],Data$Latitude[1:50])
Elevation <- Elevation[1:50]
R <- 6371
sites <- (R*pi/180)*sites

temp.Jan <- Y1[1:50]
temp.Feb <- Y1[51:100]
temp.Mar <- Y1[101:150]
temp.Apr <- Y1[151:200]
temp.May <- Y1[201:250]
temp.Jun <- Y1[251:300]
temp.Jul <- Y1[301:350]
temp.Aug <- Y1[351:400]
temp.Sep <- Y1[401:450]
temp.Oct <- Y1[451:500]
temp.Nov <- Y1[501:550]
temp.Dec <- Y1[551:600]



#Begin Analysis for January

obj <- cbind(sites,temp.Jan,Elevation)

geodat <- as.geodata(obj,coords.col=1:2,data.col=3,covar.col=4)

Predict.index <- seq(from=5,to=50,by=5)
Predict.Elevation <- Elevation[Predict.index]
Predict.Sites <- sites[Predict.index,]
True.values <- temp.Jan[Predict.index]

model.spec <- model.control(trend.d = ~ Elevation, trend.l=~Predict.Elevation, cov.model="matern", kappa=0.5, lambda=1)
prior.spec <-
  prior.control(beta.prior="flat",sigmasq.prior="reciprocal",tausq.rel.prior="uniform",tausq.rel.discrete=seq(from=0.0,to=1.0,by=0.01))
output.spec <- output.control(quantile=c(0.50,0.025,0.975))

bayes1 <- krige.bayes(geodat, locations=Predict.Sites, borders=NULL, model=model.spec, prior=prior.spec, output=output.spec)

out <- bayes1$posterior
out <- out$sample
beta0.qnt <- quantile(out$beta0, c(0.50,0.025,0.975))
beta1.qnt <- quantile(out$beta1, c(0.50,0.025,0.975))
phi.qnt <- quantile(out$phi, c(0.50,0.025,0.975))
sigmasq.qnt <- quantile(out$sigmasq, c(0.50,0.025,0.975))
tausq.rel.qnt <- quantile(out$tausq.rel, c(0.50,0.025,0.975))
tausq <- (out$tausq.rel)*(out$sigmasq) 
tausq.qnt <- quantile(tausq, c(0.50,0.025,0.975))

samples.temp.Jan <- cbind(out$beta0,out$beta1,out$phi,out$sigmasq,tausq)
summary.temp.Jan <- rbind(beta0.qnt,beta1.qnt,phi.qnt,sigmasq.qnt,tausq.qnt)

#write(t(samples.temp.Jan),"ColoradoJanMaternSamples.txt",ncolumns=ncol(samples.temp.Jan))
#write(t(summary.temp.Jan),"ColoradoJanMaternOut.txt",ncolumns=3)

out2 <- bayes1$predictive
predictive.mean <- out2$mean.simulations
predictive.variance <- out2$variance.simulations
predictive.sd <- sqrt(predictive.variance)
predictive.quantiles <- out2$quantiles.simulations

summary.predictive <- cbind(predictive.mean,predictive.sd,predictive.quantiles,True.values)

#write(t(summary.predictive),"ColoradoJanPredictiveOut.txt",ncolumns=ncol(summary.predictive))

#End Analysis for January

detach(package:geoR)

