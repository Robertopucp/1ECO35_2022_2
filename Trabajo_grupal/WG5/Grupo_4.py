
###############################################################################
#                                                                             #
#            TAREA 5: Privatización de atributo y método                      #
#                                                                             #
###############################################################################

#Empezamos por importar las librerías usadas para el ejercicio del WG4

import numpy as np
import pandas as pd
from pandas import DataFrame, Series
import statistics
import inspect

#Para poder usar la base de datos de R y configurar el username usamos lo siguiente

import pyreadr  
import os 

#%% PREGUNTA 1


#### Para esta pregunta usaremos la base de la clase creada para el WG 4, pero privatizando los atributos

#Primero setteamos el directorio

user = os.getlogin()   # Username


os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Lab4") 

cps2012_env = pyreadr.read_r("../data/cps2012.Rdata") 

#Tenemos un dicionario del que extraeremos los datos de la llave data

cps2012_env  
cps2012 = cps2012_env[ 'data' ] 
dt = cps2012.describe()

# Creamos la clase

'''''''''
OLS class
'''''''''

####Privatizamos el atributo "x" de la clase, usando "__"

class OLS_G4:
    
    
    def __init__(self, X,Y,W,Z):
        
        self.__X = X
        self.Y = Y
        self.W = W
        self.Z = Z
    
        
    def coeficientes(self):
        
        self.n = self.__X.shape[0] # numero de observaciones, # self.n "Se crea un nuevo atributo"
        k = self.__X.shape[1]
        X1 = np.column_stack((np.ones(self.n ), self.__X.to_numpy() )) # DataFrame to numpy
        Y1 = self.Y.to_numpy().reshape(self.n  ,1)  #reshape(-1  ,1)
        self.X1 = X1
        self.Y1 = Y1
        self.beta = np.linalg.inv(X1.T @ X1) @ ((X1.T) @ Y1 )
        self.nk = self.n - k 
        self.Y_est =  self.X1 @ self.beta
       
         
    
    def estándar(self):
    
        self.coeficientes()
        
        y_est =  self.X1 @ self.beta
        sigma =  sum(list( map( lambda x: x**2 , self.Y1 - y_est)   )) / self.nk 
        Var1 = sigma*np.linalg.inv(self.X1.T @ self.X1)
        self.Var1=Var1
        self.sd1 = np.sqrt( np.diag(Var1) )
        self.lower_bound1 = self.beta-1.96*self.sd1
        self.upper_bound1 = self.beta+1.96*self.sd1
        
    def robust(self):
    
        self.coeficientes()
        
        y_est =  self.X1 @ self.beta
        matrix_robust = np.diag(list( map( lambda x: x**2 , self.Y1 - y_est)))
        Var2 = np.linalg.inv(self.X1.T @ self.X1) @ self.X1.T @ matrix_robust @ self.X1 @ np.linalg.inv(self.X1.T @ self.X1)
        self.Var2=Var2
        sd2 = np.sqrt( np.diag(Var2) )
        self.sd2=sd2
        lower_bound2 = self.beta-1.96*sd2
        upper_bound2 = self.beta+1.96*sd2
        
    def R2_RMSE(self):
            
         self.coeficientes() # run function 
         
         y_est =  self.X1 @ self.beta
         error = self.Y1 - y_est
         self.SCR = np.sum(np.square(error))
         SCT = np.sum(np.square(self.Y1 - np.mean(self.Y1))) 
         self.R2 = 1 - self.SCR/SCT
         self.rmse = (self.SCR/self.n)**0.5
         
         
        
####Privatizamos el método que da como output un objeto diccionario usando "__" antes del nombre del método
# NOTA: No se uso __slots__ ya que generaba errores con el código y bastó agregar "__" al nombre del método para privatizarlo, lo cual se demuestra en la línea 208

    def __Table(self,**Kargs):
        
        self.R2_RMSE()
        self.robust
        self.estándar()
        self.coeficientes()
        scr = self.SCR
        sigma =  scr / self.nk
        Var = sigma*np.linalg.inv(self.X1.T @ self.X1)
        sd = np.sqrt( np.diag(Var) )
        t_est = np.absolute(self.beta/sd)
        
        if (Kargs['Output'] == "DataFrame"):
        
           df = pd.DataFrame( {"coeficientes": self.beta.flatten()  , "error-estandar" : self.sd1.flatten(), "límite-superior": self.upper_bound1.flatten(), "límite-inferior": self.lower_bound1.flatten() } )
                              
           
        elif (Kargs['Output'] == "Diccionario"):
            
           df = {"R^2": self.R2.flatten() ,"Root-MSE": self.rmse.flatten()}
           
        
        return df
                                  
            
           
            
#flatten():  De multi array a simple array 
cps2012.shape

variance_cols = cps2012.var().to_numpy() # to numpy

Dataset = cps2012.iloc[ : ,  np.where( variance_cols != 0   )[0] ]


#Definimos los atributos

X = Dataset.iloc[:,1:3]

Y = Dataset[['lnw']]

W=list(cps2012.columns)

Z=bool



Reg1 = OLS_G4(X,Y,W,Z)

#### Al correr la línea de abajo (línea 166), podemos comprobar que el atributo X está privatizado

Reg1.__X


#Obtenemos los betas

Reg1.coeficientes()
Reg1.beta

#Obtenemos la matriz de varianza y covarianza
Reg1.estándar()
Reg1.Var1

#Obtenemos los errores estándar
Reg1.estándar()
Reg1.sd1

#Obtenemos los intervalos de confianza
Reg1.estándar()
Reg1.upper_bound1
Reg1.lower_bound1


#Obtenemos el R2

Reg1.R2_RMSE()
Reg1.R2

#Obtenemos el root MSE

Reg1.R2_RMSE()
Reg1.rmse


#Obtenemos los coeficientes estimados, errores estándar e intervalos de confianza en un data frame

Reg1.__Table(Output = "DataFrame")


#Obtenemos el R2 y el root-MSE en un diccionario

#### Al correr la línea de abajo (línea 208) podemos observar que el método está privatizado

Reg1.__Table(Output = "Diccionario")



     