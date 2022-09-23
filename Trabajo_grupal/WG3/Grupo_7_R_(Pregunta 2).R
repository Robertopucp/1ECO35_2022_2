# Pregunta 2

# creando vector y matriz 
vector = seq(100)
matriz = matrix(as.integer(sample(10000,replace=F)),nrow = 100,ncol = 50)

# creando función reescalar
reescalar <- function(i, min, max){
  ( i -  min ) / ( max - min )
}


" Loop replacement in Vector "
# aplicando función reescalar al vector
sapply(vector, reescalar, min = min(vector), max = max(vector) )


" Loop replacement in Matrix "
# aplicando función reescalar a la matriz
apply(matriz, MARGIN=2, FUN=reescalar, min = min(vector), max = max(vector)  )  # MARGIN=2, la función se aplica por columna



