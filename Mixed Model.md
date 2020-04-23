# A Demo of Linear Mixed Effects Model with Single Cells Dataset
Hongru Zhai,
22/04/2020
## Linear Mixed Effects Model Introduction
Mixed models are applied when we want to decompose variation into levels, given grouping in the data. The core of mixed model is that it incorporates fixed and random effects. The difference between fixed and random effects is that a fixed effect is an effect that is constant for a given population, but a random effect is an effect that varies for a given population. In another word, fixed effect is the part of effect in common for all groups, random effects are the part of effect special or unique for each group.
## Single Cells Dataset & tasks of interest
The dataset contains 30542 observations of nearly 200 attributes, first let's focus on several variables that indicates distances. Here is a table of selected attributes’ information: 
| Variable        | Description           | Data Type  |
| ------------- |:-------------:| -----:|
| `GFP intens Mean`      | GFP intensity, indicator of GFP expression | Numerical |
| `LNP dose`      | LNP dose of the well the observed cell belongs to     |   Categorical(3 levels) |
| `Distance from GFP bright Mean`| Distance of the observed cell from bright cell    |    Numerical |
| `Nuc intens Mean` | Nucleus Intensity   |    Numerical |


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
<p align="center">
<a href="https://www.codecogs.com/eqnedit.php?latex=GFP&space;\sim&space;DistanceGFPBright&space;&plus;&space;(1&space;|&space;LNP)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?GFP&space;\sim&space;DistanceGFPBright&space;&plus;&space;(1&space;|&space;LNP)" title="GFP \sim DistanceGFPBright + (1 | LNP)" /></a>
</p>
By specifying the formula like above, we assume that the slopes for High/Medium/Low LNP dose are the same, only the intercepts are different across the 3 levels. It's basically allowing only the random intercept accounting for the whole random effect.

The mixed model was fitted with R package `lme4` and Python Package `statsmodels`, they would give almost the same results.
<p align="center">
  <img src="https://github.com/HongruZhai/HASTE/blob/master/Results1.JPG" alt="drawing" width="500"/>
</p>

The High LNP dose group has the highest intercept, expressing more GFP on average, but the fixed effect was estimated as 0.1655, disagreed with the effect from simple case regression model. 


![Only intercept1](https://github.com/HongruZhai/HASTE/blob/master/MixedEffectsModel_groupedlines.png)
### Linear Mixed model with both random intercept and random slope
<p align="center">
  <a href="https://www.codecogs.com/eqnedit.php?latex=GFP&space;\sim&space;DistanceGFPBright&space;&plus;&space;(DistanceGFPBright&space;|&space;LNP)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?GFP&space;\sim&space;DistanceGFPBright&space;&plus;&space;(DistanceGFPBright&space;|&space;LNP)" title="GFP \sim DistanceGFPBright + (DistanceGFPBright | LNP)" /></a>
</p>
Now we allow intercept and slope to account for random effect. We see the effects across different LNP doses can be very different now. For high LNP, the estimated effect of Distance to bright cell on GFP expression is even negative.  
<p align="center">
  <img src="https://github.com/HongruZhai/HASTE/blob/master/Results2.JPG" alt="drawing" width="500"/>
</p>

![Both inter and slope1](https://github.com/HongruZhai/HASTE/blob/master/MixedEffectsModel_groupedlines2.png)
## Linear Mixed Models(GFP expression v.s. Nuclei intensity)
*GFP expression against Nuclei Intensity for High/Medium/Low LNP doses:*

By look, the cells with High LNP Dose generally have higher GFP expression. But what about the effect of nuclei intensity on GFP expression? 

![GFP vs Nuc](https://github.com/HongruZhai/HASTE/blob/master/Nuc%20vs%20GFP%20points.png)
### Linear Mixed model with only random intercept
<p align="center">
  <a href="https://www.codecogs.com/eqnedit.php?latex=GFP&space;\sim&space;Nuc&space;&plus;&space;(&space;1&space;|&space;LNP)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?GFP&space;\sim&space;Nuc&space;&plus;&space;(&space;1&space;|&space;LNP)" title="GFP \sim Nuc + ( 1 | LNP)" /></a>
</p>

We fit the mixed model for Nuclei v.s. GFP the same way as previous models. First, we allow only random intercept, we effect was estimated at -0.05475, agreed with the result from linear regression.

<p align="center">
  <img src="https://github.com/HongruZhai/HASTE/blob/master/Result3.png" alt="drawing" width="500"/>
</p>



![intercept2](https://github.com/HongruZhai/HASTE/blob/master/Nuc%20vs%20GFP%20lines%20intercept%20only.png)
### Linear Mixed model with both random intercept and random slope
<p align="center">
  <a href="https://www.codecogs.com/eqnedit.php?latex=GFP&space;\sim&space;Nuc&space;&plus;&space;(&space;Nuc&space;|&space;LNP)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?GFP&space;\sim&space;Nuc&space;&plus;&space;(&space;Nuc&space;|&space;LNP)" title="GFP \sim Nuc + ( Nuc | LNP)" /></a>
</p>
Again, we allow both intercept and slope to vary for groups, the result showed a milder negative fixed effect, but the effect for high LNP group is negatively larger. 

<p align="center">
  <img src="https://github.com/HongruZhai/HASTE/blob/master/Result4.png" alt="drawing" width="500"/>
</p>

![both inter and slp2](https://github.com/HongruZhai/HASTE/blob/master/Nuc%20vs%20GFP%20with%20int%20and%20slope.png)

## Moderation Model
> Does `Distance from GFP Bright` have a role in the effect of `Nuclei Intensity` on GFP expression?


Now we know the effect of Nuc on GFP from mixed model, but is there some variable significantly moderates the effect of Nuc on GFP? 

I would choose again the variable `Distance form GFP Bright cell` to exemplify the moderation model. You can always take other interesting variable to fit the model. 



<p align="center">
  <img src="https://github.com/HongruZhai/HASTE/blob/master/Moderation.png" alt="drawing" width="500"/>
</p>
In this case, the moderation model shows that there's significant of `Nucleus Intensity` on `GFP Intensity`, however, this effect is not significantly moderated by `Distance from GFP Bright Cell`. 

If we want to decompose the path effect further into the direct effect and the indirect effect, we can fit a mediation model. 
<p align="center">
  <img src="https://github.com/HongruZhai/HASTE/blob/master/mediation.png" alt="drawing" width="500"/>
</p>

## More
The couple of variables I chose to start are some intensities that have similar scale with the `GFP intensity`, and because the dependent variable `GFP intensity` is approximated as continous data, anything other than linear models is not needed. But if `GFP intensity` is supposed to be considered as count data, generalised version of the models should be applied, and we don't assume normal distribution anymore. 

The construction of the models largely depends on the purpose of using the data, model fit can be important only for descriptive purpose. Since in the project we want more of a causal inference purpose, the model selection will more rely on the knowledge of the experiments. When the experiment is randomized, a causal interpretation is generally possible. 

