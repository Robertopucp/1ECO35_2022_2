#EJERCICIO 2 R


set.seed(123)

#Creamos un vector con 100 observaciones aleatorias
v1 <- c(runif(100, min=0, max=20))

#Creamos la matriz 100x50, con numeros aleatorios
M1 <- matrix(runif(5000,min=0, max=10), nrow= 100, ncol= 50)

#Ahora vemos la dimensión de la matriz. En efecto, tiene 100 filas y 50 columnas
dim(M1)

#Creo la función primero para luego aplicar el comando apply. 

calculator_scalar <- function( v, M, n){
  if(! is.double(v)) stop("v must be a double")
  if(! is.double(M)) stop("M must be a double")}

#Definimos los componentes de la función
y <- v[n] 
z <- M[,n]
m3 <- min(z)
m4 <- max(z)

#Defino mi funcion= funcion_1
funcion_1= y-m3/ m4-m3

#Con la función definida aplico el comando Apply. Dicho comando 
#me permitira aplicar la funcion a cada columna(por ello coloco 2)

apply(X, 2, funcion_1)
sapply(X, 2, funcion_1)

