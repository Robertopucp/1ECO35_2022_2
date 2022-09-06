####EJERCICIO 1

#Importamos la librería numpy
import numpy as np

#Como se utilizará una función utilizacom def
def fdiscontinuous():
  
  #Creamos el vector, donde queremos entre 0 y 500 observaciones con rango 1
  x=np.arange(0,500,1)
l=len(x)
y=l
#Creamos i para que el programa itere los valores del vector y asi los evalue segun cada condicion
for i in range(l):
  if (x[i]>0 and x[i]<100):
  print(y[i]==x[i]**1/2)
elif (x[i]>100 and x[i]<300):
  print(y[i]==x[i]-5)
elif (x[i]>300 and x[i]<500):
  print(y[i]==50)
#El vector aleatorio se desarrollará a continuación, donde se pide 20 observaciones aleatorias
vector=np.random.randint(0,500,20)
print (vector)
for range(vector) in fdiscontinuous():
  print(range(vector))




######EJERCICIO 2

#Creamos lo solicitado (una matriz aleatoria de medidas B[100x50]  y un vector con A[100] observaciones)

A <- matrix(vecA, nrow = 1, ncol = 100, byrow = FALSE)
A

B <- matrix(vecA, nrow = 100, ncol = 50, byrow = FALSE)
B

#Ahora con estas matrices, buscamos encontrar los valores máximos y mínimos de cada 

min = which(A == min(A), arr.ind = TRUE)

max = which(A == max(A), arr.ind = TRUE)

#Donde A[min] y A[max] son minimo y máximo respectivamente

#Con esto, podremos elaborar la fórmula por partes, un numerador y denominador; para lo cual efectuamos las operaciones.

Numerador = xi - A[max]
Denominador = A[max] - A[min]

#Con esto podremos efectuar el escalar:

Numerador/denominador



####EJERCICIO 3

#Crear un proceso generador de datos con 5 variables y un tamaño de población de 10 mil observaciones. 
#Crear un Loop que estime los coeficientes de un modelo de regresión lineal omitiendo una variable explicativa
#del proceso generador de datos. Asimismo, debe hallar el error estándar en cada iteración. 
#Usar los siguientes tamaños de muestra en el Loop n : 10, 50, 80 , 120 , 200, 500,800,100, 5000.
#Comente sus resultados. Los resultados deben presentarse en una Dataframe.
#El nombre de las columnas serán (tamaño de muestra, coeficiente y error estándar ).
#Nótese que debe construir las columnas del coeficiente y error estándar para cada regresor x .


###   para cuando el número de observaciones es 10000: n=10000

#Importamos las librerias necesarias para el programa
import random
import numpy as np
from scipy.stats import t   #para t - student 
import pandas as pd 

#Generamos un proceso generador de datos con 5 variables y un error estandar, que posee 10 000 observaciones
x1 = np.random.rand(10000)
x2 = np.random.rand(10000)
x3 = np.random.rand(10000)
x4 = np.random.rand(10000)
x5 = np.random.rand(10000)
e = np.random.normal(0,1,10000)     #El error estandar tiene distribucion normal

#funcion con las 5 variables y su término de error
Y = 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 3.2*x5 + e

#matriz de la funcion Y
X = np.column_stack((np.ones(10000),x1,x2,x3,x4,x5))

#coeficiientes estimados de la matriz X
beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

#indexing aleatorios para la matriz X
random.sample( range(10000) , 10000 )


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
df = pd.DataFrame( {"tamaño_de_muestra": n , "coeficiente": beta , "error_estándar" : sd} )    


elif (not instrumento is None) and (not index is None) :
  
  beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

index = index  - 1 
Z = X
Z[:,index] = z
beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
x_est  = Z @ beta_x
X[:,index] = x_est
beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
df = pd.DataFrame( {"coeficiente": beta , "coeficiente_IV" : beta_iv})  

return df

#para mostrar la dataframe con el tamaño de muestra, coeficientes y el error estándar
ols(X,Y)



###   para cuando el número de observaciones es 10: n=10

import random
import numpy as np
from scipy.stats import t   #para t - student 
import pandas as pd 

#se requiere una funcion con 5 variables aleatorias
x1 = np.random.rand(10)
x2 = np.random.rand(10)
x3 = np.random.rand(10)
x4 = np.random.rand(10)
x5 = np.random.rand(10)
e = np.random.normal(0,1,10)

