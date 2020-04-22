import numpy as np
np.random.seed(46)
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.api as sm
import seaborn as sns
from statsmodels.multivariate.cancorr import CanCorr
from statsmodels.stats.multivariate_tools import cancorr
from statsmodels.multivariate.pca import PCA
from statsmodels.multivariate.multivariate_ols import _MultivariateOLS

dat = pd.read_excel('C:/Users/ll/Desktop/HASTE/Single cell morphology data/Single cell morphology data/cell by cell data from 9 wells and 2 sites per well one sheet.xlsx', 'Sheet1', index_col=None)
dat.replace({'A': 1, 'B': 0}, inplace=True)

#####data with high/midium/low LNP dose for mixed effects model
df_mix = dat.drop(dat.columns[1:10], axis = 1)
df_mix = df_mix.loc[:, df_mix.columns != 'Cells no border - Nuc texture/symmetry Profile 3/5 SER-Saddle']
df_mix = df_mix.rename(columns={"Cells no border - GFP intens Mean": "GFP intens Mean", "Cells no border - Nuc intens Mean": "Nuc intens Mean"})


#####First exploration:  on High Dose LNP r5c6 datapoints, 200 variables v.s. GFP intensity

df = dat.loc[dat['LNP dose'] == 'high', :]
df_variables = df.iloc[:, 10:]
df_variables = df_variables.loc[:, df_variables.columns != 'Cells no border - Nuc texture/symmetry Profile 3/5 SER-Saddle']



#####Yield the covariance matrix or correlation matrix, then perform PCA and Canonical Correlation Analysis.
#Python in the library scikit-learn, as Cross decomposition and in statsmodels, as CanCorr.
df_variables.cov()
df_variables.corr().abs()[["Cells no border - GFP intens Mean"]]



##Canonical Correlation Analysis: CCA seeks to quantify the associations between two sets of variables.
#1. Computing Canonical Correlations and canonical variates.
#2. Interpreting canonical viariables.
#3. Inference(Large sample): test if covariance of set1 and set2 is 0

endog = pd.DataFrame(df_variables.iloc[:, [0,6,8]])
exog = pd.DataFrame(df_variables.iloc[:, 10:28])

#1. 
cancorr(endog, exog)
#####1st & 2nd & 3rd Canonical Correlations are 0.89133498, 0.41448753, 0.12295234

result_cancorr = CanCorr(endog, exog, tolerance=1e-8, missing='none')

#Richard Johnson ch.10
test = result_cancorr.corr_test
test().stats
test().stats_mv

#####PCA, 
result_pca = PCA(df_variables, standardize=False, demean=True, missing='drop-row')
result_pca.plot_scree()







#Question1: identify variables that correlate with GFP expression
#####Multivariate Linear Regression Model, selection of predictor variables see p.385 R.Johnson
#GFP intens mean can be seen as count variable, that can be modeled using possion/negbino link in GLM.


##[Linear mixed effects model] can be performed for the effects of High/Midium/Low LNP dose



######Here starts the question2: Does internuclear distance correlate with GFP expression?(nuc intens mean/compactness v.s. GFP intens)
# import statsmodels.formula.api as smf
# mixed_model = smf.mixedlm("'GFP intens Mean' ~ 'Nuc intens Mean'", df_mix, groups=df_mix["LNP dose"])
import statsmodels.regression.mixed_linear_model as smm
import statsmodels.regression.mixed_linear_model as smm
Mixed_model = smm.MixedLM(endog=df_mix['GFP intens Mean'].to_numpy(), exog=df_mix['Nuc intens Mean'].to_numpy(), groups=df_mix['LNP dose'], missing='drop') #the model
result_lmm = Mixed_model.fit()
result_lmm.summary()
#result_lmm.summary().as_latex()

####With only distance variables
df_mix_distance = df_mix.rename(columns={"Cells no border - Distance from GFP bright Mean":"Distance from GFP bright Mean", "Cells no border - Distance intens Mean": "Distance intens Mean"})
df_mix_distance = df_mix_distance.loc[:, ['LNP dose', 'GFP intens Mean', 'Nuc intens Mean', 'Distance from GFP bright Mean', 'Distance intens Mean']]
Mixed_model_distance = smm.MixedLM(endog=df_mix_distance['GFP intens Mean'].to_numpy(), exog=df_mix_distance.loc[:,['Nuc intens Mean', 'Distance from GFP bright Mean', 'Distance intens Mean']].to_numpy(), groups=df_mix_distance['LNP dose'], missing='drop')
result_lmm_distance = Mixed_model_distance.fit()
result_lmm_distance.summary()
##GFP intens mean ~ 1 + Nuc intens mean + (1 | LNP dose), assume that the random effects structure: only vary intercepts bwtween groups, with same slope between LNP doses.



######and question3: do nuclei in the cells with lots of GFP tend to cluster around very bright cells?(GFP intens v.s. distance to bright)








