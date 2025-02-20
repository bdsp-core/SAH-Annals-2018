print("Current working directory before setting:")
print(getwd())
setwd(getwd())  # Set to wherever the script is running from
print("Current working directory after setting:")
print(getwd())

rm(list = ls())  # clear workspace variables

cis <- function(p, se) {
  alpha <- qnorm(0.95)
  lower <- 1 - (1 - p)^(exp(alpha * (se/((1 - p) * log(1 - p)))))
  upper <- 1 - (1 - p)^(exp(-alpha * (se/((1 - p) * log(1 - p)))))
  data.frame(lower, upper)
}

library(mstate) # use this package for multistate survival analysis
packageDescription("mstate", fields = "Version")

#****** GET THE DATA ********
#dindData<-read.table("mState_data_Corrected.txt",header=T) # load data
dindData<-read.table("tabledata2.txt",header=T) # load data
#dindData<-read.table("tabledataBootstrapSeSpPpNp.txt",header=T)
tmat <- matrix(NA, 3, 3) # define the transition matrix
tmat[1,2:3]<-1:2
tmat[2,3]<-3 
dimnames(tmat) <- list(from = c("nA", "A", "DE"), to = c("nA","A","DE"))
paths(tmat) # list all possible paths
head(dindData)
n<-nrow(dindData)

#******* MAKE TRANSITION MATRIX
tmat<- matrix(NA,3,3)
tmat[1,2:3]<-1:2
tmat[2,3]<-3
dimnames(tmat)<- list(from=c("na","a","d"), to = c("na","a","d")) # give names to dimensions
paths(tmat) # list all the possible state transitions / paths through the model

#******* COVARIATES
covs<- c("risk") # define list of covariates -- just "risk"

#*** convert data to long format needed for mstate -- "prepare" the msdata structure
#msbmt <- msprep(time=c(NA,"natime","ndtime"),status=c(NA,"nastat","ndstat"),data=dindData,trans=tmat,keep=covs)
msbmt <- msprep(time=c(NA,"natime","ndtime"),status=c(NA,"nastat","ndstat"),data=dindData,trans=tmat,keep=covs)
head(msbmt)
events(msbmt) # summarize events

expcovs<-expand.covs(msbmt,covs[1],append=FALSE) # add transition-specific covariates

# append the expanded covariates to the dataset
msbmt<- expand.covs(msbmt,covs,append=TRUE,longnames = FALSE)
c1<- coxph(Surv(Tstart,Tstop,status)~strata(trans),data=msbmt,method="breslow")  # not enough data to risk stratify
# data is now formatted for estimation!

msbmt$al<-0
msbmt$al[msbmt$trans==3]<-1
c2 <- coxph(Surv(Tstart, Tstop, status) ~ al + +risk.1+risk.2+risk.3+strata(to), data = msbmt, method = "breslow")

newd <- data.frame(risk = rep(0, 3), trans = 1:3) # possibly come back and ignore risk
#newd$risk <- factor(newd$risk, levels = 0:4, labels = c("1","2","3","4","5"))
attr(newd, "trans") <- tmat
class(newd) <- c("msdata", "data.frame")
newd <- expand.covs(newd, covs[1], longnames = TRUE)
newd$strata = 1:3 # in this first case each transition belongs to a different stratum

############ calculating  cumulative hazards #############################
msf1 <- msfit(c1, newdata = newd, trans = tmat)  # msfit1 using c1

newd$strata = c(1, 2, 2) # introducing strata variable to create the proportional hazards model
newd$al <- c(0, 0, 1) 
msf2 <- msfit(c2, newdata = newd, trans = tmat) # msfit2 using c2

################
# now make some plots. compare markov stratified vs PH model graphically
par(mfrow = c(1, 2))
par(mfrow = c(1, 1))

############# calculating overall #######################

pt <- probtrans(msf2, predt = 0)
tmat2 <- transMat(x = list(c(2, 4), c(3), c(), c()))
tmat2
msf2$trans <- tmat2
pt <- probtrans(msf2, predt = 0)


