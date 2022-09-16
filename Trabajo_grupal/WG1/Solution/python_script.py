
#######################################

" Homework 1 - solution  "
" @author: Roberto Mendoza "
" @date: 12/09/2020 "

#######################################


import pandas as pd
import numpy as np
import random


"1. IF statement and Loop"

vector = random.sample( range(501) , 20)

for i in range(20):
    x = vector[i]
    
    if x<=100:
        y = x**0.5
    elif (x>100 & x<=300):
        y = x - 5
        
    elif x > 300:
        
        y = 50
        
    vector[i] = y
    
    
vector   
    
"2. IF statement and Loop, escalar function"


## Escalar vector

vector2 = random.sample( range(501) , 100)

for i in range(100):
    x = vector2[i]
    
    maxi = np.max(vector2)
    mini = np.min(vector2)
    
    y = (x-mini)/(maxi-mini)
    
    vector2[i] = y
    
vector2

## Escalar Matrix

total = 100*50

matrix = np.random.normal(1,10,total).reshape(100, 50)

for j in range(matrix.shape[1]):
    
    maxi = np.max(matrix[:,j])
    mini = np.min(matrix[:,j])    
    
    for i in range(matrix.shape[0]):
        
        x = matrix[i,j] 
        y = (x-mini)/(maxi-mini)
        matrix[i,j] = y
        
"3. OLS and Loop"


np.random.seed(175)

x1 = np.random.rand(10000) # uniform distribution  [0,1]
x2 = np.random.rand(10000) # uniform distribution [0,1]
x3 = np.random.rand(10000) # uniform distribution [0,1]
x4 = np.random.rand(10000) # uniform distribution [0,1]
x5 = np.random.rand(10000) # uniform distribution [0,1]
e = np.random.normal(0,1,10000) # normal distribution mean = 0 and sd = 1

# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 0.5*x5 + e

X = np.column_stack((np.ones(10000),x1,x2,x3,x5))        

size = [10,50,80,120,200,500,800,1000,5000]


def reg(X,Y):
         beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y ) 
         y_est =  X @ beta 
         n = X.shape[0]
         k = X.shape[1] - 1 
         nk = n - k    
         sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
         Var = sigma*np.linalg.inv(X.T @ X)
         sd = np.sqrt( np.diag(Var) )
         
         return beta, sd

beta_coef =  np.zeros(X.shape[1])
est_err =  np.zeros(X.shape[1])

for n in size:
    sample = random.sample( range(10000) , n)
    v_coeff = reg(X[sample,:], Y[sample])[0]
    v_sd = reg(X[sample,:], Y[sample])[1]
    beta_coef = np.vstack((beta_coef,v_coeff))  # stack vector 
    est_err = np.vstack((est_err,v_sd))
    
    
# stack vector pero la primera fila está llena de zeros, por eso no se considera la primera fila en
# el dataframe siguiente:
    
table = pd.DataFrame( {"sample_size": size ,
                       "Coeff_int": beta_coef[1:,0] , "Standar_error_int" : est_err[1:,0],
                       "Coeff_x1": beta_coef[1:,1] , "Standar_error_x1" : est_err[1:,1],
                       "Coeff_x2": beta_coef[1:,2] , "Standar_error_x2" : est_err[1:,2],
                       "Coeff_x3": beta_coef[1:,3] , "Standar_error_x3" : est_err[1:,3],
                       "Coeff_x5": beta_coef[1:,4] , "Standar_error_x5" : est_err[1:,4]
                       }) 

"4. OLS and Loop"

from scipy.stats import t # t - student 
import pandas as pd 

np.random.seed(175)

x1 = np.random.rand(800) # uniform distribution  [0,1]
x2 = np.random.rand(800) # uniform distribution [0,1]
x3 = np.random.rand(800) # uniform distribution [0,1]
x4 = np.random.rand(800) # uniform distribution [0,1]
x5 = np.random.rand(800) # uniform distribution [0,1]
x6 = np.random.rand(800) # uniform distribution [0,1]
x7 = np.random.rand(800) # uniform distribution [0,1]
e = np.random.normal(0,1,800) # normal distribution mean = 0 and sd = 1
# Poblacional regression (Data Generating Process GDP)

Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 0.2*x5+0.5*x6+2*x7+e

