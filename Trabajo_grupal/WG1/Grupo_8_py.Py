#%% Pregunta 1

#Creamos un vector cuyos datos estén entre 0 y 500 y contenga 20 datos.

import random
import numpy as np
import math

x = np.random.randint(0, 500, 20)

# Elaboramos una estructura If statement para la siguiente función
# y aplicamos condición a cada uno de los elementos

def calculator(x):
    x = x
    
    if 0<=x<100:
       return f"F(X)= {x **(1/2)}"
    elif 100<=x<300:
       return f"F(X)={x-5}"
    elif 300<=x:
       return print( "F(X)=50")
   
print(calculator(300))


#%%Pregunta 2

import numpy as np
# creamos un vector "v" de 100 observaciones
v = np.arange (0,100) 
print(v)

np.min(v) #para ir observando el mínimo de dicho vector
np.max(v)

#creamos una matriz "M"
M = np.arange(0,5000).reshape (100, 50) #esta tiene valores del 0 al 4999 y se utiliza el "reshape" para que sea una matriz de 100x50
print(M)
M.shape #comprobamos que M sea una matriz de 100x50
type(v)
type(M) #observamos que es numpy.ndarray

print(np.min(M, axis=0)) 
print(np.max(M, axis=0))
#para reescalar los datos de las columnas de la matriz, queremos ver sus mínimos y máximos por columna
X = np.min(M, axis=0) #axis=0 pq queremos observar por columnas
Y = np.max(M, axis=0)
print(X)
X.shape

#reescalamos vector y matriz
try:     
    
    print((v-min(v))/max(v)-min(v))   # No corre el código si detecta un error 
    
except TypeError:
  print("El argumento  deberia ser un vector")
  
try:     
    
    print((M-X)/Y-X)   # No corre el código si detecta un error 
    
except TypeError:
  print("El argumento  deberia ser una matriz")

#%%Pregunta 3

#Importamos las bases requeridas:
import random 
import pandas as pd
import numpy as np

#Establecemos una base de datos que no cambia para cada tamaño de muestra
random.seed(100000)
random.sample(range(10000),k=10)

#Se establece los X necesarios para un tamaño de muestra de 10
x1 = np.random.rand(10) # uniform distribution  [0,1]
x2 = np.random.rand(10) # uniform distribution [0,1]
x3 = np.random.rand(10) # uniform distribution [0,1]
x4 = np.random.rand(10) # uniform distribution [0,1]
e = np.random.normal(0,1,10) # normal distribution mean = 0 and sd = 1
z = np.random.rand(10)
# Se genera la ecuación de regresión

Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e

X = np.column_stack((np.ones(10),x1,x2,x3,x4))
X

from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df



ols(X,Y)

ols(X,Y,instrumento = z, index = 1)

# Para un tamaño de muestra de 50

random.sample(range(10000),k=50)
x1 = np.random.rand(50) # uniform distribution  [0,1]
x2 = np.random.rand(50) # uniform distribution [0,1]
x3 = np.random.rand(50) # uniform distribution [0,1]
x4 = np.random.rand(50) # uniform distribution [0,1]
e = np.random.normal(0,1,50) # normal distribution mean = 0 and sd = 1
z = np.random.rand(50)
# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e
X = np.column_stack((np.ones(50),x1,x2,x3,x4))
X
from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df



ols(X,Y)

ols(X,Y,instrumento = z, index = 1)

# Para una muestra de 80 

random.sample(range(10000),k=80)
x1 = np.random.rand(80) # uniform distribution  [0,1]
x2 = np.random.rand(80) # uniform distribution [0,1]
x3 = np.random.rand(80) # uniform distribution [0,1]
x4 = np.random.rand(80) # uniform distribution [0,1]
e = np.random.normal(0,1,80) # normal distribution mean = 0 and sd = 1
z = np.random.rand(80)
# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e

X = np.column_stack((np.ones(80),x1,x2,x3,x4))
X
from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df



ols(X,Y)

ols(X,Y,instrumento = z, index = 1)

# Para una muestra de 120

random.sample(range(10000),k=120)
x1 = np.random.rand(120) # uniform distribution  [0,1]
x2 = np.random.rand(120) # uniform distribution [0,1]
x3 = np.random.rand(120) # uniform distribution [0,1]
x4 = np.random.rand(120) # uniform distribution [0,1]
e = np.random.normal(0,1,120) # normal distribution mean = 0 and sd = 1
z = np.random.rand(120)
# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e
X = np.column_stack((np.ones(120),x1,x2,x3,x4))
X
from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df



