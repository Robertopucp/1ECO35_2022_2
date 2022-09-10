import random  # Primero importamos las bibliotecas pertinentes
import numpy as np
import math


# %% EJERCICIO NUMERO 1

np.random.seed(188)  # Luego, definimos la random seed 188
# Posteriormente, creamos x que será un vector 1x20 con valores entre 0 y 500
x = np.random.randint(0, 500, size=20)
print(x)  # Comprobamos la matriz x

y = []  # Ahora, para el punto 1.1, definimos el vector y que tendrá como componentes a los valores de x
print(type(y))
for i in x:
    if i > 0 and i <= 100:  # Si i entre 0 y 100, el componente 1xi adoptará el valor de i^0.5
        y.append(i**0.5)
    else:
        y.append(i**0)  # Caso contrario, se computará el valor de 1

print(y)  # Comprobamos la matriz y

z = []  # Ahora, para el punto 1.2, definimos el vector z que tendrá como componentes a los valores de x
for i in x:
    if i > 100 and i <= 300:  # Si i entre 100 y 300, el componente 1xi adoptará el valor de i-5
        z.append(i-5)
    else:
        z.append(i**0)  # Caso contrario, se computará el valor de 1

print(z)  # Comprobamos la matriz z

k = []  # Ahora, para el punto 1.3, definimos el vector k que tendrá como componentes a los valores de x
for i in x:
    if i > 300 and i <= 500:  # Si i entre 300 y 500, el componente 1xi adoptará el valor de 50
        k.append(50)
    else:
        k.append(i**0)  # Caso contrario, se computará el valor de 1

print(k)  # Comprobamos la matriz z



# %% EJERCICIO 2

np.random.seed(100)  # Definimos la random seed 100

# Creamos el vector 1x100 llamada v1
v1 = np.random.randint(0, 500, size=(100))


# Creamos la matriz 100x50 llamada M1
m1 = np.random.randint(0, 500, size=(100, 50))


def escalamiento(variable):

    try:
        if not isinstance(variable, np.ndarray):
            raise TypeError("ERROR, NO ESTÁ BIEN EL TIPO DE VARIABLE")

        colum = variable.shape[1]

    except IndexError:

        # SOLO PARA VECTOR
        minimo = min(variable)
        maximo = max(variable)
        resultado = []

        for i in range(variable.shape[0]):
            escalar = ((variable[i]-minimo)/maximo-minimo)
            resultado.append(escalar)

        print(resultado)

    else:

        l = []
        lista_nuevo = []
        lista_n1 = []
        for i in range(variable.shape[0]):
            for j in range(variable.shape[1]):
                l.append(variable[i][j])

            maximo = max(l)
            minimo = min(l)
            for k in range(variable.shape[1]):
                escalar = (((variable[i][k])-minimo)/(maximo-minimo))
                lista_nuevo.append(escalar)

            lista_n1.append(lista_nuevo)
            lista_nuevo = []
            l = []

        print(lista_n1)


escalamiento(m1)



# %% EJERCICIO 3

import random
import numpy as np

from scipy.stats import t # t - student 
import pandas as pd 

np.random.seed(175)

x1 = np.random.rand(10000) # uniform distribution  [0,1]
x2 = np.random.rand(10000) # uniform distribution [0,1]
x3 = np.random.rand(10000) # uniform distribution [0,1]
x4 = np.random.rand(10000) # uniform distribution [0,1]
x5 = np.random.rand(10000) #uniform distribution  [0,1]
e = np.random.normal(0,1,10000) # normal distribution mean = 0 and sd = 1
z = np.random.rand(10000)
# Poblacional regression (Data Generating Process GDP)


Y = 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 2.2*x5 + e

X = np.column_stack((np.ones(10000),x1,x2,x3,x4,x5))

def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
         beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y ) 
        
         y_est =  X @ beta 
         n = X.shape[0]
         k = X.shape[1] - 1 
         nk = n - k    
         sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
         Var = sigma*np.linalg.inv(X.T @ X)
         sd = np.sqrt( np.diag(Var) )
         t_est = np.absolute(beta/sd)
         pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
         df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                             "Pvalue" : pvalue} )    
         
    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df

ols(X,Y)
 ## n=50



# %% EJERCICIO 4

import random
import numpy as np

from scipy.stats import t # t - student 
import pandas as pd 

np.random.seed(175)

x1 = np.random.rand(800) # uniform distribution  [0,1]
x2 = np.random.rand(800) # uniform distribution [0,1]
x3 = np.random.rand(800) # uniform distribution [0,1]
x4 = np.random.rand(800) # uniform distribution [0,1]
x5 = np.random.rand(800) #uniform distribution  [0,1]
x6 = np.random.rand(800) #uniform distribution  [0,1]
x7= np.random.rand(800)
e = np.random.normal(0,1,800) # normal distribution mean = 0 and sd = 1
z = np.random.rand(800)
# Poblacional regression (Data Generating Process GDP)


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 2.2*x5 + 3.5*x6 + 4.2*x7 + e

X = np.column_stack((np.ones(800),x1,x2,x3,x4,x5,x6,x7))

def ols(M,Y, standar = True, Pvalue = True , instrumento = None, index = None):

    if standar and Pvalue and (instrumento is None)  and (index is None) :
        
         beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y ) 
        
         y_est =  X @ beta 
         n = X.shape[0]
         k = X.shape[1] - 1 
         nk = n - k    
         sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
         Var = sigma*np.linalg.inv(X.T @ X)
         sd = np.sqrt( np.diag(Var) )
         t_est = np.absolute(beta/sd)
         pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
         df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                             "Pvalue" : pvalue} )    
         
    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df

ols(X,Y)
 ##Limite inferior = beta_estimado - 1.96 * error estandar  
                   #Limite superior = beta_estimado + 1.96*error estandar











