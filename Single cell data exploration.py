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

#####First exploration:  on High Dose LNP r5c6 datapoints, 200 variables v.s. GFP intensity
dat.replace({'A': 1, 'B': 0}, inplace=True)
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



##[Linear mixed effects model] can be performed for the effects of High/Midium/Low LNP dose



######Here starts the question2: Does internuclear distance correlate with GFP expression?(nuc intens mean/compactness v.s. GFP intens)






######and question3: do nuclei in the cells with lots of GFP tend to cluster around very bright cells?(GFP intens v.s. distance to bright)








