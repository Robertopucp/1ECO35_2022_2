#!/usr/bin/env python
# coding: utf-8

# In[4]:


import numpy as np
import pandas as pd
import scipy.stats import t
import pyreadr 
import os


# In[2]:


class REGREE_OLS ( object ) :
# también podemos omitir object. pues es lo mismo
    def __init__( self, X:pd.Dataframe, y:pd.Series, lista, RobustStandardError = True):

# INDICAMOS QUE "X" SEA UN DATA FRAME  Y "Y" UNA LISTA.

## CON LO CUAL, PROPONEMOS UN CONDICIONAL PARA AMBOS// mensaje de error porsiaca #
      
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
                             
# CONVERTIMOS LOS NOMBRES A COLUMNAS

# FILTRAMOS LOS NOMBRES

        self.X = self.X.loc[ :, new_cols_orders ]
        
        self.X_np = self.X.values
        
        self.y_np = y.values.reshape( -1 , 1 )
        
        self.columns = self.X.columns.tolist()


# In[5]:


#### METODO 1 ->  Estimar los coeficientes de la regresión ####

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


# In[6]:



#### METODO 2 -> Matriz de varianza y covarianza estándar ####

    def STDERROR_VAR_M( self ):
    
# VARIANZA:

# BUSCAMOS ESTIMAR EL ERROR

        self.beta_OLS_Reg()
        
# SHORTCUT PARA LOS X_NP
        X_np = self.X_np
        y_np = self.y_np
        
# BETA_OLS
        beta_OLS = self.beta_OLS.values.reshape( - 1, 1 )

        X_np = self.X_np
        y_np = self.y_yp

        e = y_np - ( X_np @ beta_OLS )
# PARA EL ERROR DE LA VARIANZA
        N = X_np.shape [ 0 ]
        total_parameters = X_np.shape [1 ]
        error_var = ( (e.T @ e) [0]) / (N - total_parameters) 

# PARA LA VARIANZA
        var_OLS = error_var * np.linalg.inv( X_np.T @ X_np )

# OUTPUT DE reg_var_OLS(setf): ATRIBUTO DE VAR
        index_names = self. columns
        var_OLS_output = pd.Dataframe( var_OLS, index = index_names, columns = index_names )
        self.var_OLS = var_OLS_output

#ERROR ESTANDAR: 

# VARIANZA
        beta_OLS = self.beta_OLS.values.reshape( -1, 1 )
        var_OLS = self.var_OLS.values
# ERROR ESTANDAR
        beta_stderror = np.sqrt(np.diag( var_OLS ) )
        table_data0 = { "Std.Err." : beta_stderror.ravel()}
       
        index_names0 = self.columns
                
        self.beta_se = pd.DataFrame ( table_data0, index = index_names0 )

# CONFIANZA
       
        up_bd = beta_OLS.ravel() + 1.96*beta_stderror
      
        lw_bd = beta_OLS.ravel() - 1.96*beta_stderror

        table_data1 = {"[0.025" : lw_bd.ravel(),
                       "0.975]" : up_bd.ravel() }
#SEGUN LO PROPUESTO

# NOMBRE INDEX.

        index_names1 = self.columns

# PANDA FRAME.

        self.confiden_interval = pd.Dataframe( table_data1, index = index_names1 )


# In[7]:



#### MÉTODO 3 -> Un método que halle la matriz de varianza y covarianza robusta...  ####

    def M_ROBUST_COV(self):
# ESTIMACIÓN DEL VECTOR DE COEFICIENTES.

        self.beta_OLS_Reg()
# usaré atributos pero con un nombre más simple
        X_np = self.X_np
        y_np = self.y_np

#VARIANZA ROBUSTA:

# matriz propuesta de White en muestras grandes
# V = np.zeros ((X_np.shape[1]. X_np. shape(1)))


        self.y_est = X_np @ self.beta_OLS

        matrix_robust = np.diag(list( map( lambda x: x**2 , y_np - self.y_est)))
 
        self.robust_var = np.linalg.inv(X_np.T @ X) @ X_np.T @ matrix_robust @ X_np @ np.linalg.inv(X_np.T @ X_np)


# In[8]:



#### METODO 4

# Se definirá un método que halle el R2 y MSE (mean square error)

    def R2(self):
         
         self.coeficientes()              
         y_est =  self.X1 @ self.beta
         error = self.Y1 - y_est
         self.SCR = np.sum(np.square(error))
         SCT = np.sum(np.square(self.Y1 - np.mean(self.Y1))) 
         R2 = 1 - self.SCR/SCT

         return R2

#llamamos al paquete que nos permitirá encontrar el root MSE
from sklearn.metrics import mean_squared_error

#definimos el método
def rootMSE(true,predicted):
        
        rootMSE = mean_squared_error(true,predicted, squared=False)
        
        return rootMSE


# In[15]:


#### METODO 5


# In[14]:


#VAMOS A CARGAR LA BASE DE DATOS, CON LO CUAL UTILIZAREMOS USER ///
#CON ESTO, CORRE SIN NECESIDAD DE CAMBIAR EL NOMBRE DE USUARIO :D

user = os.getlogin()
os.chdir("C:\Users\User\Documents\GitHub\1ECO35_2022_2\Lab4") 

cps2012_UNO = pyreadr.read_r("../data/cps2012.Rdata") 
cps2012 = cps2012_UNO['data']
dt = cps2012.describe

#ES NECESARIO FILTRAR LAS VARIANZAS DISTINTAS A 0
variance_cols = cps2012.var().to_numpy()
dataset = cps2012.iloc[:, np.where(variance_cols !=0 )[0]]
## aca poner un dataset específico desde el geeneral, podría ser con iloc y squeeze()


# In[ ]:




