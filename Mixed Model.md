# A Demo of Linear Mixed Effects Model used in Single Cells Dataset
Hongru Zhai,
22/04/2020
## Linear Mixed Effects Model Introduction
Mixed models are applied in many disciplines where multiple correlated measurements are made on each unit of interest. The core of mixed model is that it incorporates fixed and random effects. The difference between fixed and random effects is that a fixed effect is an effect that is constant for a given population, but a random effect is an effect that varies for a given population.
## Single Cells Dataset
The dataset contains 30542 observations of nearly 200 parameters, at this stage the questions of main interest are:
+ Identifying variables that correlate with GFP expression
+ Does internuclear distance correlate with GFP expression?(nuc intens mean/compactness v.s. GFP intens)
+ Do nuclei in the cells with lots of GFP tend to cluster around very bright cells?(GFP intens v.s. distance to bright)

In question 2 and question 3, the parameters concerned are `GFP intens Mean`, `Nuc intens Mean`, and `Distance from GFP bright Mean`. 
Also, we want to know if the effects on GFP expression are different between `High LNP dose`, `Midium LNP dose` and `Low LNP dose`.

Linear Mixed Effects Model can help estimate both the fixed effect and the random effect

## Model Specification
