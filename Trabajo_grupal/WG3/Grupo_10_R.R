#----------------------------------------
#               Problema 2
#----------------------------------------


#Creamos un vector "a" con 100 observaciones
#--------------------------------------------
vector <- seq(101,200)
print(vector)

#el minimo y maximo de este vector seria
#----------------------------------------
min(vector)
max(vector)

#Creamos una matriz de 100x50
#------------------------------
M <- matrix( c(1,2,3,4,5,6,7,8,9,10), nrow = 100, ncol = 50)
print(M)


#Reescalamos el vector con la funcion dada
#----------------------------------------

# 1era forma
sapply(vector, function(i){
  out = (i - min(i))/(max(i)-min(i))
  return(out)
} )

# 2da forma
rescale <- function(X, min, max){
  (X - min(X))/(max(X)-min(X))
}

sapply(vector,rescale,  max = max(vector), min = min(vector))


#Reescalamos la matriz con la funcion dada
#----------------------------------------
apply(M, MARGIN = 2, FUN = function(X) (X - min(X))/(max(X)-min(X)))





