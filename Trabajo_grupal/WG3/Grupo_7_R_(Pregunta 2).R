# Pregunta 2

# creando vector y matriz 
vector = seq(100)
matriz = matrix(as.integer(sample(10000,replace=F)),nrow = 100,ncol = 50)

# creando funci?n reescalar
reescalar <- function(i, min, max){
  ( i -  min ) / ( max - min )
}


" Loop replacement in Vector "
# aplicando funci?n reescalar al vector
sapply(vector, reescalar, min = min(vector), max = max(vector) )


" Loop replacement in Matrix "
# aplicando funci?n reescalar a la matriz
apply(matriz, MARGIN=2, FUN=reescalar, min = min(vector), max = max(vector)  )  # MARGIN=2, la funci?n se aplica por columna



