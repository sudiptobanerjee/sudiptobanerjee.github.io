                                        #GETTING STARTED WITH geoR#

                                        #Step 1: Always set the seed.# 
set.seed(1234)

                                        #Step 2: Read a data set. We assume
                                        #that the source file (this file) is in the same directory
                                        #as the data file "scallops.txt".#
scallops <- read.table("scallops.txt", header=T)

                                        #Step 3: Draw a simple histogram#
hist(scallops$tcatch)

                                        #Step 4: Seeing the skewness, we want to use the log of the catches
                                        #Create dataframe "myscallops" with "lgcatch" as a new column
myscallops <- scallops
myscallops[,"lgcatch"] <- log(scallops$tcatch+1)
summary(myscallops$lgcatch)

                                        #Step 5: Draw another histogram of the log-catch
hist(myscallops$lgcatch)

                                        #Step 6: Plot the sites#
plot(myscallops$long, myscallops$lat)

                                        #Step 7: Exploratory tools: Image, contour and perspective plots#
library(akima)
int.scp <- interp.new(myscallops$long,myscallops$lat,myscallops$lgcatch)
#lat.lim_c(min(myscallops$lat),max(myscallops$lat))
#lon.lim_c(min(myscallops$lon),max(myscallops$lon))
lat.lim <- range(myscallops$lat)
lon.lim <- range(myscallops$lon)
image(int.scp, xlim=lon.lim, ylim=lat.lim, xlab="Longitude", ylab="Latitude")
contour(int.scp, add=T)
#persp(int.scp,xlim=range(myscallops$lon),ylim=range(myscallops$lat))

                                        #Step 8: Spatial analysis with geoR#
library(geoR)

                                        #Step 8a: Convert lat-lon to planar coordinates using naive scaling#
R <- 6371
lat <- myscallops$lat*pi/180
lon <- myscallops$long*pi/180

u <- cbind(R*lon, R*lat)
#u <- cbind(R*cos(lat)*cos(lon), R*cos(lat)*sin(lon), R*sin(lat))

#obj_cbind(myscallops$long,myscallops$lat,myscallops$lgcatch)
obj <- cbind(u,myscallops$lgcatch)

                                        #Step 8b: Create "geodata" object as dataframe for geoR#
scallops.geo <- as.geodata(obj,coords.col=1:2,data.col=3)

                                        #Step 8c: Create classical and robust variograms#
scallops.var <- variog(scallops.geo, estimator.type="classical")
scallops.var.robust <- variog(scallops.geo, estimator.type="modulus")

par(mfrow=c(2,1))
plot(scallops.var)
plot(scallops.var.robust)

                                        #Step 8d: Estimate variogram parameters using weighted least squares#
scallops.var.fit <- variofit(scallops.var.robust,ini.cov.pars=c(1.0,2.0),cov.model="exponential", fix.nugget=FALSE,nugget=1.0)
summary(scallops.var.fit)

                                        #Step 8e: Estimate parameters using maximum likelihood estimates#
scallops.lik.fit <- likfit(scallops.geo,ini.cov.pars=c(1.0,2.0),cov.model="exponential",trend="cte", fix.nugget=FALSE,nugget=1.0, nospatial=FALSE)
summary(scallops.lik.fit)
scallops.lik.fit$parameters.summary
scallops.lik.fit$beta.var # This produces the variance of estimated beta

                                        #Step 8f: Create locations to predict#
u.loci <- rbind(c(-73.0,39.5),c(-72.5,40.0))
u.loci <- (R*pi/180)*u.loci

                                        #Step 8g: Carry out conventional kriging#
scallops.krige.conv <- krige.conv(scallops.geo, locations=u.loci, borders=NULL, krige=krige.control(cov.pars=c(1,0.25)))

                                        #Step 8h: Carry out Bayesian kriging#
#scallops.krige.bayes <- krige.bayes(scallops.geo, locations="no", borders=NULL, model=model.control(trend.d = "cte", cov.model="matern", kappa=0.5, lambda=1), prior=prior.control(beta.prior="flat",sigmasq.prior="reciprocal",tausq.rel.prior="uniform",tausq.rel.discrete=seq(from=0.0,to=1.0,by=0.01)))

#out <- scallops.krige.bayes$posterior
#out <- out$sample
#beta.qnt <- quantile(out$beta, c(0.50,0.025,0.975))
#phi.qnt <- quantile(out$phi, c(0.50,0.025,0.975))
#sigmasq.qnt <- quantile(out$sigmasq, c(0.50,0.025,0.975))
#tausq.rel.qnt <- quantile(out$tausq.rel, c(0.50,0.025,0.975))
