# -*- coding: utf-8 -*-
"""
Created on Sat Sep 24 10:04:08 2022

@author: User
"""
import numpy as np
import pandas as pd
from pandas import DataFrame, Series
import statistics
import inspect
import pyreadr  # Load R dataset
import os # for usernanme y set direcotrio
os.chdir(f"C:/Users/user/Documentos/Git_Hub/1ECO35_2022_2/Lab4") 
cps2012_env = pyreadr.read_r("../data/cps2012.Rdata") 
from sklearn import linear_model
print(dir(linear_model))


class OLS(object):
    
    def __init__(self, X,Y, robust_sd = False):
        
        self.X = X
        self.Y = Dataset.iloc[:,1]
        self.W = Dataset.loc[:,'exp1':'exp4']
        robust_sd = False
        self.robust_sd = robust_sd
        
    if robust_sd==False:  
        def Algebralineal(self):
            
            self.n = self.X.shape[0]
            k = self.X.shape[1]
            X2 = np.column_stack((np.ones(self.n ), self.W.to_numpy() ))
            Y1 = self.Y.to_numpy().reshape(self.n  ,1)
            self.X2 = X2
            self.Y1 = Y1
            self.nk = self.n - k
        
        def Coefreg(self):
            
            self.Algebralineal()
            
            self.beta = np.linalg.inv(self.X2.T @ self.X2) @ ((self.X2.T) @ self.Y1 )
             
            
        def R2yMSE(self):
            
            self.Algebralineal()  # run function 
            self.Coefreg()
            
            y_est =  self.X2 @ self.beta
            self.y_est = y_est
            error = self.Y1 - y_est
            self.SCR = np.sum(np.square(error))
            SCT = np.sum(np.square(self.Y1 - np.mean(self.Y1))) 
    
            R2 = 1 - self.SCR/SCT
            rmse = (self.SCR/self.n)**0.5
    
            return R2      
     
        def estandar(self):
            
            self.Algebralineal()
            self.Coefreg()
            self.R2yMSE()
            
            scr = self.SCR
            sigma =  scr / self.nk
            Var = sigma*np.linalg.inv(self.X2.T @ self.X2)
            self.var = Var
            sd = np.sqrt( np.diag(Var) )
            t_est = np.absolute(self.beta/sd)
            pvalue = (1 - t.cdf(t_est, df=self.nk) ) * 2
            lower_bound = self.beta-1.96*sd
            upper_bound = self.beta+1.96*sd
        
        
        def robusta(self):
            
            self.Algebralineal()
            self.Coefreg()
            self.R2yMSE()
            self.estandar()
            
            error = self.Y1 - self.y_est
            matrix_robust = np.diag(np.square(error))
            Var = np.linalg.inv(self.X2.T @ self.X2) @ self.X2.T @ matrix_robust @ self.X2 @ np.linalg.inv(self.X2.T @ self.X2)
            sd = np.sqrt( np.diag(Var) )
            lower_bound = self.beta-1.96*sd
            upper_bound = self.beta+1.96*sd
        
        def Table(self, **Kargs):
            
            self.Algebralineal()
            self.Coefreg()
            self.R2yMSE()
            self.estandar()
         
            scr = self.SCR
            sigma =  scr / self.nk
            Var = sigma*np.linalg.inv(self.X2.T @ self.X2)
            sd = np.sqrt( np.diag(Var) )
            lower_bound = self.beta-1.96*sd
            upper_bound = self.beta+1.96*sd
            
            if (Kargs['Output'] == "DataFrame"):
    
                   df = pd.DataFrame( {"OLS": self.beta.flatten() , "standar_error" : sd.flatten()} )
                    
                    
            elif (Kargs['Output'] == "Diccionario"):
        
                df ={"OLS": self.beta.flatten() , "standar_error" : sd.flatten() ,
                                        "variance" : self.var.flatten() , "lower_bound" : lower_bound.flatten() , "upper_bound" : upper_bound.flatten() }
        
        
            return df    

Dataset = cps2012.iloc[ : ,  np.where( variance_cols != 0   )[0] ]

Reg1 = OLS(X,Y)
Reg1.Algebralineal()
Reg1.Coefreg()
Reg1.R2yMSE()
Reg1.beta
Reg1.estandar()
Reg1.robusta()
Reg1.Table(Output = "DataFrame")
Reg1.Table(Output = "Diccionario")['OLS'] 
Reg1.Table(Output = "Diccionario")['standar_error'] 
Reg1.Table(Output = "Diccionario")['variance'] 
Reg1.Table(Output = "Diccionario")['lower_bound'] 
Reg1.Table(Output = "Diccionario")['upper_bound'] 
         

