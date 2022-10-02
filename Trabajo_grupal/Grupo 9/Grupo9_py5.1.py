#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import numpy as np
import pandas as pd
from pandas import DataFrame, Series
import statistics
import inspect
import os
from scipy.stats import t


# In[ ]:


user = os.getlogin()   # Colocamos un el username


# In[ ]:



# Utilizamos el set directorio
os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2")


# In[ ]:


# output formato diccionario
   cps2012_env = pyreadr.read_r("data/cps2012.Rdata")


# In[ ]:


# Anterioremente, se evidencio el output de diccionario, en la cual encontramos la base de datos utilizando llaves
cps2012_env   
cps2012 = cps2012_env[ 'data' ] # se extrae información de datos 
dat = cps2012.describe()


# In[ ]:


#Creamos la lista 
lista = ['lnw','female','widowed', 'nevermarried','divorced', 'separated', 'hsd08', 'hsd911', 'hsg', 'cg', 'ad', 'mw', 'so', 'we', 'exp1', 'exp2', 'exp3', 'exp4', 'weight', 'ne', 'sc']


# In[ ]:


#Creamos la clase
class OLSRegClass(object): 
    __slots__ = [ '__X',  'Y', 'lista', 'RobustStandardError']
    def __init__(self, X:pd.DataFrame, Y:pd.Series, lista, RobustStandardError=False): 

        self.__X = X
        self.Y = Y
        self.RobustStandarError=RobustStandardError
        self.lista = lista


# In[ ]:


#Realizamos los métodos vistos: 
# 1: 

    def R2yMSE(self):

            self.Coeficientes()  # run function 

            self.SCR = sum(list( map( lambda x: x**2 , self.error)))
            self.SCT = sum(list( map( lambda x: x**2 , self.Y - np.mean(self.y_est))))
            self.rmse = (self.SCR/self.n)**0.5
            R2 = 1 - self.SCR/self.SCT


# In[ ]:



# 2     
    def Error_var_cov_intcof(self):              

            if self.RobustStandardError:

                self.y_est =  self.X1 @ self.beta
                self.error = self.Y1 - self.y_est 
                sigma =  sum(list( map( lambda x: x**2 , self.error)   )) / self.nk 
                self.Var = sigma*np.linalg.inv(self.X.T @ self.X) #caso no robusto: Matríz de varianzas y covarianzas 
                self.sd = np.sqrt( np.diag(self.Var) ) #Desviación estandar 
                self.límite_inferior = self.beta-1.96*self.sd 
                self.límite_superior = self.beta+1.96*self.sd

            else:

                self.y_est =  self.X1 @ self.beta
                self.error = self.Y1 - self.y_est
                matrix_robust = np.diag(list( map( lambda x: x**2 , self.error)))  
                self.Var = np.linalg.inv(self.X.T @ self.X) @ self.X.T @ matrix_robust @ self.X @ np.linalg.inv(self.X.T @ self.X)
                self.sd = np.sqrt( np.diag(self.Var) )
                self.límite_inferior = self.beta-1.96*self.sd
                self.límite_superior = self.beta+1.96*self.sd


# In[ ]:


#3

    def Coeficientes(self):

        self.columns = self.X.columns.tolist() # nombre de la base de datos - objeto lista
        # numero de observaciones
        self.n = self.X.shape[0] # self.n - creamos un nuevo atributo
        k = self.X.shape[1] + 1 #num de variables e intercepto
        # self.X.to_numpy() 
        self.X1 = np.column_stack((np.ones(self.n ), self.X.to_numpy() ))  # DataFrame to numpy
        self.Y1 = self.Y.to_numpy().reshape(self.n  ,1)  #reshape(-1  ,1)

        self.beta = np.linalg.inv(self.X1.T @ self.X1) @ ((self.X1.T) @ self.Y1 )
        self.nk = self.n - k 


# In[ ]:


#4

    def _Table(self, *Kargs):
        #Lista creada en pasos anteriores 
         lista = ['lnw','female','widowed', 'nevermarried','divorced', 'separated', 'hsd08', 'hsd911', 'hsg', 'cg', 'ad', 'mw', 'so', 'we', 'exp1', 'exp2', 'exp3', 'exp4', 'weight', 'ne', 'sc']
         # run functions

        self.R2()
        self.Coeficientes()
        scr = self.SCR
        sigma =  scr / self.nk
        Var = sigma*np.linalg.inv(self.X1.T @ self.X1)
        sd = np.sqrt( np.diag(Var) )
        t_est = np.absolute(self.beta/sd)
        pvalue = (1 - t.cdf(t_est, df=self.nk) ) * 2
        lower_bound = self.beta-1.96*sd
        upper_bound = self.beta+1.96*sd
        rmse = (scr/self.n)**0.5

        if (Kargs['Output'] == "DataFrame"):

               df = pd.DataFrame( {"OLS": self.beta.flatten() , "standar_error" : sd.flatten(),"Pvalue" : pvalue.flatten() , "Lower_bound":lower_bound.flatten() ,
               "Upper_bound":upper_bound.flatten() , "Root_MSE":rmse.flatten() , "R2": self.R2.flatten()})

         #self.beta.flatten() 
        # multy-array a simple array 

        elif (Kargs['Output'] == "Diccionario"):

               df ={"OLS": self.beta.flatten() , "standar_error" : sd.flatten(),"Pvalue" : pvalue.flatten() , "Lower_bound":lower_bound.flatten() ,
               "Upper_bound":upper_bound.flatten() , "Root_MSE":rmse.flatten() , "R2": self.R2.flatten()}


        return df

variance_cols = cps2012.var().to_numpy()
Dataset = cps2012.iloc[ : ,  np.where( variance_cols != 0   )[0] ]    
X = Dataset.iloc[:,1:10]
Y = Dataset[['lnw']]   
OLSRegClass(X, Y,lista,RobustStandardError=True)


# In[ ]:




