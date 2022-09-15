################  laboratorio 2 ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Roberto Mendoza 

library(dplyr) # librería de limpieza de datos
library(tidyr)# librería de limpieza de datos
library(readxl) # lobreria para subir archivos excel, csv
library(sandwich)
## Loop replacement

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab3") ) # set directorio


## Equivalent *args de Python en R 

caso1 <- function(...) return(sum(...))

caso1(2,4,5)



caso2 <- function(...) {
  
  return(prod(...))
  
  
}  

caso2(sample(1:50, size = 5))

str(sandwich)
args(lapply)
##################################################################################

"Lapply and Sapply"

vector = seq(100)

lapply(vector, function(square) {square^2}) # resultado en formato lista
sapply(vector, function(square) {square^2}) # vector canonico simple 



"Función 1"

lapply(vector, function(x){
  out = x*(1/3) - 0.5*x
  return(out)
} ) # resultado en formato lista


sapply(vector, function(x){
  out = x*(1/3) - 0.5*x
  return(out)
} ) # resultado en formato vector


"Función 2, de estandarización"


lapply(vector, function(i, mean, sd){
  ( i -  mean ) / sd
} , mean = mean(vector), sd = sd(vector))


# Asignando el nombre de la función: standarize

standarize <- function(i, mean, sd){
  ( i -  mean ) / sd
}


lapply(vector,standarize,  mean = mean(vector), sd = sd(vector))
sapply(vector,standarize,  mean = mean(vector), sd = sd(vector))

# lapply(x, FUN, ...) ... : argumentos adicionales para la función



"Función 3"

lapply(vector, function(i){
  if (i < 50){
    
    out = 1
    
  } else {
    
    out = NA
    
    
  }
  return(out)
  
})

sapply(vector, function(i){
  if (i < 50){
    
    out = 1
    
  } else {
    
    out = NA
    
    
  }
  return(out)
  
})




" Loop replacement in Matrix "

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


"Estandarizar una matriz "

apply(X, 2, function(i){
  ( i -  mean(i) ) / sd(i)
} )

# 2 se aplica la función a los elementos de cada columna 


cps2012  <- get(load("../data/cps2012.Rdata"))  # load R dataset format, extensión Rdata

# Tomamos la varianza de cada columna

apply(cps2012, 2, var) # tomando la varianza por columna (Margin:2)
  
X <- cps2012[ , which(apply(cps2012, 2, var) != 0)] # Se exlucye las columnas constantes

demean<- function (x){ x- mean(x)}
X<- apply(X, 2, demean)


# Conocer los elementos de una función creada o libreria
args(demean)
args(sandwich)
