ols(X,Y)

ols(X,Y,instrumento = z, index = 1)


# Para una muestra de 200

random.sample(range(10000),k=200)
x1 = np.random.rand(200) # uniform distribution  [0,1]
x2 = np.random.rand(200) # uniform distribution [0,1]
x3 = np.random.rand(200) # uniform distribution [0,1]
x4 = np.random.rand(200) # uniform distribution [0,1]
e = np.random.normal(0,1,200) # normal distribution mean = 0 and sd = 1
z = np.random.rand(200)
# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e
X = np.column_stack((np.ones(200),x1,x2,x3,x4))
X
from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df

# Para una muestra de 500

ols(X,Y)

ols(X,Y,instrumento = z, index = 1)

random.sample(range(10000),k=500)
x1 = np.random.rand(500) # uniform distribution  [0,1]
x2 = np.random.rand(500) # uniform distribution [0,1]
x3 = np.random.rand(500) # uniform distribution [0,1]
x4 = np.random.rand(500) # uniform distribution [0,1]
e = np.random.normal(0,1,500) # normal distribution mean = 0 and sd = 1
z = np.random.rand(500)
# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e
X = np.column_stack((np.ones(500),x1,x2,x3,x4))
X
from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df



ols(X,Y)

ols(X,Y,instrumento = z, index = 1)

# Para una muestra de 1000

random.sample(range(10000),k=800)
x1 = np.random.rand(800) # uniform distribution  [0,1]
x2 = np.random.rand(800) # uniform distribution [0,1]
x3 = np.random.rand(800) # uniform distribution [0,1]
x4 = np.random.rand(800) # uniform distribution [0,1]
e = np.random.normal(0,1,800) # normal distribution mean = 0 and sd = 1
z = np.random.rand(800)
# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e
X = np.column_stack((np.ones(800),x1,x2,x3,x4))
X
from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df



ols(X,Y)

ols(X,Y,instrumento = z, index = 1)


# Para una muestra de 5000
random.sample(range(10000),k=1000)
x1 = np.random.rand(1000) # uniform distribution  [0,1]
x2 = np.random.rand(1000) # uniform distribution [0,1]
x3 = np.random.rand(1000) # uniform distribution [0,1]
x4 = np.random.rand(1000) # uniform distribution [0,1]
e = np.random.normal(0,1,1000) # normal distribution mean = 0 and sd = 1
z = np.random.rand(1000)
# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e
X = np.column_stack((np.ones(1000),x1,x2,x3,x4))
X
from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df



ols(X,Y)

ols(X,Y,instrumento = z, index = 1)

# PREGUNTA 4

random.sample(range(800),k=50)
x1 = np.random.rand(800) # uniform distribution  [0,1]
x2 = np.random.rand(800) # uniform distribution [0,1]
x3 = np.random.rand(800) # uniform distribution [0,1]
x4 = np.random.rand(800) # uniform distribution [0,1]
x5 = np.random.rand(800) # uniform distribution [0,1]
x6 = np.random.rand(800)# uniform distribution [0,1]
x7 = np.random.rand(800)# uniform distribution [0,1]

e = np.random.normal(0,1,800) # normal distribution mean = 0 and sd = 1
z = np.random.rand(800)
# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4  +1.5*x5 +1.5*x6 +1.5*x7+ e
X = np.column_stack((np.ones(800),x1,x2,x3,x4,x5,x6,x7))
X
from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        root  =sum(list( map( lambda x: x**2 , Y - y_est)   )) / n
        liminf = beta - 1.96 * sd # Limite inferior
        limsup = beta + 1.96*sd # Limite superior
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue, "Lim.Inf": liminf, "Limf.Sup": limsup})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df

ols(X,Y)



#%%Pregunta 3

#Importamos las bases requeridas:
import random 
import pandas as pd
import numpy as np

#Establecemos una base de datos que no cambia para cada tamaño de muestra
random.seed(100000)
random.sample(range(10000),k=10)

#Se establece los X necesarios para un tamaño de muestra de 10
x1 = np.random.rand(10) # uniform distribution  [0,1]
x2 = np.random.rand(10) # uniform distribution [0,1]
x3 = np.random.rand(10) # uniform distribution [0,1]
x4 = np.random.rand(10) # uniform distribution [0,1]
e = np.random.normal(0,1,10) # normal distribution mean = 0 and sd = 1
z = np.random.rand(10)
# Se genera la ecuación de regresión

Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e

X = np.column_stack((np.ones(10),x1,x2,x3,x4))
X

