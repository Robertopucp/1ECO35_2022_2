#!/usr/bin/env python
# coding: utf-8

# In[1]:


# En caso el lector no cuente con el pyreadr, puedes instalarlo de la siguiente manera


# In[2]:


pip install pyreadr


# In[8]:


#Antes de empezar, tenemos que primero importar las librerias de las cuales haremos uso, entre ellas están pandas, os, pyreadr , scipy.stats y numpy 


# In[9]:


import numpy as np
import os 
import pyreadr 
import pandas as pd
import scipy.stats as stats
from scipy.stats import t 


# In[15]:


class OLS_Grupo3 (object)


# In[11]:


def __init__( self, X:pd.Dataframe, y:pd.Series, lista, RobustStandardError = True):


# In[ ]:


#Si en caso nos sale error, utilizamos los siguientes códigos:


# In[ ]:


if not isinstance( X, pd.Dataframe ) :
            raise TypeError ( 'X debería ser un pd.Dataframe')

if not isinstance( y, pd.Series ) :
            raise TypeError('y debería ser una pd.Series')


# **Entonces, para privatizar los atributos, le anteponemos un guión al self.X:**

# In[ ]:


self._X = X.loc[:, lista]

self._X = X.iloc[:, lista]
self.y = y
       
self.RobustStandardError = RobustStandardError

self._X[ 'intercepto' ] = 1

cols = self._X.columns.tolist()
        
new_cols_orders = [cols[ -1 ]] + cols[ 0:-1]


# In[ ]:


#Se hace uso de .loc para poder filtrar por nombres: 

self._X = self._X.loc[ :, new_cols_orders ]
        
#Creación de nuevos atributos:

#Si queremos pasar de un dataframe a un multi array, usamos:

self._X_np = self._X.values

#Si queremos pasar de un objeto serie a un array, usamos:
        
self.y_np = y.values.reshape( -1 , 1 )

#Posteriormente, usamos:
        
self.columns = self._X.columns.tolist()

self.n = self._X.shape[0]

k = self._X.shape[1] 

self.nk = self.n - k 


# **Empezamos a privatizar los métodos:**

# In[17]:


#Método 1: Un método debe estimar los coeficientes de la regresión
    
def OLS_BETA_Grupo3( self ):
    
X_np = self._X_np
y_np = self.y_np
        
beta_ols = np.Linalg.inv( X_np.T @ X_np ) @ ( X_np.T @ y_np )

index_names = self.columns

beta_OLS_output = pd.DataFrame( beta_ols, index = index_names, columns = [ 'Coef.'] )

self.beta_OLS - beta_OLS_output
        
return beta_OLS_output


# In[ ]:


#Método 3: Un método que halle la matriz de varianza y covarianza robusta, los errores estándar de cada coeficiente, e intervalos de confianza.

def M_ROBUST_COV(self):
    
self.beta_OLS_Grupo3()

#Haremos uso de atributos que ya se han mencionado anteriormente:

X_np = self._X_np
y_np = self.y_np

#El cálculo de la varianza robusta es el siguiente: 

self.y_est = X_np @ self.beta_OLS

matrix_robust = np.diag(list( map( lambda x: x**2 , y_np - self.y_est)))
 
self.robust_var = np.linalg.inv(X_np.T @ X) @ X_np.T @ matrix_robust @ X_np @ np.linalg.inv(X_np.T @ X_np)


# In[ ]:


#Método 4: Un método que halle el R2, root MSE (mean square error)

#Los pasos para hallar el R2 son los siguientes: 

def R2(self):

self.coeficientes()              
y_est =  self.X1 @ self.beta
error = self.Y1 - y_est
self.SCR = np.sum(np.square(error))
SCT = np.sum(np.square(self.Y1 - np.mean(self.Y1))) 
R2 = 1 - self.SCR/SCT

return R2

#Los pasos para hallar el root MSE son los siguientes:

#Hay un paquete que nos permite encontrar el root MSE, por tanto, hacemos uso de él de la siguiente forma:

from sklearn.metrics import mean_squared_error

def rootMSE(true,predicted):
        
rootMSE = mean_squared_error(true,predicted, squared=False)
        
return rootMSE


# **Para terminar de privatizar un método, se tiene que hacer uso de la instancia _slot_**

# In[18]:


class RegClass: Ols_Grupo3

# A continuación colocamos la instancia __slot__ con todos los atributos que hemos creado para nuestra clase 

    __slots__ = [ '__X',  'y',  'intercept', 'X_np',  'y_np',  'columns',   'beta_OLS']  
    
    def __init__( self, X : pd.DataFrame , y : pd.Series , intercept = True  ):

    self.__X = X
     self.y = y
     self.intercetp = intercet

