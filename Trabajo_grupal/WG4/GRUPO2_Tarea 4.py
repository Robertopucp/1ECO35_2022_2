# -*- coding: utf-8 -*-
"""
Ejercicio Número 4 (WG4)

@author: Grupo 2
"""


import numpy as np
import pandas as pd
from pandas import DataFrame, Series
import statistics
import inspect  # Permite conocer los argumentos de una función , classes, etc 
import pyreadr  # Load R dataset
import os # for usernanme y set direcotrio
from scipy.stats import t # t - student 

user = os.getlogin()   # Username

# Set directorio

os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2/Lab4") # Fijar directorio

cps2012_env = pyreadr.read_r("../data/cps2012.Rdata") # output formato diccionario


cps2012_env  # es un diccionario. En la llave "data" está la base de datos 
cps2012 = cps2012_env[ 'data' ] # extrae información almacenada en la llave data del diccionario cps2012_env
dt = cps2012.describe()
 

"""
1- Un método debe estimar los coeficientes de la regresión
2- Un método que permita hallar la matriz de varianza y covarianza estándar, los errores estándar de cada coeficiente, e intervalos de confianza.
3- Un método que halle la matriz de varianza y covarianza robusta, los errores estándar de cada coeficiente, e intervalos de confianza.
4- Un método que halle el R2, root MSE (mean square error)
5- Finalmente un método que muestre los siguientes resultados en un objeto diccionario:

coeficientes estimados, errores estándar e intervalos de confianza en un Dataframe
R2
root-MSE
"""




#creamos la clase