from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df



ols(X,Y)

ols(X,Y,instrumento = z, index = 1)

# Para un tamaño de muestra de 50

random.sample(range(10000),k=50)
x1 = np.random.rand(50) # uniform distribution  [0,1]
x2 = np.random.rand(50) # uniform distribution [0,1]
x3 = np.random.rand(50) # uniform distribution [0,1]
x4 = np.random.rand(50) # uniform distribution [0,1]
e = np.random.normal(0,1,50) # normal distribution mean = 0 and sd = 1
z = np.random.rand(50)
# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e
X = np.column_stack((np.ones(50),x1,x2,x3,x4))
X
from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df



ols(X,Y)

ols(X,Y,instrumento = z, index = 1)

# Para una muestra de 80 

random.sample(range(10000),k=80)
x1 = np.random.rand(80) # uniform distribution  [0,1]
x2 = np.random.rand(80) # uniform distribution [0,1]
x3 = np.random.rand(80) # uniform distribution [0,1]
x4 = np.random.rand(80) # uniform distribution [0,1]
e = np.random.normal(0,1,80) # normal distribution mean = 0 and sd = 1
z = np.random.rand(80)
# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e

X = np.column_stack((np.ones(80),x1,x2,x3,x4))
X
from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df



ols(X,Y)

ols(X,Y,instrumento = z, index = 1)

# Para una muestra de 120

random.sample(range(10000),k=120)
x1 = np.random.rand(120) # uniform distribution  [0,1]
x2 = np.random.rand(120) # uniform distribution [0,1]
x3 = np.random.rand(120) # uniform distribution [0,1]
x4 = np.random.rand(120) # uniform distribution [0,1]
e = np.random.normal(0,1,120) # normal distribution mean = 0 and sd = 1
z = np.random.rand(120)
# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e
X = np.column_stack((np.ones(120),x1,x2,x3,x4))
X
from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df



ols(X,Y)

ols(X,Y,instrumento = z, index = 1)


# Para una muestra de 200

random.sample(range(10000),k=200)
x1 = np.random.rand(200) # uniform distribution  [0,1]
x2 = np.random.rand(200) # uniform distribution [0,1]
x3 = np.random.rand(200) # uniform distribution [0,1]
x4 = np.random.rand(200) # uniform distribution [0,1]
e = np.random.normal(0,1,200) # normal distribution mean = 0 and sd = 1
z = np.random.rand(200)
# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e
X = np.column_stack((np.ones(200),x1,x2,x3,x4))
X
from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df

# Para una muestra de 500

ols(X,Y)

ols(X,Y,instrumento = z, index = 1)

random.sample(range(10000),k=500)
x1 = np.random.rand(500) # uniform distribution  [0,1]
x2 = np.random.rand(500) # uniform distribution [0,1]
x3 = np.random.rand(500) # uniform distribution [0,1]
x4 = np.random.rand(500) # uniform distribution [0,1]
e = np.random.normal(0,1,500) # normal distribution mean = 0 and sd = 1
z = np.random.rand(500)
# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e
X = np.column_stack((np.ones(500),x1,x2,x3,x4))
X
from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df



ols(X,Y)

ols(X,Y,instrumento = z, index = 1)

# Para una muestra de 1000

random.sample(range(10000),k=800)
x1 = np.random.rand(800) # uniform distribution  [0,1]
x2 = np.random.rand(800) # uniform distribution [0,1]
x3 = np.random.rand(800) # uniform distribution [0,1]
x4 = np.random.rand(800) # uniform distribution [0,1]
e = np.random.normal(0,1,800) # normal distribution mean = 0 and sd = 1
z = np.random.rand(800)
# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e
X = np.column_stack((np.ones(800),x1,x2,x3,x4))
X
from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df



ols(X,Y)

ols(X,Y,instrumento = z, index = 1)


# Para una muestra de 5000
random.sample(range(10000),k=1000)
x1 = np.random.rand(1000) # uniform distribution  [0,1]
x2 = np.random.rand(1000) # uniform distribution [0,1]
x3 = np.random.rand(1000) # uniform distribution [0,1]
x4 = np.random.rand(1000) # uniform distribution [0,1]
e = np.random.normal(0,1,1000) # normal distribution mean = 0 and sd = 1
z = np.random.rand(1000)
# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e
X = np.column_stack((np.ones(1000),x1,x2,x3,x4))
X
from scipy.stats import t # t - student 
def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue})    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df



ols(X,Y)

ols(X,Y,instrumento = z, index = 1)


