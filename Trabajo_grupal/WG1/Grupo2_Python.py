
"""
Ejercicio 1 

"""

import random
import numpy as np



# Definimos las 3 funciones del ejercicio
def f1(x):
    return x**(0.5)

def f2(x):
    return x-5

def f3(x):
    return 50


# Se crea vector aleatorio con 20 números del 0 a 500
a= np.random.randint(0,500,20)

#Resolvemos las ecuaciones con el vector poniendo condicionales dado el rango

for i in range(0,20):
    if a[i] <=100:
        print(" función 1:")
        print(f1(i))
    
    if a[i]<=300:
        print(" función 2:")
        print(f2(i))
        
    else:
       print(" función 3:")
       print(f3(i))
        
"""
Ejercicio 2 

"""
        
#fijar semilla
np.random.seed(123) 

# Crear vector con 100 observaciones
v1 = np.random.rand(100) 

#Para crear mi matriz voy a empezar con un vector base
x1 = np.random.rand(100) 
# Crear matriz en base a ese vector que sea 100x50 
X1 = x1.reshape(-1, 1) ** np.arange(0, 50)
# Vector
print(x1)
# Matriz
print(X1)
print(X1.shape) # nos dice cuantas filas y columnas tiene la matriz

# Crear función para reescalar matriz

def calculator_scalar(x, M, n):
    if not isinstance( x , np.ndarray ) :      
        raise TypeError( "x must be a n-array")
        
    if not isinstance( M , np.ndarray ) :      
        raise TypeError( "M must be a n-array") 
    
    y1 = x[n]
    z1 = M[:, n]
    m1 = min(z1)
    m2 = max(z1)

    result= y1 - m1/ m2 - m1 
    
    return result

#Hallo mi resultado con el vector y matriz creada, 
#En este caso, pondre de orden 3(elemento 3 del vector y columna 3 de la matriz) 
print(calculator_scalar(v1, X1, 3)) 
# Por ejemplo, result= 0.7903050938324261

#En esta prueba, me debe salir el error y "x must be a n-array"
print(calculator_scalar("Hola", X1, 3)) 


"""
Ejercicio 3 

"""
#Primero descargamos las librerías
import numpy as np 
import pandas as pd
import random
import pylab as pl
import matplotlib.pyplot as plt
from sklearn import linear_model
from scipy.stats import t # t - student 


#Luego exploramos la estructura del código
random.seed(175)

x1 = np.random.rand(10000) # uniform distribution  [0,1]  np.random.rand(x) creates an array of (x) random numbers
x2 = np.random.rand(10000) 
x3 = np.random.rand(10000) 
x4 = np.random.rand(10000) 
x5 = np.random.rand(10000)


e = np.random.normal(0,1,10000) # normal distribution mean = 0 and sd = 1
z = np.random.rand(10000)

Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4  + e #omitimos una variable del GDP

X = np.column_stack((np.ones(10000),x1,x2,x3,x4))

def ols(M,Y, standar = True, Pvalue = True):
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        i=100000
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        df = pd.DataFrame( {"Tamaño de muestra":i,"Coeficiente": beta , "Error estándar" : sd})
        return df
plt.scatter(x1, Y,  color='blue')
plt.xlabel("Engine size")
plt.ylabel("Emission")
plt.show()

x11 = np.random.choice(x1, size=10000)
x22 = np.random.choice(x2, size=10000)
x33 = np.random.choice(x3, size=10000)
x44 = np.random.choice(x3, size=10000)
x55 = np.random.choice(x5, size=10000)

x11 #x1 es un array de valores aleatorios distribuídos uniformemente

np.random.choice(x11, size=10) #de esta forma podemos extraer una muestra de 10 observaciones dentro del array X1

#La tarea es crear un Loop con los siguientes valores (como ejemplo veamos):
for n in [10, 50, 80, 120, 200, 500, 800, 1000, 5000]:
        x = n **2
        print(x)

#lo que buscamos es un loop que tome valores dentro del rango propuesto y arme muestras aleatorias del mismo size de cada valor 
for n in [10, 50, 80, 120, 200, 500, 800, 1000, 5000]:
        x11 = np.random.choice(x1, size=n)
        x22 = np.random.choice(x2, size=n)
        x33 = np.random.choice(x3, size=n)
        x44 = np.random.choice(x3, size=n)
        x55 = np.random.choice(x5, size=n)
        print("Número de observaciones:",x11.shape,x22.shape,x33.shape,x44.shape,x55.shape)
#Aquí observamos que se generan arreglos del tamano buscado 




#Será necesario contar con un valor estimado (Y) y, por ende, con un conjunto de datos por cada tamano de muestra
for i in [10, 50, 80, 120, 200, 500, 800, 1000, 5000]:
    x11 = np.random.choice(x1, size=i)
    x22 = np.random.choice(x2, size=i)
    x33 = np.random.choice(x3, size=i)
    x44 = np.random.choice(x3, size=i)
    x55 = np.random.choice(x5, size=i)
    e = np.random.normal(0,1,i)  
    Y = 1 + 0.5*x11 + 1.1*x22 + 0.4*x33 + 1.2*x44  + e #omitimos una variable del GDP
    X = np.column_stack((np.ones(i),x11,x22,x33,x44))
    print(Y)
    
    

random.seed(109)

x1 = np.random.rand(10000) # uniform distribution  [0,1]  np.random.rand(x) creates an array of (x) random numbers
x2 = np.random.rand(10000) 
x3 = np.random.rand(10000) 
x4 = np.random.rand(10000) 
x5 = np.random.rand(10000)


e = np.random.normal(0,1,10000) # normal distribution mean = 0 and sd = 1


Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4  + e #omitimos una variable del GDP

X = np.column_stack((np.ones(10000),x1,x2,x3,x4))

for i in [10, 50, 80, 120, 200, 500, 800, 1000, 5000]:
    x11 = np.random.choice(x1, size=i)
    x22 = np.random.choice(x2, size=i)
    x33 = np.random.choice(x3, size=i)
    x44 = np.random.choice(x3, size=i)
    x55 = np.random.choice(x5, size=i)
    e = np.random.normal(0,1,i)  
    Y = 1 + 0.5*x11 + 1.1*x22 + 0.4*x33 + 1.2*x44  + e #omitimos una variable del GDP
    X = np.column_stack((np.ones(i),x11,x22,x33,x44))
    results=ols(X,Y)
    print(results)
    
    def ols(M,Y, standar = True, Pvalue = True):
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )  ## estimación de beta
        y_est =  X @ beta   ## Y estimado 
        n = X.shape[0]
        k = X.shape[1] - 1  
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## raíz cuadrado a los datos de la diagonal principal de Var
        df = pd.DataFrame( {"Tamaño de muestra":i,"Coeficiente": beta , "Error estándar" : sd})
        return df