###### plotting the over all risk #########################
#png('1Risk_A.png')
#plot(pt, type="filled",ord = c(1,2,3,4), lwd = .2, xlab = "Days since SAH",
#     ylab = "Predicted proportions", cex = .1, legend = c("No alarm, no DIND/DCI",
#                                                          "Alarm, no DIND/DCI", "DIND/DCI after alarm","DIND/DCI without alarm"))


####################################################################
## risk ==1 
####################################################################

whA <- which(msbmt$risk == 1)

newd<-data.frame(risk=rep(0,3),trans=1:3)
newd <- msbmt[rep(whA[1], 3),1:3]
newd$risk<-rep(0,3)
newd$risk<-1
newd$trans<-1:3
class(newd) <- c("msdata", "data.frame")
attr(newd, "trans") <- tmat
newd <- expand.covs(newd, covs, longnames = FALSE)
newd$strata = newd$trans
attr(newd, "trans") <- tmat
newd$strata =c(1,2,2)
newd$al<-c(0,0,1)
msfA<-msfit(c2,newd,trans=tmat)

msfA$trans <- tmat2
pt1 <- probtrans(msfA, predt = 0)

#Stacked probability plot starting from "no alarm" state 
plot(pt1, type="filled",ord = c(1, 2, 3, 4), lwd = 2, xlab = "Days after SAH",
     ylab = "Prediction probabilities", cex = 0.75,legend=c("No alarm, no DIND/DCI",
                                                            "Alarm", "DIND/DCI after alarm","DIND/DCI without alarm"))

write.csv(pt1[1],file="risk_score1.csv")
###########################################################
## risk = 2.5
###########################################################

#whA <- which(msbmt$risk == 2.5)

newd<-data.frame(risk=rep(0,3),trans=1:3)
newd <- msbmt[rep(whA[1], 3),1:3]
newd$risk<-rep(0,3)
newd$risk<-2.5
newd$trans<-1:3
class(newd) <- c("msdata", "data.frame")
attr(newd, "trans") <- tmat
newd <- expand.covs(newd, covs, longnames = FALSE)
newd$strata = newd$trans
attr(newd, "trans") <- tmat
newd$strata =c(1,2,2)
newd$al<-c(0,0,1)
msfA<-msfit(c2,newd,trans=tmat)

msfA$trans <- tmat2
pt25 <- probtrans(msfA, predt = 0)

plot(pt25, type="filled",ord = c(1, 2, 3, 4), lwd = 2, xlab = "Days after SAH",
     ylab = "Prediction probabilities", cex = 0.75,legend=c("No alarm, no DIND/DCI",
                                                            "Alarm", "DIND/DCI after alarm","DIND/DCI without alarm"))

write.csv(pt25[1],file="risk_score2p5.csv")

####################################################################
## calculating for risk==4 
####################################################################
whA <- which(msbmt$risk == 4)

newd<-data.frame(risk=rep(0,3),trans=1:3)
newd <- msbmt[rep(whA[1], 3),1:3]
newd$risk<-rep(0,3)
newd$risk<-4
newd$trans<-1:3
class(newd) <- c("msdata", "data.frame")
attr(newd, "trans") <- tmat
newd <- expand.covs(newd, covs, longnames = FALSE)
newd$strata = newd$trans
attr(newd, "trans") <- tmat
newd$strata =c(1,2,2)
newd$al<-c(0,0,1)
msfA<-msfit(c2,newd,trans=tmat)

msfA$trans <- tmat2
pt4 <- probtrans(msfA, predt = 0)

plot(pt4, type="filled",ord = c(1, 2, 3, 4), lwd = 2, xlab = "Days after SAH",
     ylab = "Prediction probabilities", cex = 0.75,legend=c("No alarm, no DIND/DCI",
                                                            "Alarm", "DIND/DCI after alarm","DIND/DCI without alarm"))

write.csv(pt4[1],file="risk_score4.csv")

