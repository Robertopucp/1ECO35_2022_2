set.seed(1000) #Establecemos una semilla laeatoria 
matriz <- runif(100) #Primero definimos el vector 
a <- min(matriz) #Hallamos el minimo
b <- max(matriz) #Hallamos el maximo
#Definimos la función de reescalación relacionando un x con el mín y max
reescalación <- function(x) {
  (x-a)/(b-a)
}
#Aplicamos la función "reescalación" a cada componente del vector
respuesta1 <- sapply (matriz, reescalación)
print(respuesta1)

matriz2 <- matrix( runif(5000), nrow=100) #Primero definimos la matriz 100x50

#Definimos la función de reescalación relacionando un x con el mín y max de cada x
reescalación2 <- function(x) {
  (x-min(x))/(max(x)-min(x))
} 

#Aplicamos la función "reescalación2" a cada componente de cada columna de la matriz
respuesta2 <- apply(matriz2, MARGIN = 2, reescalación2)
print(respuesta2)