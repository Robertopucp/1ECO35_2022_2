# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
##########################################
#			TAREA 4			# 
##########################################

# Primero es necesario que importemos las librerias para crear las clases, definir atributos y finalmente crear los modelos

import numpy as np
import pandas as pd
from pandas import DataFrame, Series
import statistics
import inspect
import pyreadr  # Cargar la base de datos de R
import os # Para identificar el directorio

# Llamamos el paquete que nos permitirá llevar a cabo la regresión lineal

from scipy.stats import t

# Comenzamos a crear la clase, en la parte de class REGREE_OLS, podemos omitir object, pues es lo mismo

class OLS    
  def __init__( self, X:pd.Dataframe, y:pd.Series, lista, RobustStandardError = True):
  def __init__(self, explicativas, vector, extraer, booleano):
        
        self.explicativas = explicativas
        self.vector = vector
        self.booleano = booleano

# INDICAMOS QUE "X" SEA UN DATA FRAME  Y "Y" UNA LISTA,  PROPONEMOS UN CONDICIONAL PARA AMBOS// mensaje de error porsiaca #
      
        if not isinstance( X, pd.Dataframe ) :
            raise TypeError ( "X debería ser un pd.Dataframe.")

        if not isinstance( y, pd.Series ) :
            raise TypeError("y debería ser una pd.Series.")

# PROPONEMOS LOS ATRIBUTOS CORRESPONDIENTES
        try:
            self.X = X.loc[:, lista]
        except:
            self.X = X.iloc[:, lista]
        self.y = y
        self.RobustStandardError = RobustStandardError

        self.X[ 'intercepto' ] = 1

        cols = self.X.columns.tolist()

        new_cols_orders = [cols[ -1 ]] + cols[ 0:-1]

# Convertimos los nombres a columnas, filtramos los nombres

        self.X1 = self.X.loc[ :, new_cols_orders ]
        self.X1_np = self.X.values
        
        self.Y_np = y.values.reshape( -1 , 1 )
        self.columns = self.X.columns.tolist()

#%% Método 1
# Se busca estimar los coeficientes de la regresión 
# Definimos la regresión 

  def REGRE_BETA_OLS( self ):

        X_np = self.X_np
        y_np = self.y_np

# beta_ols

        beta_ols = np.Linalg.inv( X_np.T @ X_np ) @ ( X_np.T @ y_np )
        
#OUTPUT

        index_names = self.columns
        beta_OLS_output = pd.DetaFrame( beta_ols, index = index_names, columns = [ 'Coef.'] )
        self.beta_OLS - beta_OLS_output
        
        return beta_OLS_output

#%% Método 2
# Se busca hallar la matriz de varianzas y covarianzas, en modo estándar: 
# Primero buscamos hallar el error estandar y la varianza a continuación
  def STDERROR_VAR_M( self ):
    
# Primero, Estimamos el error
self.beta_OLS_Reg()
        
# SHORTCUT PARA LOS X_NP
        X_np = self.X_np
        y_np = self.y_np
        
# BETA_OLS
        beta_OLS = self.beta_OLS.values.reshape( - 1, 1 )

        X_np = self.X_np
        y_np = self.y_yp

        e = y_np - ( X_np @ beta_OLS )

# Segundo, PARA EL ERROR DE LA VARIANZA
        N = X_np.shape [ 0 ]
        total_parameters = X_np.shape [1 ]
        error_var = ( (e.T @ e) [0]) / (N - total_parameters) 

# Tercero, hallamos la varianza. 
        var_OLS = error_var * np.linalg.inv( X_np.T @ X_np )

# OUTPUT DE reg_var_OLS(setf): ATRIBUTO DE VAR
        index_names = self. columns
        var_OLS_output = pd.Dataframe( var_OLS, index = index_names, columns = index_names )
        self.var_OLS = var_OLS_output

#Ahora si, podemos analizar el error estándar: 

# VARIANZA
        beta_OLS = self.beta_OLS.values.reshape( -1, 1 )
        var_OLS = self.var_OLS.values