#funcion con las 5 variables y su término de error
Y = 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 3.2*x5 + e

#matriz de la funcion Y
X = np.column_stack((np.ones(10),x1,x2,x3,x4,x5))

#coeficiientes estimados de la matriz X
beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

#indexing aleatorios para la matriz X
random.sample( range(10) , 10 )


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
df = pd.DataFrame( {"tamaño_de_muestra": n , "coeficiente": beta , "error_estándar" : sd} )    


elif (not instrumento is None) and (not index is None) :
  
  beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

index = index  - 1 
Z = X
Z[:,index] = z
beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
x_est  = Z @ beta_x
X[:,index] = x_est
beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
df = pd.DataFrame( {"coeficiente": beta , "coeficiente_IV" : beta_iv})  

return df

#para mostrar la dataframe con el tamaño de muestra, coeficientes y el error estándar
ols(X,Y)



###   para cuando el número de observaciones es 50: n=50

import random
import numpy as np
from scipy.stats import t   #para t - student 
import pandas as pd 

#se requiere una funcion con 5 variables aleatorias
x1 = np.random.rand(50)
x2 = np.random.rand(50)
x3 = np.random.rand(50)
x4 = np.random.rand(50)
x5 = np.random.rand(50)
e = np.random.normal(0,1,50)

#funcion con las 5 variables y su término de error
Y = 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 3.2*x5 + e

#matriz de la funcion Y
X = np.column_stack((np.ones(50),x1,x2,x3,x4,x5))

#coeficiientes estimados de la matriz X
beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

#indexing aleatorios para la matriz X
random.sample( range(50) , 50 )


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
df = pd.DataFrame( {"tamaño_de_muestra": n , "coeficiente": beta , "error_estándar" : sd} )    


elif (not instrumento is None) and (not index is None) :
  
  beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

index = index  - 1 
Z = X
Z[:,index] = z
beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
x_est  = Z @ beta_x
X[:,index] = x_est
beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
df = pd.DataFrame( {"coeficiente": beta , "coeficiente_IV" : beta_iv})  

return df

#para mostrar la dataframe con el tamaño de muestra, coeficientes y el error estándar
ols(X,Y)



###   para cuando el número de observaciones es 80: n=80

import random
import numpy as np
from scipy.stats import t   #para t - student 
import pandas as pd 

#se requiere una funcion con 5 variables aleatorias
x1 = np.random.rand(80)
x2 = np.random.rand(80)
x3 = np.random.rand(80)
x4 = np.random.rand(80)
x5 = np.random.rand(80)
e = np.random.normal(0,1,80)

#funcion con las 5 variables y su término de error
Y = 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 3.2*x5 + e

#matriz de la funcion Y
X = np.column_stack((np.ones(80),x1,x2,x3,x4,x5))

#coeficiientes estimados de la matriz X
beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

#indexing aleatorios para la matriz X
random.sample( range(80) , 80 )


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
df = pd.DataFrame( {"tamaño_de_muestra": n , "coeficiente": beta , "error_estándar" : sd} )    


elif (not instrumento is None) and (not index is None) :
  
  beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

index = index  - 1 
Z = X
Z[:,index] = z
beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
x_est  = Z @ beta_x
X[:,index] = x_est
beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
df = pd.DataFrame( {"coeficiente": beta , "coeficiente_IV" : beta_iv})  

return df

#para mostrar la dataframe con el tamaño de muestra, coeficientes y el error estándar
ols(X,Y)



###   para cuando el número de observaciones es 120: n=120

import random
import numpy as np
from scipy.stats import t   #para t - student 
import pandas as pd 

#se requiere una funcion con 5 variables aleatorias
x1 = np.random.rand(120)
x2 = np.random.rand(120)
x3 = np.random.rand(120)
x4 = np.random.rand(120)
x5 = np.random.rand(120)
e = np.random.normal(0,1,120)

#funcion con las 5 variables y su término de error
Y = 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 3.2*x5 + e

#matriz de la funcion Y
X = np.column_stack((np.ones(120),x1,x2,x3,x4,x5))

#coeficiientes estimados de la matriz X
beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

#indexing aleatorios para la matriz X
random.sample( range(120) , 120 )


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
df = pd.DataFrame( {"tamaño_de_muestra": n , "coeficiente": beta , "error_estándar" : sd} )    


elif (not instrumento is None) and (not index is None) :
  
  beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

