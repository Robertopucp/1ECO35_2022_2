# -*- coding: utf-8 -*-

#%% Grupo 1. Miembros del grupo:

# 20163197, Enrique Alfonso Pazos 
# 20191894, Ilenia Ttito
# 20151595, Rodrigo Ramos
# 20193469, Luis Eguzquiza 
# 20163377, Jean Niño de Guzmán

#%% Pregunta 1

#Importación de la librería Numpy y Random para la creación de un Vector con valores aleatorios.
import random 
import numpy as np

#Creación del Vector con números aleatorios 

#Primero se crea una lista para crear los valores requeridos para el Vector
#Se asigna que la lista saque un total de 20 números aleatorios enteros entre 0 y 500.
Lista = random.sample(range(0,500),20)    
#Se ordenan los valores para que estén de menor a mayor.  
Lista.sort()                                

#Se pasan los valores de la lista hacia el Vector y indica que se imprima con su respectivo nombre.
Vector = np.array(Lista)                    
print('Vector =', Vector) 

#Creación de la "if statement"

#Se indica que cada valor de la lista se reemplazará dependiendo de en que rango se encuentre.
for index, i in enumerate(Lista):           
#Rangos que los valores seguirán para reemplazarse por otro. 
#Se indica que se reemplacen los valores transformados en la lista .
    if i > 0 and i <= 100:     
        Lista[index] = i**0.5               
        
    if i > 100 and i <= 300:
        Lista[index] = i-5    
        
    if i > 300:
        Lista[index] = 50 
        
#Se pasan los nuevos valores de la lista hacia el vector "Resultados" y indica que se imprima con su respectivo nombre.
Resultado = np.array(Lista)                 
#Se indica que se muestre el Vector resultados con su respectivo nombre.
print('Resultado =', Resultado)             



#%% Pregunta 2

import numpy as np
    
#### Resolución de tarea
"""
    El nombre de la función será reescalar.
"""
def reescalar (X):
    
    # Primero, pongo un condicional para que me filtre si el input que estoy colocando a la función es un n-array.
    if not isinstance( X , np.ndarray ) : 
        # Si no es un n-array, me mostrará el siguiente mensaje:
        raise TypeError( "El input debe ser un n-array")  
    
    # Si es un n-array, le pongo el siguiente condicional para que pase como matriz si tiene el tamaño de 5000, que 
    # es el resultado de multiplica su número de filas (100) por columnas (50).
    elif (X.size == 5000) : # poner el número de filas x columna de la matriz: 100 x 50 = 5000
        # Filas X = 100 , Columnas X = 50
        # Transponemos la matriz para que sea más fácil la extracción el valor mínimo y máximo 
        # Como el ejercicio pide sacar estos valores de cada columna, al hacer la transposición,
        # extraeré solo el máximo y mínimo valor de de las filas de la nueva matriz (X_T)
        X_T = np.transpose(X)    
        #rows_number me da el número de filas
        rows_number = X_T.shape[0]
        # Genero un array que tenga desde cero hasta el número de número de filas.
        Y = np.arange(rows_number)
        #En principio, el resultado será un array vacío. Sobre este, haré un append más adelante, sobre el que se irán apilando uno debajo del otro los escalonamientos.
        result = np.zeros(0)
        
        # Voy a iterar adentro del array Y para que cada uno de sus elementos me ayude a seleccionar cada fila de X_T según su índice.
        for j in Y:
            # Voy a seleccionar cada fila de la matriz X_T, la cual va a pasar a llamarse Row_j
            Row_j = X_T[j] 
            # Me va a extrar el mínimo y máximo valor de cada Row_j:
            a = min (Row_j) 
            b = max (Row_j)
            # Hago un array vacío sobre el que voy a colocar los resultados escalonados de cada fila más adelante
            d = np.zeros(0) 
            
            # Ahora, voy a iterar dentro del array Row_j
            for i in Row_j: 
                # Aquí, va a hacer el proceso de escalonamiento para cada elemento de la fila. 
                c = (i - a)/(b - a)
                # Luego, hago una append para que ponga un resultado debajo del otro.
                d = np.append(d, [c])
            # Nuevamente, sobre el array vacío generado antes, hago un append de lo obtenido en d.
            result = np.append(result, [d])
        
        #Reordeno los resultados a la forma de la matriz X_T 
        result = result.reshape(50, 100) # Filas de X_T = 50, Columnas de X_T = 100
        
        #Ahora, regreso la matriz a su orden natural de la matriz X.
        result = np.transpose(result)   
    
    # Si el array no es una matriz del tamaño 5000, será un vector, el cual seguirá el siguiente proceso:
    else : 
        # Me va a extrar el mínimo y máximo valor del vector:
        a = min (X) 
        b = max (X)
        d = np.zeros(0) 
        for i in X:        
            # Aquí, ve a hacer el proceso de escalonamiento para cada elemento del vector:
            c = (i - a)/(b - a)
            # Luego, hago una append para que ponga un resultado debajo del otro.
            d = np.append(d, [c])
        result = d
        
    return result

