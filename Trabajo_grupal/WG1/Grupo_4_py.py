# -*- coding: utf-8 -*-
"""#-------------------------------------------------------------------------------


                                 TAREA 1- GRUPO 4 


"""#--------------------------------------------------------------------------------


#%% PREGUNTA 1


#### Importamos las librerías correspondientes.

import numpy as np
import math

from numpy import random


#### Generamos un vector de 500 valores aleatorios, de donde se escogerán 20 datos

x=np.random.randint(500, size=(20))

print(x)


#### Construimos el primer if statement (w), que sacará la raíz cuadrada a cada uno de los elementos que cumplan con la condición de estar entre 0 y 100.


w = x**0.5

if  (w < 100).all():
    print("Number is smaller than one hundred") 
        
elif (w > 0):
    print("Number is greater than Zero") 
        
else: 
    print("Number is Zero") 
    
    

#### Construimos el segundo if statement (j), que le restará 5 a cada uno de los elementos que cumplan con la condición de tomar valores entre 100 y 300.

j= (x-5) .all()
if (j < 300):  
    print("Number is smaller than three hundred")
elif (j > 100): 
    print("Number is greater than one hundred")
else: 
    print("Number is Zero")
    
    

#### Construimos el último if statement (p), que igualará a 50 a cada uno de los elementos que cumplan con la condición de ser mayores a 300.

p = 50 
if p > 300:
    print(p, "is s greater than three hundred")

    

#%% PREGUNTA 2

#### Importamos las librerías necesarias

import numpy as np
from numpy import random


#### Creamos el vector con 100 observaciones enteras aleatorias

v=np.random.randint(100, size=(100))

print(v)


#### Creamos la matriz de 100 x 50 con observaciones enteras aleatorias

m=np.random.randint(0, 101, (100, 50)) 

print (m)


#### Creamos la función que nos diga si es una matriz o vector de tipo np.nd array y bote mensaje si no lo es
#### En caso el objeto sea un vector o matriz, la función hallará el valor del escalar y reajustará la matriz y vector de acuerdo a este, dando como resultado la matriz ajustada.
def escalar (M):
    
    if not isinstance(M, np.ndarray ) :      
        raise TypeError( "x debe ser una matriz o vector")
  
    
    else:
         
        a = M.max(axis=0)
        b = M.min(axis=0)
        e = (M-b)/(a-b)
        M=M*e
            
        return M
  

#### Probamos la función en nuestro vector y obtenemos el vector ajustado por el escalar.

print (escalar(v))

#### Probamos la función en nuestra matriz y obtenemos la matriz ajustada por el escalar.

print (escalar(m))

#%% PREGUNTA 3 

import numpy as np
import random 
from scipy.stats import t # t - student 
import pandas as pd 

#número de observaciones= 10000

#fijamos una semilla
np.random.seed(175)

#creamos 5 variables, las cuales tienen una distribución uniforme de entre [0,1]    

x1 = np.random.rand(10000) 
print(x1)
x2 = np.random.rand(10000) 
print(x2)
x3 = np.random.rand(10000) 
x4 = np.random.rand(10000)
x5 = np.random.rand(10000) 
e = np.random.normal(0,1,10000) # normal distribution mean = 0 and sd = 1

# El modelo sin contar a la explicativa x5 sería: 
# Y = b1*x1 + b2*x2 + b3*x3 + b4*x4 + e

Y = 0.7*x1 + 1.6*x2 + 0.3*x3 + 1.8*x4 + e

X = np.column_stack((np.ones(10000),x1,x2,x3,x4,x5))
print(X)

beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
print(beta)

####Creamos una tupla con los tamaños de muestra

m = (10,50,80,120,200,500,800)

#### Con un m=10

w1=np.array(random.sample( range(10000) , m[0] ))
print(w1)
w2=np.array(random.sample(range(10000) , m[0] ))
w3=np.array(random.sample( range(10000) , m[0] ))
w4=np.array(random.sample( range(10000) , m[0] ))
w5=np.array(random.sample( range(10000) , m[0] ))
b = np.random.normal(0,1,m[0]) 

Y_1 = 0.7*w1 + 1.6*w2 + 0.3*w3 + 1.8*w4 + b

X_1 = np.column_stack((np.ones( m[0]),w1,w2,w3,w4,w5))
print(X_1)

beta1 = np.linalg.inv(X_1.T @ X_1) @ ((X_1.T) @ Y_1 )
print(beta1)

y_est_1 =  X_1 @ beta1 
n1 = X_1.shape[0]
k1 = X_1.shape[1] - 1 
nk1 = n1 - k1   
sigma =  sum(list( map( lambda x: x**2 , Y_1 - y_est_1)   )) / nk1 
Var = sigma*np.linalg.inv(X_1.T @ X_1)
sd1 = np.sqrt( np.diag(Var) )
print(sd1)

#### Con un m=50

r1=np.array(random.sample( range(10000) , m[1] ))
r2=np.array(random.sample(range(10000) , m[1] ))
r3=np.array(random.sample( range(10000) , m[1] ))
r4=np.array(random.sample( range(10000) , m[1] ))
r5=np.array(random.sample( range(10000) , m[1] ))
l = np.random.normal(0,1,m[1]) 

Y_2 = 0.7*r1 + 1.6*r2 + 0.3*r3 + 1.8*r4 + l

X_2 = np.column_stack((np.ones( m[1]),r1,r2,r3,r4,r5))
print(X_2)