index = index  - 1 
Z = X
Z[:,index] = z
beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
x_est  = Z @ beta_x
X[:,index] = x_est
beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
df = pd.DataFrame( {"coeficiente": beta , "coeficiente_IV" : beta_iv})  

return df

#para mostrar la dataframe con el tamaño de muestra, coeficientes y el error estándar
ols(X,Y)



###   para cuando el número de observaciones es 200: n=200

import random
import numpy as np
from scipy.stats import t   #para t - student 
import pandas as pd 

#se requiere una funcion con 5 variables aleatorias
x1 = np.random.rand(200)
x2 = np.random.rand(200)
x3 = np.random.rand(200)
x4 = np.random.rand(200)
x5 = np.random.rand(200)
e = np.random.normal(0,1,200)

#funcion con las 5 variables y su término de error
Y = 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 3.2*x5 + e

#matriz de la funcion Y
X = np.column_stack((np.ones(200),x1,x2,x3,x4,x5))

#coeficiientes estimados de la matriz X
beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

#indexing aleatorios para la matriz X
random.sample( range(200) , 200 )


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
df = pd.DataFrame( {"tamaño_de_muestra": n , "coeficiente": beta , "error_estándar" : sd} )    


elif (not instrumento is None) and (not index is None) :
  
  beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

index = index  - 1 
Z = X
Z[:,index] = z
beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
x_est  = Z @ beta_x
X[:,index] = x_est
beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
df = pd.DataFrame( {"coeficiente": beta , "coeficiente_IV" : beta_iv})  

return df

#para mostrar la dataframe con el tamaño de muestra, coeficientes y el error estándar
ols(X,Y)



###   para cuando el número de observaciones es 500: n=500

import random
import numpy as np
from scipy.stats import t   #para t - student 
import pandas as pd 

#se requiere una funcion con 5 variables aleatorias
x1 = np.random.rand(500)
x2 = np.random.rand(500)
x3 = np.random.rand(500)
x4 = np.random.rand(500)
x5 = np.random.rand(500)
e = np.random.normal(0,1,500)

#funcion con las 5 variables y su término de error
Y = 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 3.2*x5 + e

#matriz de la funcion Y
X = np.column_stack((np.ones(500),x1,x2,x3,x4,x5))

#coeficiientes estimados de la matriz X
beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

#indexing aleatorios para la matriz X
random.sample( range(500) , 500 )


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
df = pd.DataFrame( {"tamaño_de_muestra": n , "coeficiente": beta , "error_estándar" : sd} )    


elif (not instrumento is None) and (not index is None) :
  
  beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

index = index  - 1 
Z = X
Z[:,index] = z
beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
x_est  = Z @ beta_x
X[:,index] = x_est
beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
df = pd.DataFrame( {"coeficiente": beta , "coeficiente_IV" : beta_iv})  

return df

#para mostrar la dataframe con el tamaño de muestra, coeficientes y el error estándar
ols(X,Y)



###   para cuando el número de observaciones es 800: n=800

import random
import numpy as np
from scipy.stats import t   #para t - student 
import pandas as pd 

#se requiere una funcion con 5 variables aleatorias
x1 = np.random.rand(800)
x2 = np.random.rand(800)
x3 = np.random.rand(800)
x4 = np.random.rand(800)
x5 = np.random.rand(800)
e = np.random.normal(0,1,800)

#funcion con las 5 variables y su término de error
Y = 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 3.2*x5 + e

#matriz de la funcion Y
X = np.column_stack((np.ones(800),x1,x2,x3,x4,x5))

#coeficiientes estimados de la matriz X
beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

#indexing aleatorios para la matriz X
random.sample( range(800) , 800 )


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
df = pd.DataFrame( {"tamaño_de_muestra": n , "coeficiente": beta , "error_estándar" : sd} )    


elif (not instrumento is None) and (not index is None) :
  
  beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

index = index  - 1 
Z = X
Z[:,index] = z
beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
x_est  = Z @ beta_x
X[:,index] = x_est
beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
df = pd.DataFrame( {"coeficiente": beta , "coeficiente_IV" : beta_iv})  

return df

#para mostrar la dataframe con el tamaño de muestra, coeficientes y el error estándar
ols(X,Y)



###  para cuando el número de observaciones es 100: n=100

import random
import numpy as np
from scipy.stats import t   #para t - student 
import pandas as pd 

