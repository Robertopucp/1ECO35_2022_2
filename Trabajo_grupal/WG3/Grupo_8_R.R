################  Tarea 3 ############################
#Grupo8

library(dplyr) # librería de limpieza de datos
library(tidyr)# librería de limpieza de datos
library(readxl) # lobreria para subir archivos excel, csv

#creamos vector con 100 observaciones
vector = seq(100)

lapply(vector, function(min){min}) # resultado en formato lista
sapply(vector, function(min){min}) # vector canonico simple 
lapply(vector, function(max){max}) # resultado en formato lista
sapply(vector, function(max){max}) 

# Asignando el nombre de la función: standarize

reescalar <- function(i, min, max){
  ( i -  min ) / (max-min)
}

lapply(vector,reescalar,  min = min(vector), max = max(vector))
sapply(vector,reescalar,  min = min(vector), max = max(vector))

print (vector)

# creamos matrix
set.seed(50)

x1 <- runif(50) # distribución uniforme entre 0 y 1
x2 <- runif(50)
x3 <- runif(50)
x4 <- runif(50)

X <- cbind(matrix(100,50), x1,x2,x3,x4)

# matrix(100,50) vector columna de unos (500 observaciones)

apply(X, 2, max)
apply(X, 2, min)


apply(X, 2, function(i){
  ( i -  min(i) ) / max(i)-min(i)
} 