beta2 = np.linalg.inv(X_2.T @ X_2) @ ((X_2.T) @ Y_2 )
print(beta2)

y_est_2 =  X_2 @ beta2
n2 = X_2.shape[0]
k2 = X_2.shape[1] - 1 
nk2 = n2 - k2   
sigma =  sum(list( map( lambda x: x**2 , Y_2 - y_est_2)   )) / nk2 
Var = sigma*np.linalg.inv(X_2.T @ X_2)
sd2 = np.sqrt( np.diag(Var) )
print(sd2)

#### Con un m=80

f1=np.array(random.sample( range(10000) , m[2] ))
f2=np.array(random.sample(range(10000) , m[2] ))
f3=np.array(random.sample( range(10000) , m[2] ))
f4=np.array(random.sample( range(10000) , m[2] ))
f5=np.array(random.sample( range(10000) , m[2] ))
f = np.random.normal(0,1,m[2]) 

Y_3 = 0.7*f1 + 1.6*f2 + 0.3*f3 + 1.8*f4 + f

X_3 = np.column_stack((np.ones( m[2]),f1,f2,f3,f4,f5))
print(X_3)

beta3 = np.linalg.inv(X_3.T @ X_3) @ ((X_3.T) @ Y_3 )
print(beta3)

y_est_3 =  X_3 @ beta3
n3 = X_3.shape[0]
k3 = X_3.shape[1] - 1 
nk3 = n3 - k3   
sigma =  sum(list( map( lambda x: x**2 , Y_3 - y_est_3)   )) / nk3 
Var = sigma*np.linalg.inv(X_3.T @ X_3)
sd3 = np.sqrt( np.diag(Var) )
print(sd3)


sd=(sd1,sd2,sd3)
print(sd)

df = pd.DataFrame( {"tamaño de muestra": m , "standar_error" : sd ,
                    "coeficiente" : beta} )  

#%% PREGUNTA 4

#### Importamos 'numpy' y 'random' como para poder generar una semilla aleatoria para producir números aleatorios "
import numpy as np
import random
import pandas as pd
from scipy.stats import t
import seaborn as sns

random.seed(175)


#### Crear un proceso generador de datos con 8 variables (intercepto y 7 explicativas) y 800 observaciones
#### Como queremos 800 observaciones, generaremos 800 números aleatorios que serán seleccionados dentro de las variables explicativas y el error"

#### Además, las variables explicativas tienen distribución uniforme de entre [0,1]"
x1 = np.random.rand(800)
x2 = np.random.rand(800)
x3 = np.random.rand(800)
x4 = np.random.rand(800)
x5 = np.random.rand(800)
x6 = np.random.rand(800)
x7 = np.random.rand(800)
e = np.random.normal(0,1,800)
z = np.random.rand(800)
#### El término de perturbación o error se diferencia porque tiene distribución normal, con media 0 y desviación estándar 1."

#### GDP. El modelo sería Y = B0+B1*x1+B2*x2+B3*x3+B4*x4+B5*x5+B6*x6+B7*x7+e
Y = 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 2.5*x5 + 0.8*x6 + 1.7*x7 + e

#### Juntamos los vectores en una sola matriz para hallar las X, no olvidemos añadir el vector de unos con "np.ones(800)"
X = np.column_stack((np.ones(800),x1,x2,x3,x4,x5,x6,x7))
print(X)


#### Ahora, procedemos a crear una función que realice:
#### Vector de coeficientes, error estándar de cada coeficiente estimado, P-value de cada variable , limite inferior del intervalo de confianza, limite superior del intervalo de confianza, R cuadrado , Root-MSE (raíz cuadrada del error cuadrático medio).

def ols(M,Y, standar = True, Pvalue = True, instrumento = None, index = None):
    if standar and Pvalue and (instrumento is None) and (index is None):
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y ) ## Para hallar las betas debemos transponer la matriz y las multiplicamos con el uso del operador "@". Este sería el vector de coeficientes.
        y_est = X @ beta 
        n = X.shape[0]
        k = X.shape[1] - 1         
        nk = n - k     ## grados de libertad
        sigma =  sum(list( map( lambda x: x**2 , Y - y_est)   )) / nk 
        Var = sigma*np.linalg.inv(X.T @ X)
        sd = np.sqrt( np.diag(Var) )  ## sacamos raíz cuadrada a los elementos de la diagonal principal 
        t_est = np.absolute(beta/sd)
        pvalue = (1 - t.cdf(t_est, df=nk) ) * 2
        lim_inf = beta - 1.96 * sd ## Dato para hallar los límites superiores e inferiores del intervalo del confianza
        lim_sup = beta + 1.96 * sd
        df = pd.DataFrame( {"OLS": beta , "standar_error" : sd ,
                                 "Pvalue" : pvalue, "Límite_inferior" : lim_inf, "Límite_superior" : lim_sup })    

    
    elif (not instrumento is None) and (not index is None) :
        
        beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        
        index = index  - 1 
        Z = X
        Z[:,index] = z ## se reemplaza la variable endógena por el instrumento en la matriz de covariables
        beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
        x_est  = Z @ beta_x
        X[:,index] = x_est ## se reemplaza la variable x endógena por su estimado 
        beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
        df = pd.DataFrame( {"OLS": beta , "OLS_IV" : beta_iv})  

    return df

#### Definida la función, podemos obtener los errores estándar de cada coeficiente, su p value y el intervalo de confianza.
ols(X,Y)
ols(X,Y,instrumento = z, index = 1)  
print(ols(X,Y))

    
    
    
    
    
    