X = np.column_stack((np.ones(800),x1,x2,x3,x4,x5,x6,x7))


def ols(X,Y, intercepto = True, robust_sd = False):
    
    if intercepto:
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        y_est =  X @ beta 
        n = X.shape[0]
        k = X.shape[1] - 1 
        nk = n - k  
        
        if robust_sd==False:
             
            sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
            Var = sigma*np.linalg.inv(X.T @ X)
            sd = np.sqrt( np.diag(Var) )
            t_est = np.absolute(beta/sd)
            pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
            lower_bound = beta-1.96*sd
            upper_bound = beta+1.96*sd
            SCR = sum(list( map( lambda x: x**2 , Y - y_est)   ))
            SCT = sum(list( map( lambda x: x**2 , Y - np.mean(y_est)   )))
            R2 = 1-SCR/SCT
            rmse = (SCR/n)**0.5
            table = pd.DataFrame( {"ols": beta , "standar_error" : sd ,
                                "Pvalue" : pvalue, "Lower_bound":lower_bound,
                                "Upper_bound":upper_bound} ) 
            fit = {"Root_MSE":rmse, "R2": R2}
            
        else :
             matrix_robust = np.diag(list( map( lambda x: x**2 , Y - y_est)))
             Var = np.linalg.inv(X.T @ X) @ X.T @ matrix_robust @ X @ np.linalg.inv(X.T @ X)
             sd = np.sqrt( np.diag(Var) )
             t_est = np.absolute(beta/sd)
             pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
             lower_bound = beta-1.96*sd
             upper_bound = beta+1.96*sd
             SCR = sum(list( map( lambda x: x**2 , Y - y_est)   ))
             SCT = sum(list( map( lambda x: x**2 , Y - np.mean(y_est)   )))
             R2 = 1-SCR/SCT
             rmse = (SCR/n)**0.5
             table = pd.DataFrame( {"ols": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue, "Lower_bound":lower_bound,
                                 "Upper_bound":upper_bound} ) 
             fit = {"Root_MSE":rmse, "R2": R2}
             
    else:
        
        X = X[:,1:]  #Nos quedamos desde la segunda columan hasta la ultima (no intercepto)
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        y_est =  X @ beta 
        n = X.shape[0]
        k = X.shape[1] - 1 
        nk = n - k  
        
        if robust_sd==False:
             
            sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
            Var = sigma*np.linalg.inv(X.T @ X)
            sd = np.sqrt( np.diag(Var) )
            t_est = np.absolute(beta/sd)
            pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
            lower_bound = beta-1.96*sd
            upper_bound = beta+1.96*sd
            SCR = sum(list( map( lambda x: x**2 , Y - y_est)   ))
            SCT = sum(list( map( lambda x: x**2 , Y - np.mean(y_est)   )))
            R2 = 1-SCR/SCT
            rmse = (SCR/n)**0.5
            table = pd.DataFrame( {"ols": beta , "standar_error" : sd ,
                                "Pvalue" : pvalue, "Lower_bound":lower_bound,
                                "Upper_bound":upper_bound} ) 
            fit = {"Root_MSE":rmse, "R2": R2}
            
        else :
             matrix_robust = np.diag(list( map( lambda x: x**2 , Y - y_est)))
             Var = np.linalg.inv(X.T @ X) @ X.T @ matrix_robust @ X @ np.linalg.inv(X.T @ X)
             sd = np.sqrt( np.diag(Var) )
             t_est = np.absolute(beta/sd)
             pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
             lower_bound = beta-1.96*sd
             upper_bound = beta+1.96*sd
             SCR = sum(list( map( lambda x: x**2 , Y - y_est)   ))
             SCT = sum(list( map( lambda x: x**2 , Y - np.mean(y_est)   )))
             R2 = 1-SCR/SCT
             rmse = (SCR/n)**0.5
             table = pd.DataFrame( {"ols": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue, "Lower_bound":lower_bound,
                                 "Upper_bound":upper_bound} ) 
             fit = {"Root_MSE":rmse, "R2": R2}
                  
    return table, fit         




ols(X,Y)
ols(X,Y, intercepto = False, robust_sd = True)




































