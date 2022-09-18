#############################
##### PREGUNTA 2 R #####

library(dplyr) # librería de limpieza de datos
library(tidyr)# librería de limpieza de datos
library(readxl) # lobreria para subir archivos excel, csv
library(sandwich)

set.seed(500)

# Cremos el vector que cuenta con  100 observaciones
vector = seed(100)

# Fijamos el minimo y maximo de nuestro vector
minimo = min(vector)
maximo = max(vector)

# Definimos la funcion X
def function(x):
  
# Realizamos la reescala para esa funcion.     
  escalar = (x-min(x))/(max(x)-min(x))    
return escalar

list( map( lambda x: function(x) , vector)   )

# Creamos las variables hasta X4, de modo que todas tienen distribución uniforme

set.seed(756)

x1 <- runif(500) # distribución uniforme entre 0 y 1
x2 <- runif(500)
x3 <- runif(500)
x4 <- runif(500)

X <- cbind(matrix(1,500), x1,x2,x3,x4)

# matrix(1,500) vector columna de unos (500 observaciones)

apply(X, 2, mean)  # MARGIN == 2 para columnas (columns)
apply(X, 1, mean)  # MARGIN == 1 para filas (rows)


apply(X, 1, sd)  # MARGIN == 1 para filas

apply(X, 2, min)

apply(X, 1, max)
