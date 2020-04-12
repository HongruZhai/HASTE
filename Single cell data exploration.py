import numpy as np
np.random.seed(46)
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.api as sm
from statsmodels.multivariate.cancorr import CanCorr

dat = pd.read_excel('C:/Users/ll/Desktop/HASTE/Single cell morphology data/Single cell morphology data/cell by cell data from 9 wells and 2 sites per well one sheet.xlsx', 'Sheet1', index_col=None)

#####First exploration:  on High Dose LNP r5c6 datapoints, 200 variables v.s. GFP intensity
df = dat.loc[dat['LNP dose'] == 'high', :]
df_variables = df.iloc[:, 10:]




#####Yield the covariance matrix or correlation matrix, then perform PCA and Canonical Correlation Analysis.
#Python in the library scikit-learn, as Cross decomposition and in statsmodels, as CanCorr.
df_variables.cov()


endog = pd.DataFrame(df_variables.iloc[:, 0]).to_numpy()
exog = pd.DataFrame(df_variables.iloc[:, 1:]).to_numpy()
CanCorr(endog, exog, tolerance=1e-8, missing='none')












