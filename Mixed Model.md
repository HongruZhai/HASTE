# A Demo of Linear Mixed Effects Model used in Single Cells Dataset
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
+ Since the dependent variable `GFP intens` can approximately be seen as continuous variable that follows normal distribution, it's always good to start with a simple linear regression to discover significant effects of the independent variables on GFP expression. For our purpose(identifying variables that matter), model selection by goodness of fit is not a concern, so we can simply include all 200 variables in the model to identify the significant ones.
+ Effect of `Distance from GFP bright`/`Nuclei intensity` on GFP expression across High/Medium/Low LNP dose can be analysed with linear Mixed Effect model, Linear Mixed Effects Model can help estimate both the fixed effect and the random effect
+ In this demo, an example of moderation model is shown, to see if the effect of Distance to GFP bright on GFP expression is moderated by `Nuc intens Mean`, other variables could also be inspected according to needs.


## Model Specification


By the look of the dependent variable(GFP intens), it can approximately be seen as continuous variable so linear mixed model can make sense, if it's seen as count variable then generalised mixed model with binomial/possion family should be applied.


<table style="text-align:center"><tr><td colspan="2" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td><em>Dependent variable:</em></td></tr>
<tr><td></td><td colspan="1" style="border-bottom: 1px solid black"></td></tr>
<tr><td style="text-align:left"></td><td>GFP</td></tr>
<tr><td colspan="2" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Nuc</td><td>-0.042<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(0.003)</td></tr>
<tr><td style="text-align:left"></td><td></td></tr>
<tr><td style="text-align:left">DistanceGFPBright</td><td>-0.420<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(0.028)</td></tr>
<tr><td style="text-align:left"></td><td></td></tr>
<tr><td style="text-align:left">Constant</td><td>1,205.462<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(9.930)</td></tr>
<tr><td style="text-align:left"></td><td></td></tr>
<tr><td colspan="2" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Observations</td><td>30,542</td></tr>
<tr><td style="text-align:left">R<sup>2</sup></td><td>0.011</td></tr>
<tr><td style="text-align:left">Adjusted R<sup>2</sup></td><td>0.011</td></tr>
<tr><td style="text-align:left">Residual Std. Error</td><td>1,048.657 (df = 30539)</td></tr>
<tr><td style="text-align:left">F Statistic</td><td>172.494<sup>***</sup> (df = 2; 30539)</td></tr>
<tr><td colspan="2" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"><em>Note:</em></td><td style="text-align:right"><sup>*</sup>p<0.1; <sup>**</sup>p<0.05; <sup>***</sup>p<0.01</td></tr>
</table>

The linear regression does not fit well at all, but in causal inference, model fit isn't of concern.


###only random intercept, GFP ~  DistanceGFPBright + ( 1 | LNP)

<table style="text-align:center"><tr><td colspan="2" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td><em>Dependent variable:</em></td></tr>
<tr><td></td><td colspan="1" style="border-bottom: 1px solid black"></td></tr>
<tr><td style="text-align:left"></td><td>GFP</td></tr>
<tr><td colspan="2" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">DistanceGFPBright</td><td>0.166<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(0.035)</td></tr>
<tr><td style="text-align:left"></td><td></td></tr>
<tr><td style="text-align:left">Constant</td><td>1,025.919<sup>***</sup></td></tr>
<tr><td style="text-align:left"></td><td>(153.604)</td></tr>
<tr><td style="text-align:left"></td><td></td></tr>
<tr><td colspan="2" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Observations</td><td>30,542</td></tr>
<tr><td style="text-align:left">Log Likelihood</td><td>-255,373.200</td></tr>
<tr><td style="text-align:left">Akaike Inf. Crit.</td><td>510,754.400</td></tr>
<tr><td style="text-align:left">Bayesian Inf. Crit.</td><td>510,787.700</td></tr>
<tr><td colspan="2" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"><em>Note:</em></td><td style="text-align:right"><sup>*</sup>p<0.1; <sup>**</sup>p<0.05; <sup>***</sup>p<0.01</td></tr>
</table>

## More
Now we know the effect of Nuc on GFP, but is there some variable significantly moderates the effect of Nuc on GFP?
If the experiment is randomized, a causal interpretation is generally possible.