# ERROR ESTANDAR
        beta_stderror = np.sqrt(np.diag( var_OLS ) )
        table_data0 = { "Std.Err." : beta_stderror.ravel()}
       
        index_names0 = self.columns
                
        self.beta_se = pd.DataFrame ( table_data0, index = index_names0 )

# Para analizar el intervalo de confianza hacia un 95%, se sabe que el valor es 1.96
       
        up_bd = beta_OLS.ravel() + 1.96*beta_stderror
      
        lw_bd = beta_OLS.ravel() - 1.96*beta_stderror

        table_data1 = {"[0.025" : lw_bd.ravel(),
                       "0.975]" : up_bd.ravel() }
#Por lo propuesto nos piden, primero denominaremos el index:

        index_names1 = self.columns

# Ahora tenemos un panda frame:

        self.confiden_interval = pd.Dataframe( table_data1, index = index_names1 )

#%% Método 3
# Aqui nos piden un método para hallar la matriz de varianza y covarianza robusta
def M_ROBUST_COV(self):
# ESTIMACIÓN DEL VECTOR DE COEFICIENTES.

        self.beta_OLS_Reg()

# usamos atributos pero con el nombre simplificado
        X_np = self.X_np
        y_np = self.y_np

#VARIANZA ROBUSTA:

# matriz propuesta de White para muestras grandes
# V = np.zeros ((X_np.shape[1]. X_np. shape(1)))
        self.y_est = X_np @ self.beta_OLS

        matrix_robust = np.diag(list( map( lambda x: x**2 , y_np - self.y_est)))
 
        self.robust_var = np.linalg.inv(X_np.T @ X) @ X_np.T @ matrix_robust @ X_np @ np.linalg.inv(X_np.T @ X_np)

#%% Método 4
# Se definirá el método que permita hallar la matriz de varianza y covarianza estándar, los errores estándar de cada coeficiente, e intervalos de confianza.

# Determinamos que X sea un data frame, mientras Y sea una columna, de modo que tambien se utiliza el args

  def coeficientes(self, *args):
         self.n = self.X.shape[0] # numero de observaciones, # self.n "Se crea un nuevo atributo"
         k = self.X.shape[1]
         Y = np.column_stack((np.ones(self.n ), self.Y.to_numpy() ))  # self.X.to_numpy()  # DataFrame to numpy #Se crea atributo de vector de variable Y
         X1 = self.Y.to_numpy().reshape(self.n  ,1) # Se mantiene como DataFrame. Se crea atributo de variables explicativas
         self.X = X
         self.Y = Y #Se crea el atributo para extraer el vector de la variable Y
         self.beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

         self.nk = self.n - k #Para determinar grados de libertad
# Se definirá un método que halle el R2 y root MSE (mean square error)

    def R2(self):
         
         self.coeficientes()              
         y_est =  self.X @ self.beta
         error = self.Y - y_est
         self.SCR = np.sum(np.square(error))
         SCT = np.sum(np.square(self.Y - np.mean(self.Y))) 
         R2 = 1 - self.SCR/SCT

         return R2   
# Ahora, para hallar el root MSE, primero hay que llamar al paquete que nos permitirá encontrarlo
from sklearn.metrics import mean_squared_erro
#Definimos el método

def MSE(true,predicted):
        
        MSE = mean_squared_error(true,predicted, squared=False)
        
        return MSE

#%% Método 5
# Primero se necesita cargar la base de datos, por ello utilizamos el user que se utilice sin necesidad de cambiar el usuario del computador
user = os.getlogin()
os.chdir(f"Users/{user}/Documents/GitHub/1ECO35_2022_2/Lab4")  #Tomar en cuenta que al trabajar en una Mac o sistema IOs, no se usa el C:" 

cps2012_UNO = pyreadr.read_r("../data/cps2012.Rdata") 
cps2012 = cps2012_UNO['data']
dt = cps2012.describe

#ES NECESARIO FILTRAR LAS VARIANZAS DISTINTAS A 0

variance_cols = cps2012.var().to_numpy()
dataset = cps2012.iloc[:, np.where(variance_cols !=0 )[0]]
## aca poner un dataset específico desde el general, podría ser con iloc y squeeze()

################## FIN TAREA ########################	


    
    