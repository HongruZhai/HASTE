# A Demo of Linear Mixed Effects Model with Single Cells Dataset
Hongru Zhai,
22/04/2020
## Linear Mixed Effects Model Introduction
Mixed models are applied when we want to decompose variation into levels, given grouping in the data. The core of mixed model is that it incorporates fixed and random effects. The difference between fixed and random effects is that a fixed effect is an effect that is constant for a given population, but a random effect is an effect that varies for a given population. 
## Single Cells Dataset & tasks of interest
The dataset contains 30542 observations of nearly 200 attributes, first let's focus on several variables that indicates distances. Here is a table of selected attributes’ information: 
| Variable        | Description           | Data Type  |
| ------------- |:-------------:| -----:|
| GFP intens Mean      | GFP intensity, indicator of GFP expression | Numerical |
| LNP dose      | LNP dose of the well the observed cell belongs to     |   Categorical(3 levels) |
| Distance from GFP bright Mean| Distance of the observed cell from bright cell    |    Numerical |
| Nuc intens Mean | Nucleus Intensity   |    Numerical |


At this stage, the questions of main interest are:
+ Identifying variables that correlate with GFP expression
+ Does internuclear distance correlate with GFP expression? (nuc intens mean/compactness v.s. GFP intens)
+ Do nuclei in the cells with lots of GFP tend to cluster around very bright cells? (GFP intens v.s. distance to bright)

In question 2 and question 3, the parameters concerned are `GFP intens Mean`, `Nuc intens Mean`, and `Distance from GFP bright Mean`. 
Also, we want to know if the effects on GFP expression are different between `High LNP dose`, `Midium LNP dose` and `Low LNP dose`.

One more proposed question: 
+ Is the effect of `Distance to GFP bright` on GFP expression mediated or moderated by some variable?


## Methods to tackle the tasks



The answers we want for the questions above is some causal relationship. If the experiment is randomized, a causal interpretation is generally possible for our models.  

+ Since the dependent variable `GFP intens` can approximately be seen as continuous variable that follows normal distribution, it's always good to start with a simple linear regression to discover significant effects of the independent variables on GFP expression. For our purpose(identifying variables that matter), model selection by goodness of fit is not a concern, so we can simply include all 200 variables in the model to identify the significant ones. (Not in this demo)
+ Effect of `Distance from GFP bright`/`Nuclei intensity` on GFP expression across High/Medium/Low LNP dose can be analysed with **Linear Mixed Effect Model**, Linear Mixed Effects Model can help estimate both the fixed effect and the random effect. 

By the look of the dependent variable(GFP intens), it can approximately be seen as continuous variable so linear mixed model can make sense, if it's seen as count variable then generalised mixed model with binomial/possion family should be applied.

We also want to describe how exactly GFP expression is affected by certain variable. Models of this kind are commonly refered to as 'Path Analysis' or 'Mediation/Moderation Analysis' 
+ In this demo, an example of **Moderation Model** is shown, to see if the effect of `Distance to GFP bright` on GFP expression is moderated by `Nuc intens Mean`, in the future, other variables could also be inspected according to needs.











## Linear Mixed Models(GFP expression v.s. Distance from Bright GFP)
*GFP expression against Distance from bright cell for High/Medium/Low LNP doses:*
![GFP vs Bright distance](https://github.com/HongruZhai/HASTE/blob/master/MixedEffectsModel_all.png)
![Alan](https://github.com/HongruZhai/HASTE/blob/master/Alan%20slides.png)
### Linear Mixed Model with only random intercept
<a href="https://www.codecogs.com/eqnedit.php?latex=GFP&space;\sim&space;DistanceGFPBright&space;&plus;&space;(1&space;|&space;LNP)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?GFP&space;\sim&space;DistanceGFPBright&space;&plus;&space;(1&space;|&space;LNP)" title="GFP \sim DistanceGFPBright + (1 | LNP)" /></a>




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

## Conclusions
The model results suggesting that there are random effects in the dataset. 
