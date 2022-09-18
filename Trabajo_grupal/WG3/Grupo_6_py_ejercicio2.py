

import numpy as np

np.random.seed(500)
np.random.rand(100)

# Cremos el vector que cuenta con  100 observaciones
vector = np.arange(100)

# Fijamos el minimo y maximo de nuestro vector
minimo = np.min(vector)
maximo = np.max(vector)

# Definimos la funcion X
def function(x):

# Realizamos la reescala para esa funcion.     
    escalar = (x-min(x))/(max(x)-min(x))    
    return escalar

list( map( lambda x: function(x) , vector)   )

# Creamos las variables hasta X4, de modo que todas tienen distribución uniforme
np.random.seed(500)
x1 = np.random.rand(100) # uniform distribution  [0,1]
x2 = np.random.rand(100) # uniform distribution [0,1]
x3 = np.random.rand(100) # uniform distribution [0,1]
x4 = np.random.rand(100) # uniform distribution [0,1]

X = np.column_stack((np.ones(100),x1,x2,x3,x4))


np.min(X, axis=0)   # axis = 0 (se aplica por columnas)
np.max(X, axis=0)

#Se aplicará la funcion lambda para cada componente de la columna de la matriz
np.apply_along_axis(lambda x: (x-min(x))/(max(x)-min(x)),0, X)





