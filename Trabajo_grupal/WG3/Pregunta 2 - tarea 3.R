
#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 2                                    # 
#                                                                              #
#------------------------------------------------------------------------------#

#Importamos las librerías necesarias

library(dplyr) 
library(tidyr)
library(readxl) 


# Creamos el vector (v) con 100 observaciones

v = seq(100)


#### Definimos la función de escalamiento para el vector

escalar <- function(i,a,b) {
  (i-a)/(b-a)
  
}



#### Obtenemos el vector reescalado usando sapply

sapply(v,escalar,  a=min(v) ,b= max(v))




#Creamos la matriz (m) de dimensiones 100 x 50

m <- array(sample(1:100, 50, replace=T), c(100,50))




# Creamos la función escalar usando apply, lo cual nos dará como resultado la matriz reescalada

apply(m, 2, function(i){
  ( i -  min(i) ) / (max(i)-min(i))
} )
