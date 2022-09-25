# -*- coding: utf-8 -*-
"""
Created on Fri Sep 23 17:53:59 2022

@author: Usuario
"""

import numpy as np
import pandas as pd
from pandas import DataFrame, Series
import statistics
import inspect 
from scipy.stats import t # t - student 
import os
import pyreadr

user = os.getlogin()   # Username
print(user)

# Extraemos los datos del directorio

os.chdir(f"C:/Users/{user}/Documentos/GitHub/1ECO35_2022_2/Lab5")
cps2012_env = pyreadr.read_r("../data/cps2012.Rdata")


#Para crear W hay que hacer algo con listas
W = ['lnw','female','widowed', 'divorced', 'separated', 'nevermarried', 'hsd08', 'hsd911', 'hsg', 'cg', 'ad', 'mw', 'so', 'we', 'exp1', 'exp2', 'exp3', 'exp4', 'weight', 'ne', 'sc']
#W = [1.2.3]

class OLS(object):
    
    def __init__(self, X:pd.DataFrame ,Y:pd.Series , W, robust_sd=False):
        
        self.X = X
        self.Y = Y
        self.robust_sd = robust_sd
        self.W = W
    
        #Método 1
    def Determinarcoeficientes(self): #Método 1
        
        self.columns = self.X.columns.tolist() # nombre de la base de datos como objeto lista
        
        self.n = self.X.shape[0] # numero de observaciones, # self.n "Se crea un nuevo atributo"
        k = self.X.shape[1] + 1 #numero de variables y el intercepto
        self.X1 = np.column_stack((np.ones(self.n ), self.X.to_numpy() ))  # self.X.to_numpy()  # DataFrame to numpy
        self.Y1 = self.Y.to_numpy().reshape(self.n  ,1)  #reshape(-1  ,1)
        
        self.beta = np.linalg.inv(self.X1.T @ self.X1) @ ((self.X1.T) @ self.Y1 )
        self.nk = self.n - k 
        
        #Método 2
    def Errorvarcovintcof(self):              
        
        if self.robust_sd:
            
            self.y_est =  self.X1 @ self.beta
            self.error = self.Y1 - self.y_est 
            sigma_1 =  sum(list( map( lambda x: x**2 , self.error)   )) / self.nk 
            self.Var = sigma_1*np.linalg.inv(self.X.T @ self.X) #Matríz de varianzas y covarianzas caso no robusto
            self.sd = np.sqrt( np.diag(self.Var) ) #Desviación estandar o errores estandar
            self.límite_inferior = self.beta-1.96*self.sd 
            self.límite_superior = self.beta+1.96*self.sd
        
            #Método 3
        else:
            
            self.y_est =  self.X1 @ self.beta
            self.error = self.Y1 - self.y_est
            matrix_robust = np.diag(list( map( lambda x: x**2 , self.error)))  
            self.Var = np.linalg.inv(self.X.T @ self.X) @ self.X.T @ matrix_robust @ self.X @ np.linalg.inv(self.X.T @ self.X)
            self.sd = np.sqrt( np.diag(self.Var) )
            
            self.límite_inferior = self.beta-1.96*self.sd
            self.límite_superior = self.beta+1.96*self.sd

        #Método 4
    def R2yMSE(self):
        
        self.Determinarcoeficientes()  # run function
        self.Errorvarcovintcof()
        
        #SCR = sum(list( map( lambda x: x**2 , self.error)))
        #SCT = sum(list( map( lambda x: x**2 , self.Y - np.mean(self.y_est))))
        #R2 = 1 - self.SCR/self.SCT

        #y_est =  self.y_est
        #error = self.error
        self.SCR = np.sum(np.square(self.error))
        self.rmse = (self.SCR/self.n)**0.5
        SCT = np.sum(np.square(self.Y1 - np.mean(self.Y1))) 

        self.R2 = 1 - self.SCR/SCT

        return self.R2           

        #Método 5
    def Table(self, **Kargs):
        
        W = ['lnw','female','widowed', 'divorced', 'separated', 'nevermarried', 'hsd08', 'hsd911', 'hsg', 'cg', 'ad', 'mw', 'so', 'we', 'exp1', 'exp2', 'exp3', 'exp4', 'weight', 'ne', 'sc']
        # Lo agregamos, pero no lo usamos. Lo lamento Roberto, se nos acababa el tiempo. 
        
        self.R2yMSE()
        self.Determinarcoeficientes()
        r2= self.R2
        scr = self.SCR
        sigma =  scr / self.nk
        Var = self.Var #sigma*np.linalg.inv(self.X1.T @ self.X1)
        sd = self.sd #np.sqrt( np.diag(Var) )
        lower_bound = self.límite_inferior
        upper_bound = self.límite_superior
        rmse = self.rmse #(scr/self.n)**0.5
    
        if (Kargs['Output'] == "DataFrame"):

               df = pd.DataFrame( {"OLS": self.beta.flatten() , "standar_error": sd.flatten() , "Lower_bound": lower_bound.flatten() , "Upper_bound": upper_bound.flatten() }) 
    
           #self.beta.flatten() # multy-array a simple array 
            
        elif (Kargs['Output'] == "Diccionario"):

            df = pd.DataFrame({"OLS": self.beta.flatten() , "standar_error": sd.flatten() , "Lower_bound": lower_bound.flatten() , "Upper_bound":upper_bound.flatten() }) 
            
            df_1 = { "Root_MSE":rmse.flatten() } #R2"R2": R2.flatten()
            
            df_2 = { "R2": r2.flatten() } 

        return df

cps2012_env  # es un diccionario. En la llave "data" está la base de datos 
cps2012 = cps2012_env[ 'data' ] # extrae información almacenada en la llave data del diccionario cps2012_env
dt = cps2012.describe()
cps2012.shape

variance_cols = cps2012.var().to_numpy() # to numpy

Dataset = cps2012.iloc[ : ,  np.where( variance_cols != 0   )[0] ]

X = Dataset.iloc[:,1:10]
Y = Dataset[['lnw']]

Reg1 = OLS(X,Y, W, robust_sd=True)

#Comprobaciones
Reg1.Determinarcoeficientes()
Reg1.X 
Reg1.beta

Reg1.Errorvarcovintcof()
Reg1.error
Reg1.Var
Reg1.límite_inferior
Reg1.límite_superior

Reg1.R2yMSE()
Reg1.rmse

Reg1.Table(Output = "Diccionario")
