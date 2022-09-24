# -*- coding: utf-8 -*-
"""

@author: grupo 8

"""

import numpy as np
import pandas as pd
import os
import scipy.stats as stats
from scipy.stats import t
 
        
import pyreadr  # Load R dataset
import os # for usernanme y set directorio

user = os.getlogin()   # Username

# Set directorio

os.chdir(f"C:/Users/{user}/Documents/GitHub/1ECO35_2022_2") # Set directorio

cps2012_env = pyreadr.read_r("data/cps2012.Rdata") # output formato diccionario


cps2012_env  # es un diccionario. En la llave "data" está la base de datos 
cps2012 = cps2012_env[ 'data' ] # extrae información almacenada en la llave data del diccionario cps2012_env
dt = cps2012.describe()


#Creamos la clase

class OLSRegClass(object): 
    def __init__(self, x:pd.DataFrame, y:pd.Series, lista, RobustStandardError=True): 
#x:pd.DataFrame nos indica que debe ser un DataFrame
#y:pd.Series nos indica que debe ser una serie
        #Condicional para el x:pd.DataFrame
        if not isinstance(x, pd.DataFrame):
            raise TypeError("x debe ser pd.DataFrame.")
        
        #Condicional para el y:pd.Series
        if not isinstance(y, pd.Series):
            raise TypeError("y debe ser pd.Series.")
            
        #Condicional para el y:pd.Series
        if not isinstance(lista, pd.Series):
            raise TypeError("lista debe ser pd.Series")
            
        #Ahora asignamos atributos de la clase
        try:
            self.x = x.loc[:, lista]
        except:
            self.x = x.iloc[:, lista]
            
        self.y = y
        self.RobustStandardError = RobustStandardError
        
        #Ahora incluimos una columna de unos para el intercepto
        self.x['Intercept'] = 1
        
        #para que la columna intercept aparezca en la primera columna:
        col = self.x.columns.tolist() #esto convierte el nombre de las columnas a lista
        new_col_orders = [col[-1]] + col[0:-1] #esto mueve la última columna(intercept) al inicio, para ello se ordena primero col[-1] y luego col[0:-1]
        
        #usamos .loc para filtrar por nombre de filas o columnas
        self.x = self.x.loc[ :, new_col_orders]
        
        #Creamos nuevos atributos:
        #para pasar de dataframe a multi array:
        self.x_np = self.x.values
        #para pasar de objeto serie a array columna:
        self.y_np = y.values.reshape(-1,1)
        #nombramos a la base de datos como objeto lista:
        self.columns = self.x.columns.tolist()
    
    #METODO 1
    
    def beta_OLS_Reg(self):
        x_np = self.x_np
        y_np = self.y_np
        
        beta_ols = np.linalg.inv(x_np.T@x_np) @ (x_np.T@y_np)
        
        #Hay que asignar al output de la función def beta_OLS(self): como atributo self.beta_Ols
        index_names = self.columns
        beta_OLS_output = pd.DataFrame(beta_ols, index = index_names, columns = ['Coef.'])
        self.beta_OLS = beta_OLS_output
        
        return beta_OLS_output
 

    #METODO 2
    
    def var_errorest_interv(self):
        
        ####Matriz de varianza y covarianza estándar####
        
        #corremos la función beta_OLS 
        self.beta_OLS_Reg()
        
        X_np = self.X_np
        y_np = self.y_np
        
        #Beta_OLS
        beta_OLS = self.beta_OLS.values.reshape( -1, 1) #Pasamos de dataframe a un vector columna
        
        #errores
        e= y_np - (X_np @ beta_OLS)
        
        #
        N= X_np.shape [0]
        parametros_totales = X_np.shape [1]
        error_var = ( (e.T @ e)[0])/(N- parametros_totales)
        
        #Varianza estandar
        var_OLS = error_var * np.linalg.inv( X_np.T @ X_np)
        
        #asignaremos output 
        index_names = self.columns
        var_OLS_output = pd.DataFrame(var_OLS, index=index_names, columns=index_names)
        self.var_OLS = var_OLS_output
        
        ####ERRORES ESTANDAR####
        
        #beta y var
        beta_OLS= self.beta_OLS.values.reshape (-1,1)
        var_OLS= self.var_OLS.values
        
        #errores estandar
        beta_errores= np.sqrt(np.diag(var_OLS))
        tabla_data_1= { "Std.Err.": beta_errores.ravel()}
        
        #definimos index names
        index_names0=self.columns
        
        #definimos un pandas dataframe
        self.beta_se= pd.DataFrame(tabla_data_1, index= index_names0)
        
        ####INTERVALOS DE CONFIANZA####
        
        up_bd = beta_OLS.ravel() + 1.96*beta_errores
        lw_bd = beta_OLS.ravel() - 1.96*beta_errores

        tabla_data_2 ={"[0.025"   : lw_bd.ravel(),
                       "0.975]"   : up_bd.ravel()
                     }
        
        # definiendo index names
        index_names1 = self.columns 
        
        # defining a pandas dataframe 
        self.intervalo_confianza= pd.DataFrame(tabla_data_2, index = index_names1)
        

    #METODO 3
    def robust_var_se_cfdinterval(self):
        
        # Función beta OLS para estimar el vector de coeficientes
        self.beta_OLS_Reg()
        
        #atributos
        X_np = self. X_np
        Y_np= self.Y_np
        
        ####VAR ROBUSTA####
        #matriz propuesta de White 
        
        y_est= X_np @ self.beta_OLS
        
        matrix_robusta = np.diag(list ( map( lambda x: x**2, Y_np - y_est.values )))
        self.varianza_robusta= np.linalg.inv(X_np.T @ X_np) @ X_np.T @ matrix_robusta @ X_np @ np.linalg.inv(X_np.T @ X_np)



    #METODO 4
    def R2_raizMSE( self ) :
        
        # Se corre la función beta OLS Reg 
        self. beta_OLS_Reg()

        self.y_est = self.X_np @ self.beta_OLS
        error = self.y_np - self.y_est
        self.SCR = np. sum(np.square (error))
        SCT= np. sum(np.square (self.y_np - np.mean (self.y_est) ))

        self.R2 = 1 - self.SCR/SCT

        for i in error. values:
            suma = 0
            suma = np.sqrt( suma + (i**2) / self. X_np. shape [0] )
        
        self.rootMSE = suma. tolist()

        

    #metodo 5###########
    def output(self):
        self.beta_OLS_Reg()
        self.R2_raizMSE()
        self.var_errorest_interv()
    
        #var y beta
        beta_OLS = self.beta_OLS.values.reshape(-1,1)
        var_OLS = self.var_OLS.values
    
        #Errores estandar
        beta_errores = np.sqrt(np.diag(var_OLS))
    
        #Intervalo de confianza
        up_bd = beta_OLS.ravel() + 1.96*beta_errores
        lw_bd = beta_OLS.ravel() - 1.96*beta_errores
    
        tabla_data_3 = {'Coeficientes': beta_OLS.ravel(),
                   'Error estandar' :beta_errores.ravel(),
                   '[0.025': lw_bd.ravel(),
                   '0.975]': up_bd.ravel(),
                   'R2': self.R2,
                   'rootMSE' : self.rootMSE}
    
        return tabla_data_3
    