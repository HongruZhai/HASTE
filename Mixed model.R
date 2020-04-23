library(lme4)
library(ggplot2)
library(readr)
library(tibble)
library(dplyr)
library(optimx)
library(mediation)
library(stargazer)

df = read.csv(file = '~/cell by cell data from 9 wells and 2 sites per well one sheet.csv',header = TRUE)

names(df)[names(df) == "锘縇NP.dose"] = "LNP dose"


df <- dplyr::select(df, "LNP dose", "GFP.intens.Mean", "Nuc.intens.Mean", 
             "Distance.from.GFP.bright.Mean", "Distance.intens.Mean")
names(df)[names(df) == "LNP dose"] = "LNP"
names(df)[names(df) == "GFP.intens.Mean"] = "GFP"
names(df)[names(df) == "Nuc.intens.Mean"] = "Nuc"
names(df)[names(df) == "Distance.from.GFP.bright.Mean"] = "DistanceGFPBright"
names(df)[names(df) == "Distance.intens.Mean"] = "DisIntens"

#####Question1. identify variables that correlate with GFP expression
model <- lm(GFP ~ Nuc + DistanceGFPBright, data = df)
#stargazer::stargazer(model, type = "html", out = "lm.html")



###only random intercept, GFP ~  DistanceGFPBright + ( 1 | LNP)
lmer.fit <- lme4::lmer(GFP ~  DistanceGFPBright + ( 1 | LNP), data = df )
RandomIntercept <- unlist(ranef(lmer.fit))
FixedEf <- fixef(lmer.fit)
stargazer::stargazer(lmer.fit, type = "html", out = "lmer1.html")

df_high <- filter(df, LNP == "high")
df_medium <- filter(df, LNP == "medium")
df_low <- filter(df, LNP == "low")

# png('MixedEffectsModel_all.png', width = 450, height = 450, 
#     units = "px")
# plot(df_high$DistanceGFPBright,df_high$GFP, xlim=c(0,1300), ylim=c(0,6000), pch=3, xlab="Distance from GFP bright",ylab="GFP intensity", col = 'yellow')
# points(df_medium$DistanceGFPBright,df_medium$GFP, col='orange', pch=3)
# points(df_low$DistanceGFPBright,df_low$GFP, col='blue', pch=3)
# legend(800, 5400, c("High LNP","Medium LNP","Low LNP"), lty=c(1,1), col=c('yellow','orange', 'blue'))
# dev.off()

png('MixedEffectsModel_all.png', width = 450, height = 450, 
    units = "px")
plot(df_high$GFP, df_high$DistanceGFPBright, xlim=c(0,4000), ylim=c(0,1300), pch=3, ylab="Distance from GFP bright",xlab="GFP intensity", col = 'yellow')
points(df_medium$GFP,df_medium$DistanceGFPBright, col='orange', pch=3)
points(df_low$GFP, df_low$DistanceGFPBright,col='blue', pch=3)
legend(2000, 1200, c("High LNP","Medium LNP","Low LNP"), lty=c(1,1), col=c('yellow','orange', 'blue'))
dev.off()

png('MixedEffectsModel_groupedlines.png', width = 450, height = 450,
    units = "px")
#plot(xlim=c(0,1300), ylim=c(0,6000), xlab="Distance from GFP bright",ylab="GFP intensity")
plot(df_high$DistanceGFPBright, FixedEf[1] + FixedEf[2]*df_high$DistanceGFPBright + RandomIntercept[1],type = 'l',xlab="Distance from GFP bright",ylab="GFP intensity",xlim=c(50,1300), ylim=c(800,1400), col = 'yellow')
lines(df_medium$DistanceGFPBright, FixedEf[1] + FixedEf[2]*df_medium$DistanceGFPBright + RandomIntercept[2], col = 'orange')
lines(df_low$DistanceGFPBright, FixedEf[1] + FixedEf[2]*df_low$DistanceGFPBright + RandomIntercept[3], col = 'blue')
legend(800, 1400, c("High LNP","Medium LNP","Low LNP"), lty=c(1,1), col=c('yellow','orange', 'blue'))
dev.off()


###both random intercept and random slope
###GFP ~  DistanceGFPBright + ( DistanceGFPBright | LNP)
lmer.fit2 <- lme4::lmer(GFP ~  DistanceGFPBright + ( DistanceGFPBright | LNP) , data = df, REML = FALSE) 
RandomIntercept2 <- unlist(ranef(lmer.fit2))
FixedEf2 <- fixef(lmer.fit2)

