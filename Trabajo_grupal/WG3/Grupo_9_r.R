####################Ej. 2####################
#Crear una función para reescalar los datos de un vector y de las columnas de una matriz. 
#ajustar los valores de cada columna. Use la función sapply , apply en R

#generar vector (debe contar con 100 observaciones)
v <- matrix(sample.int(100,size=100,replace=TRUE),nrow=100,ncol=1)


#generar matrix (100 x 50)
M<-matrix(sample.int(100,size=500,replace=TRUE),nrow=100,ncol=50)


#escalar el vector:

apply(v, 2, function(i){
  round(( i -  min(i) ) / (max(i)-min(i)),2) #round para redondear a 2 decimales
} )

sapply(v,function(i){ 
  out=round((i -  min(v)) / (max(v)-min(v)),2) #round para redondear a 2 decimales
  return(out)
})

#escalar la matrix:

apply(M, 2, function(i){
  round(( i -  min(i) ) / (max(i)-min(i)),2) #round para redondear a 2 decimales
} )





