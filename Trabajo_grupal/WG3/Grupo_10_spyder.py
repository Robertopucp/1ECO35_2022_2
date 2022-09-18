# -*- coding: utf-8 -*-
"""
Created on Sat Sep 17 16:46:11 2022

@author: User
"""
import numpy as np
import pandas as pd
from pandas import DataFrame, Series
import statistics
import inspect  # Permite conocer los argumentos de una función , classes, etc.
from random import *

#-------------------------------------------------------------------------
#                            Pregunta 2
#-------------------------------------------------------------------------


# Creamos un vector "a" con 100 observaciones
#--------------------------------------------
vector = np.arange(100)

#Reescalamos el vector con la funcion dada
#----------------------------------------
# 1era forma
def rescale(x):
    
    out = (x - min(x))/(max(x)-min(x))
    
    return out 

list( map( lambda x: rescale(x) , vector) )  

# 2da forma
def rescale(x,max,min):
    
    out = (x - min(x))/(max(x)-min(x))
    
    return out 

map( lambda x, v1 = max(vector), v2 = min(vector): rescale(X,v1, v2) , vector)

list( map( lambda x, v1 = max(vector), v2 = min(vector): rescale(x,v1, v2) , vector)  )  


vector1 = (vector - min(vector))/(max(vector)-min(vector))

# Creamos una matriz de 100x50
#------------------------------
np.random.seed(15632)
X1 = np.random.rand(100)
print(X1) 
X2 = np.random.rand(100) 
X3 = np.random.rand(100) 
X4 = np.random.rand(100) 
X5 = np.random.rand(100) 
X6 = np.random.rand(100) 
X7 = np.random.rand(100) 
X8 = np.random.rand(100) 
X9 = np.random.rand(100) 
X10 = np.random.rand(100) 
X11 = np.random.rand(100) 
X12 = np.random.rand(100) 
X13 = np.random.rand(100) 
X14 = np.random.rand(100) 
X15 = np.random.rand(100) 
X16 = np.random.rand(100) 
X17 = np.random.rand(100) 
X18 = np.random.rand(100) 
X19 = np.random.rand(100) 
X20 = np.random.rand(100) 
X21 = np.random.rand(100) 
X22 = np.random.rand(100) 
X23 = np.random.rand(100) 
X24 = np.random.rand(100) 
X25 = np.random.rand(100) 
X26 = np.random.rand(100) 
X27 = np.random.rand(100) 
X28 = np.random.rand(100) 
X29 = np.random.rand(100) 
X30 = np.random.rand(100) 
X31 = np.random.rand(100) 
X32 = np.random.rand(100) 
X33 = np.random.rand(100) 
X34 = np.random.rand(100) 
X35 = np.random.rand(100) 
X36 = np.random.rand(100) 
X37 = np.random.rand(100) 
X38 = np.random.rand(100) 
X39 = np.random.rand(100) 
X40 = np.random.rand(100) 
X41 = np.random.rand(100) 
X42 = np.random.rand(100) 
X43 = np.random.rand(100) 
X44 = np.random.rand(100) 
X45 = np.random.rand(100) 
X46 = np.random.rand(100) 
X47 = np.random.rand(100) 
X48 = np.random.rand(100) 
X49 = np.random.rand(100) 
X50 = np.random.rand(100) 



X = np.column_stack((np.ones(100),X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,X20,X21,X22,X23,X24,X25,X26,X27,X28,X29,X30,X31,X32,X33,X34,X35,X36,X37,X38,X39,X40,X41,X42,X43,X44,X45,X46,X47,X48,X49,X50))
print (X)

#Reescalamos la matriz con la funcion dada
#----------------------------------------
X_res = np.apply_along_axis(lambda X: (X - min(X))/(max(X)-min(X)),0, X)
print (X_res)


#-------------------------------------------------------------------------
#                            Pregunta 3
#-------------------------------------------------------------------------

#args
#------

#Reescalamos el vector con la funcion dada

# 1era forma
def rescalev( *args ):
    
    minimo = np.min(vector)
    
    maximo = np.max(vector)
    
    result = list( map( lambda x: (x-min(x))/(max(x)-min(x)) , vector)   ) 
    
    return result


rescalev(vector)

# Estandarizamos el vector

def standarizev( *args ):
    
    mean = np.mean(vector)
    
    std = np.std(vector)
    
    result = list( map( lambda x: (x- np.mean(x))/np.std(x) , vector)   ) 
 
    
    return result


standarizev(vector)


#kwargs
#------

def calculator( *list_vars, **kwargs):
    if ( kwargs[ 'function' ] == "reescale" ) :
        
        # Get the first value
        result = np.apply_along_axis(lambda X: (X - min(X))/(max(X)-min(X)),0, X)
    
    elif ( kwargs[ 'function' ] == "standarize" ) :

        result = np.apply_along_axis(lambda x: (x-x.mean())/x.std(),0, X)
    else:
        raise ValueError( f"The function argument {kwargs[ 'function' ]} is not supported." )
        
        # Mensaje de error por tipo de argumento

    return result

calculator( X, function = "reescale" )
calculator( X, function = "standarize" )


