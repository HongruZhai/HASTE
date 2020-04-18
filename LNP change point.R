######Simulating LNP dataset and implementing change point analysis###
####https://cran.r-project.org/web/packages/ecp/###
library(ggplot2)
library(tidyverse)
library(mvtnorm)
library(Rcpp)
library(ecp)
library(simstudy)
###2 field of views, 72 time points, 8 channels(data replicated 8x)
###assume that there's 8 periods of growth in the 60timepoints
set.seed(46)

#####Univariate case
period1 <- rnorm(32, 20, 5)
period2 <- rnorm(160, 30, 5)
period3 <- rnorm(160, 25, 7)
period4 <- rnorm(160, 60, 10)
period5 <- rnorm(160, 75, 10)
period6 <- rnorm(160, 70, 12)
period7 <- rnorm(160, 35, 10)
period8 <- rnorm(160, 25, 12)
density <- matrix(c(period1, period2, period3, period4, 
                    period5, period6, period7, period8),
                  ncol = 1)
id <- seq(1:1152)
df <- data.frame(x = id, density = density)

#divisive algorithm
output <- e.divisive(as.matrix(df$density), R = 199, alpha = 2)
output$estimates
output$p.values

###generating dataset and estimating 10 times
estimates <- matrix(data = NA, nrow = 10, ncol = 8)
for (i in 1:10) {
  #set.seed(Sys.time())
  period1 <- rnorm(32, 20, 5)
  period2 <- rnorm(160, 30, 5)
  period3 <- rnorm(160, 25, 7)
  period4 <- rnorm(160, 60, 10)
  period5 <- rnorm(160, 75, 10)
  period6 <- rnorm(160, 70, 12)
  period7 <- rnorm(160, 35, 10)
  period8 <- rnorm(160, 25, 12)
  density <- matrix(c(period1, period2, period3, period4, 
                      period5, period6, period7, period8),
                    ncol = 1)
  id <- seq(1:1152)
  df <- data.frame(x = id, density = density)
  estimates[i, ] = e.divisive(as.matrix(df$density), 
                           R = 199, 
                           alpha = 2)$estimates[1:8]
}

estimates <- as.data.frame(estimates)

index <- seq(1:10)
sixth.change.point <- data.frame('iteration' = index, '6th change point' = estimates$V6)

ggplot(data = sixth.change.point, aes(iteration)) +
  geom_line(aes(y=X6th.change.point)) +
  geom_smooth(method = lm, aes(y=X6th.change.point))

####how large change in the series they want to detect?
####which algorithm performs better when predicting 
####first to change feature?