png('MixedEffectsModel_groupedlines2.png', width = 450, height = 450,
    units = "px")
#plot(xlim=c(0,1300), ylim=c(0,6000), xlab="Distance from GFP bright",ylab="GFP intensity")
plot(df_high$DistanceGFPBright, FixedEf2[1] + (RandomIntercept2[4] + FixedEf2[2])*df_high$DistanceGFPBright + RandomIntercept2[1],type = 'l',xlab="Distance from GFP bright",ylab="GFP intensity",xlim=c(50,1300), ylim=c(800,1400), col = 'yellow')
lines(df_medium$DistanceGFPBright, FixedEf2[1] + (RandomIntercept2[5] + FixedEf2[2])*df_medium$DistanceGFPBright + RandomIntercept2[2], col = 'orange')
lines(df_low$DistanceGFPBright, FixedEf2[1] + (RandomIntercept2[6] + FixedEf2[2])*df_low$DistanceGFPBright + RandomIntercept2[3], col = 'blue')
legend(800, 1400, c("High LNP","Medium LNP","Low LNP"), lty=c(1,1), col=c('yellow','orange', 'blue'))
dev.off()

##########Now Nuc intens v.s. GFP
###only random intercept
lmer.fit3 <- lme4::lmer(GFP ~  Nuc + ( 1 | LNP), data = df )
RandomIntercept3 <- unlist(ranef(lmer.fit3))
FixedEf3 <- fixef(lmer.fit3)

png('Nuc vs GFP points.png', width = 450, height = 450, 
    units = "px")
plot(df_high$Nuc,df_high$GFP, xlim=c(0,1300), ylim=c(0,3000), pch=3, xlab="Nuclei intensity",ylab="GFP intensity", col = 'yellow')
points(df_medium$Nuc,df_medium$GFP, col='orange', pch=3)
points(df_low$Nuc,df_low$GFP, col='blue', pch=3)
dev.off()

png('Nuc vs GFP lines intercept only.png', width = 450, height = 450,
    units = "px")
plot(df_high$Nuc, FixedEf3[1] + FixedEf3[2]*df_high$Nuc + RandomIntercept3[1],type = 'l',xlab="Nuclei intensity",ylab="GFP intensity",xlim=c(50,1300), ylim=c(800,1500), col = 'yellow')
lines(df_medium$Nuc, FixedEf3[1] + FixedEf3[2]*df_medium$Nuc + RandomIntercept3[2], col = 'orange')
lines(df_low$Nuc, FixedEf3[1] + FixedEf3[2]*df_low$Nuc + RandomIntercept3[3], col = 'blue')
legend(800, 1300, c("High LNP","Medium LNP","Low LNP"), lty=c(1,1), col=c('yellow','orange', 'blue'))
dev.off()

#With both random intercept and random slope
lmer.fit4 <- lme4::lmer(GFP ~  Nuc + ( Nuc | LNP), data = df )
RandomIntercept4 <- unlist(ranef(lmer.fit4))
FixedEf4 <- fixef(lmer.fit4)


png('Nuc vs GFP with int and slope.png', width = 450, height = 450,
    units = "px")
#plot(xlim=c(0,1300), ylim=c(0,6000), xlab="Distance from GFP bright",ylab="GFP intensity")
plot(df_high$Nuc, FixedEf4[1] + (RandomIntercept4[4] + FixedEf4[2])*df_high$Nuc + RandomIntercept4[1],type = 'l',xlab="Nuclei intensity",ylab="GFP intensity",xlim=c(50,1300), ylim=c(800,1500), col = 'yellow')
lines(df_medium$Nuc, FixedEf4[1] + (RandomIntercept4[5] + FixedEf4[2])*df_medium$Nuc + RandomIntercept4[2], col = 'orange')
lines(df_low$Nuc, FixedEf4[1] + (RandomIntercept4[6] + FixedEf4[2])*df_low$Nuc + RandomIntercept4[3], col = 'blue')
legend(800, 1200, c("High LNP","Medium LNP","Low LNP"), lty=c(1,1), col=c('yellow','orange', 'blue'))
dev.off()

#Now we know the effect of Nuc on GFP, but is there some variable significantly moderates the effect of Nuc on GFP?
#If the experiment is randomized, a causal interpretation is generally possible.
moderation <- lm(GFP ~ Nuc + DistanceGFPBright + Nuc*DistanceGFPBright, data = df)
mediation <- lm(Nuc ~ DistanceGFPBright, data = df)
mod <- mediation::mediate(mediation, moderation, sims = 500, 
                          treat = "DistanceGFPBright", mediator = "Nuc")

