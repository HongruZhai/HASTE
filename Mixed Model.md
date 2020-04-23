# A Demo of Linear Mixed Effects Model with Single Cells Dataset
Hongru Zhai,
22/04/2020
## Linear Mixed Effects Model Introduction
Mixed models are applied in many disciplines where multiple correlated measurements are made on each unit of interest. The core of mixed model is that it incorporates fixed and random effects. The difference between fixed and random effects is that a fixed effect is an effect that is constant for a given population, but a random effect is an effect that varies for a given population.
## Single Cells Dataset & tasks of interest
The dataset contains 30542 observations of nearly 200 parameters, at this stage the questions of main interest are:
+ Identifying variables that correlate with GFP expression
+ Does internuclear distance correlate with GFP expression?(nuc intens mean/compactness v.s. GFP intens)
+ Do nuclei in the cells with lots of GFP tend to cluster around very bright cells?(GFP intens v.s. distance to bright)

In question 2 and question 3, the parameters concerned are `GFP intens Mean`, `Nuc intens Mean`, and `Distance from GFP bright Mean`. 
Also, we want to know if the effects on GFP expression are different between `High LNP dose`, `Midium LNP dose` and `Low LNP dose`.

One more proposed question: 
+ Is the effect of `Distance to GFP bright` on GFP expression mediated or moderated by some variable?


## Methods to tackle the tasks
+ Since the dependent variable `GFP intens` can approximately be seen as continuous variable that follows normal distribution, it's always good to start with a simple linear regression to discover significant effects of the independent variables on GFP expression. For our purpose(identifying variables that matter), model selection by goodness of fit is not a concern, so we can simply include all 200 variables in the model to identify the significant ones. (Not in this demo)
+ Effect of `Distance from GFP bright`/`Nuclei intensity` on GFP expression across High/Medium/Low LNP dose can be analysed with linear Mixed Effect model, Linear Mixed Effects Model can help estimate both the fixed effect and the random effect
+ In this demo, an example of moderation model is shown, to see if the effect of Distance to GFP bright on GFP expression is moderated by `Nuc intens Mean`, other variables could also be inspected according to needs.


## 


By the look of the dependent variable(GFP intens), it can approximately be seen as continuous variable so linear mixed model can make sense, if it's seen as count variable then generalised mixed model with binomial/possion family should be applied.


The linear regression does not fit well at all, but in causal inference, model fit isn't of concern.



## Linear Mixed Models(GFP expression v.s. Distance from Bright GFP)
*GFP expression against Distance from bright cell for High/Medium/Low LNP doses:*
![GFP vs Bright distance](https://github.com/HongruZhai/HASTE/blob/master/MixedEffectsModel_all.png)
### Linear Mixed Model with only random intercept
results: ###only random intercept, GFP ~  DistanceGFPBright + ( 1 | LNP)

![Only intercept1](https://github.com/HongruZhai/HASTE/blob/master/MixedEffectsModel_groupedlines.png)
### Linear Mixed model with both random intercept and random slope
results:
plot:
![Both inter and slope1](https://github.com/HongruZhai/HASTE/blob/master/MixedEffectsModel_groupedlines2.png)
## Linear Mixed Models(GFP expression v.s. Nuclei intensity)
*GFP expression against Nuclei Intensity for High/Medium/Low LNP doses:*
![GFP vs Nuc](https://github.com/HongruZhai/HASTE/blob/master/Nuc%20vs%20GFP%20points.png)
### Linear Mixed model with only random intercept
results:
Plot:
![intercept2](https://github.com/HongruZhai/HASTE/blob/master/Nuc%20vs%20GFP%20lines%20intercept%20only.png)
### Linear Mixed model with both random intercept and random slope
results:
Plot:
![both inter and slp2](https://github.com/HongruZhai/HASTE/blob/master/Nuc%20vs%20GFP%20with%20int%20and%20slope.png)

## More
Now we know the effect of Nuc on GFP, but is there some variable significantly moderates the effect of Nuc on GFP?
If the experiment is randomized, a causal interpretation is generally possible.