#### Creación de la matriz 
"""
    Aunque la tarea no lo pide, crearé una función para poder elaborar una matriz con las dimensiones que 
    le indique, y con elementos aleatorios.
"""
def hacer_matriz (m, n):
    # M: # de filas
    # N: # de columnas
    vacio = np.zeros(0)
    numero_iteraciones = np.arange(m)
    for i in numero_iteraciones:
        filas = np.random.rand(n)
        vacio = np.append(vacio, [filas])
    vacio = vacio.reshape(m,n)
    return vacio

#### Ejecución de la función
"""
    Ahora, crearé una matriz de 100 filas y 50 columnas. También, crearé un vector de 100 columnas.
"""
m = hacer_matriz(100, 50)

resultado_matriz = reescalar (m)

v = np.random.rand(100)

resultado_vector = reescalar (v) #como se puede observar, arroja un vector fila si se abre desde variable explorer.


#%% Pregunta 3


#%% Pregunta 4

import numpy as np
import random 
import math
from scipy.stats import t # t - student 
import pandas as pd 

np.random.seed(175) # Semilla

x1 = np.random.rand(800) 
x2 = np.random.rand(800) 
x3 = np.random.rand(800) 
x4 = np.random.rand(800) 
x5 = np.random.rand(800) 
x6 = np.random.rand(800)
x7 = np.random.rand(800)
e = np.random.normal(0,1,800) 

#Proceso Gererador de datos
Y= 1 + 0.7*x1 + 1.1*x2 + 0.9*x3 + 1.5*x4 + 0.6*x5 + 0.3*x6 + 0.1*x7 + e

X  = np.column_stack((np.ones(800),x1,x2,x3,x4,x5,x6,x7))

def MCO (Y, X,I=None,H =None):
    
    # Calulcar beta y las dimensiones de n y k
    # dependiendo de si tiene o no intercepto
    if I is None :
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        n = X.shape[0]
        k = X.shape[1] - 1
        
    elif (not I is None) :
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        n = X.shape[0]
        k = X.shape[1]
    
    # Cálculo de Y estimado, SCR, SCT, Sigma(s2)
    Yhat = X@beta
    Yerror = Y-Yhat
    Yerror2 = np.power(Yerror, 2)
    
    SCR =(Yerror.T @Yerror)
    Ydesv = Y - (np.ones(n)*np.mean(Y))
    SCT =(Ydesv.T @Ydesv)
    nk=n-k
    s2= SCR/nk
    
    # Cáclulo de Matriz de Varianzas y Covarianzas dependiendo
    # si considero ajuste de White o no
    if H is None :
        MatVarCov= (np.linalg.inv(X.T @ X))*s2
        
    elif (not H is None):

        V=np.diag(Yerror2)
        MatVarCov= (np.linalg.inv(X.T @ X))@(X.T@V@X)@(np.linalg.inv(X.T @ X))
     
    # Cálculo de erro estandar, limites superiores e inferiores de los beta
    # Pvalue, Rcuadrado, Root.MSE
    
    sd=np.diag(MatVarCov)
    limsup =beta + 1.96*(sd)
    liminf =beta - 1.96*(sd)
    t_est = np.absolute(beta/sd)
    pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
    
    R2 = 1-(SCR/SCT)
    Root_MSE = math.sqrt((Yerror.T @Yerror)/800)
    
    # Agregar beta, error estandar, limites en un dataframe
    
    df = pd.DataFrame( {"Betas": beta , "standar_error" : sd ,"Lim inf": liminf,"Lim sup": limsup,"Pvalue" : pvalue})  
    
    # Agregar Rcuadrado y ROOT-MSE en un diccionario
    
    dic = {"Rcuadrado":R2,"ROOT-MSE":Root_MSE}
 
    return  df, dic

print(MCO(Y, X))     
