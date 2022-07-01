import pandas as pd
import pymc as pm

d = pd.read_csv("data/gp.csv")
d.shape

D = np.array([ np.abs(xi - d.x) for xi in d.x])
I = (D == 0).astype("double")

with pm.Model() as gp:
  nugget = pm.HalfCauchy("nugget", beta=5)
  sigma2 = pm.HalfCauchy("sigma2", beta=5)
  ls     = pm.HalfCauchy("ls",     beta=5)

  Sigma = I * nugget + sigma2 * np.exp(-0.5 * D**2 * ls**2)
  
  y = pm.MvNormal(
    "y", 
    mu=np.zeros(d.shape[0]), 
    cov=Sigma, observed=d.y
  )

with gp:
    post_nuts = pm.sample(
        return_inferencedata = True,
        chains = 2
    )