#se requiere una funcion con 5 variables aleatorias
x1 = np.random.rand(100)
x2 = np.random.rand(100)
x3 = np.random.rand(100)
x4 = np.random.rand(100)
x5 = np.random.rand(100)
e = np.random.normal(0,1,100)

#funcion con las 5 variables y su término de error
Y = 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 3.2*x5 + e

#matriz de la funcion Y
X = np.column_stack((np.ones(100),x1,x2,x3,x4,x5))

#coeficiientes estimados de la matriz X
beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

#indexing aleatorios para la matriz X
random.sample( range(100) , 100 )

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
df = pd.DataFrame( {"tamaño_de_muestra": n , "coeficiente": beta , "error_estándar" : sd} )    


elif (not instrumento is None) and (not index is None) :
  
  beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

index = index  - 1 
Z = X
Z[:,index] = z
beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
x_est  = Z @ beta_x
X[:,index] = x_est
beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
df = pd.DataFrame( {"coeficiente": beta , "coeficiente_IV" : beta_iv})  

return df

#para mostrar la dataframe con el tamaño de muestra, coeficientes y el error estándar
ols(X,Y)



###   para cuando el número de observaciones es 5000: n=5000

import random
import numpy as np
from scipy.stats import t   #para t - student 
import pandas as pd 

#se requiere una funcion con 5 variables aleatorias
x1 = np.random.rand(5000)
x2 = np.random.rand(5000)
x3 = np.random.rand(5000)
x4 = np.random.rand(5000)
x5 = np.random.rand(5000)
e = np.random.normal(0,1,5000)

#funcion con las 5 variables y su término de error
Y = 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 3.2*x5 + e

#matriz de la funcion Y
X = np.column_stack((np.ones(5000),x1,x2,x3,x4,x5))

#coeficiientes estimados de la matriz X
beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

#indexing aleatorios para la matriz X
random.sample( range(5000) , 5000 )


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
df = pd.DataFrame( {"tamaño_de_muestra": n , "coeficiente": beta , "error_estándar" : sd} )    


elif (not instrumento is None) and (not index is None) :
  
  beta = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )

index = index  - 1 
Z = X
Z[:,index] = z
beta_x = np.linalg.inv(Z.T @ Z) @ ((Z.T) @ X[:,index] ) 
x_est  = Z @ beta_x
X[:,index] = x_est
beta_iv = np.linalg.inv(X.T @ X) @ ((X.T) @ Y )
df = pd.DataFrame( {"coeficiente": beta , "coeficiente_IV" : beta_iv})  

return df

#para mostrar la dataframe con el tamaño de muestra, coeficientes y el error estándar
ols(X,Y)



######      Fin del ejrecicio 3       ######      Fin del ejrecicio 3       ######






######EJERCICIO 4

import numpy as np
import match
import pandas 

random.seed(175)
#Creando un proceso generador de datos con 8 variables (intercepto y 7 explicativas)
#Necesitamos 800 observaciones, por ello generaremos 800 números enteros.

#Entonces se tiene a continuación las siguientes 7 variables explicativas con distribución normal
X1 = np.random.rand(800)
X2 = np.random.rand(800)
X3 = np.random.rand(800)
X4 = np.random.rand(800)
X5 = np.random.rand(800)
X6 = np.random.rand(800)
X7 = np.random.rand(800)

#Seguido a ello, la creación del error bajo distribucion normal
u = np.random.normal(0, 1, 800)

#El modelo a estimar que tendremos es Y = b0 + b1*X1 + b2*X2 + b3*X3 + b4*X4 + b5*X5 + b6*X6 + b7*X7 +u
Y = 1 + 0.6*X1 + 0.5*X2 + 1.2*X3 + 2.5*X4 + 0.4*X5 + 0.8*X6 + 1.6*X7 +u
#Ahora, se juntarán todos los vectores generados anteriormente en una matriz

matriz = np.column_stack((np.ones(800), X1, X2, X3, X4, X5, X6, X7))
print (matriz)

#Ahora, podemos hallar los betas o también llamados coeficientes estimados, mediante una transposicion de la matriz
betas = np.linalg.inv(matriz.T @ matriz) @ ((matriz.T)@ Y)
print (betas)

#Ahora ya se tiene un vector que contiene a los betas o coeficientes
#Entonces, a continuación se estimará los errores estándar de cada beta

def statistics.stdev(betas)
betas = betas**1/2
print (betas)