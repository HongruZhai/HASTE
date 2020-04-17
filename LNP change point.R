######Simulating LNP dataset and implementing change point analysis###
####https://cran.r-project.org/web/packages/ecp/###
library(ggplot2)
library(tidyverse)
library(mvtnorm)
library(Rcpp)
library(ecp)
###2 field of views, 72 time points, 8 channels(data replicated 8x)

set.seed(46)