class OLS_Tarea(object): 
    def __init__(self, X:pd.DataFrame, Y:pd.Series, List, robustse = True): 

        self.X = X.loc[:, List]  #asigno mi atributo X
        self.Y = Y                #asigno mi atributo y   
        self.robustse = robustse #asigno mi atributo robustse
        
        #Incluye una columna de unos en nuestra dataframe X
        self.X['Intercept'] = 1
        
        #para que la columna intercept aparezca en la primera columna:
        cOLS = self.X.columns.tolist() #esto convierte el nombre de las columnas a lista
        new_cOLS_orders = [cOLS[-1]] + cOLS[0:-1] #esto mueve la última columna(intercept) al inicio, para ello se ordena primero col[-1] y luego col[0:-1]
        
        #usamos .loc para filtrar por nombre de filas o columnas
        self.X = self.X.loc[ :, new_cOLS_orders]
        
        #Creamos nuevos atributos:
        #para pasar de dataframe a multi array:
        self.X_np = self.X.values
        #para pasar de objeto serie a array columna:
        self.Y_np = Y.values.reshape(-1,1)
        #nombramos a la base de datos como objeto lista:
        self.columns = self.X.columns.tolist()
        self.n = self.X.shape[0] 
        k = self.X.shape[1]
        self.nk = self.n - k 

    #1- Un método debe estimar los coeficientes de la regresión
    
    def coeficientes(self):
        
       #número de observaciones         
        X1 = self.X_np #matriz de Xs incluyendo intercepto
        Y1 = self.Y_np
        beta = np.linalg.inv(X1.T @ X1) @ ((X1.T) @ Y1 )
        
        index_names = self.columns
       # Output
        beta_OLS_output = pd.DataFrame( beta , index = index_names , columns = [ 'Coef.' ] )
       
       # Dataframe de coeficientes como atributo 
       
        self.beta_OLS = beta_OLS_output
       
        return beta_OLS_output

    #2- Un método que permita hallar la matriz de varianza y covarianza estándar, los errores estándar de cada coeficiente, e intervalos de confianza.
    
    def metodo2(self):
    
        
        #corremos la función anterior de coeficientes
        self.coeficientes()
        
        X_np = self.X_np
        Y_np = self.Y_np
        
        #Beta_OLS
        beta_OLS = self.beta_OLS.values.reshape( -1, 1) #Pasamos de dataframe a un vector columna
        
        #hallamos los errores
        e= Y_np - (X_np @ beta_OLS)
        
        
        N= X_np.shape [0]
        parametros_totales = X_np.shape [1]
        error_var = ( (e.T @ e)[0])/(N- parametros_totales)
        
        #Hallamos la Varianza estandar
        var_OLS = error_var * np.linalg.inv( X_np.T @ X_np)
        
        #Sacamos el nombre de las columnas y asignamos un output que tenga la varianza 
        index_names = self.columns
        var_OLS_output = pd.DataFrame(var_OLS, index=index_names, columns=index_names)
        self.var_OLS = var_OLS_output
        
        ########Hallamos errores estandar
        
        #Hallamos beta y var
        beta_OLS= self.beta_OLS.values.reshape (-1,1)
        var_OLS= self.var_OLS.values
        
        #errores estandar
        beta_errores= np.sqrt(np.diag(var_OLS))
        tabla_data_1= { "Std.Err.": beta_errores.ravel()}
        
        #definimos el nombre del indice
        index_names0=self.columns
        
        #definimos un pandas dataframe
        self.beta_se= pd.DataFrame(tabla_data_1, index= index_names0)
        
        ####Hallamos intervalos de confianza
        
        self.up_bd = beta_OLS.ravel() + 1.96*beta_errores
        self.lw_bd = beta_OLS.ravel() - 1.96*beta_errores

        tabla_data_2 ={"[0.025"   : self.lw_bd.ravel(),
                       "0.975]"   : self.up_bd.ravel()
                     }
        
        #definimos el nombre del indice
        index_names1 = self.columns 
        
        # defining un pandas dataframe 
        self.intervalo_confianza= pd.DataFrame(tabla_data_2, index = index_names1)
        

    #Un método que halle la matriz de varianza y covarianza robusta, los errores estándar de cada coeficiente, e intervalos de confianza.
    def metodo_robust(self):
        
        # Corremos nuestra función de coeficientes
        self.coeficientes()
        
        #Asignamos atributos
        X_np = self. X_np
        Y_np= self.Y_np
        
        #Hallamos nuestras varianzas robustas
        #con nuestra matriz propuesta de White 
        
        y_est= X_np @ self.beta_OLS
        
        matrix_robusta = np.diag(list ( map( lambda x: x**2, Y_np - y_est.values )))
        self.varianza_robusta= np.linalg.inv(X_np.T @ X_np) @ X_np.T @ matrix_robusta @ X_np @ np.linalg.inv(X_np.T @ X_np)


    #Un método que halle el R2, root MSE (mean square error)
    def R2_rMSE( self ) :
        
        # Se corre la función beta OLS Reg 
        self.coeficientes()  # run function 
        y_est =  self.X_np @ self.beta_OLS
        error = self.Y_np - y_est
        self.SCR = np.sum(np.square(error))
        SCT = np.sum(np.square(self.Y_np - np.mean(self.Y_np))) 
        self.rootMSE = np.sqrt(SCT/self.n)
        self.R2 = 1 - self.SCR/SCT       


    #Finalmente un método que muestre los siguientes resultados en un objeto diccionario:
    #coeficientes estimados, errores estándar e intervalos de confianza en un Dataframe
    #R2
    #root-MSE
    
    def Table(self):
        #run functions
        self.R2_rMSE()
        self.R2
        self.coeficientes()
        self.up_bd   #Intervalo de confianza
        self.lw_bd   #Intervalo de confianza
        
        scr= self.SCR
        sigma= scr/ self.nk
        Var = sigma*np.linalg.inv(self.X_np.T @ self.X_np)
        sd = np.sqrt( np.diag(Var))
        t_est = np.absolute(self.beta_OLS/sd)
        pvalue = (1 - t.cdf(t_est, df=self.nk)) * 2
        
        df = {"OLS": self.beta_OLS.flatten() , "standar_error" : sd.flatten(), "IC_up_bd": self.up_bd.flatten(),"IC_lw_bd": self.lw_bd.flatten(), "R2": self.R2.flatten() , "RootMSE": self.rootMSE.flatten()}
    
        return df    
    
#APLICACION DE LA CLASE EN NUESTRA DATA. 
#COMO GRUPO APLICAMOS LOS METODOS; SIN EMBARGO TUVIMOS INCONVENIENTES PARA QUE
#LOS METODOS 3 Y 5 CORRAN.


cps2012.shape
variance_cols = cps2012.var().to_numpy() #saca la varianza de cada vector y lu vuelve array

Dataset = cps2012.iloc[ : ,  np.where( variance_cols != 0   )[0] ] #filtrame aquellas columnas que no tengan varianza (observaciones iguales)

X = Dataset.iloc[:,1:10]
Y = Dataset[['lnw']]

L1 = ['female','divorced','separated']


Reg1 = OLS_Tarea(X,Y,L1, robustse = True)

#aplicamos el metodo 1 y estimamos los betas 
Reg1.coeficientes()

# aplicamos el metodo 2
Reg1.metodo2() 
print('Betas')
print(Reg1.beta_OLS)
print('Variannza_OLS')
print(Reg1.var_OLS)
print('Intervalo_confianza')
print(Reg1.intervalo_confianza)
#aplicamos metodo 4 y hallamos los R
Reg1.R2_rMSE()
print('rootMSE')
print(Reg1.rootMSE)
print('R2')
print(Reg1.R2)

