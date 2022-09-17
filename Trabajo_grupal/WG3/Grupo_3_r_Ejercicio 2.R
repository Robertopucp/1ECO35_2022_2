# Loop Replacement y keywords
# Tarea en Python y en R
# EJERCICIO 2
set.seed(45)

# Creamos el vector

xvector <- c(sample(100,replace=F))

# Creamos la matriz
xmatrix = matrix(as.integer(sample(10000,replace=F)),nrow = 100,ncol = 50)

# Creamos la función escalar
escalar <- function(x,y) {
  if (is.vector(x)) return((x-min(x))/(max(x)-min(x)))
  else if (is.matrix(x)) return((x-min(x[,y]))/(max(x[,y])-min(x[,y])))
  else return("Base de datos incorrecta")
}

# Aplicamos "lapply" para realizar la operación y tener como respuesta una lista
lapply(xvector,escalar)
lapply(xmatrix, escalar)

# Aplicamos "sapply" para realizar la operación y tener como respuesta un vector

sapply(xvector,escalar)
sapply(xmatrix, escalar)

# Comparamos con resultado hallado en la WG1
escalar(xvector)
escalar(xmatrix) 

