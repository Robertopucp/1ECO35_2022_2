
###########################################  GRUPO 1 ############################################

#####################################  Miembros del grupo  ######################################

# 20163197, Enrique Alfonso Pazos 
# 20191894, Ilenia Ttito
# 20151595, Rodrigo Ramos
# 20193469, Luis Eguzquiza 
# 20163377, Jean Niño de Guzmán


##########################################  Pregunta 1 ##########################################

#Creaci?n del Vector con n?meros aleatorios 

Vector<-(sample(0:500, 20))  #Se indica que se cree un vector con 20 n?meros aleatorios entre 0 y 500

sort(Vector)   #Se ordena el Vector para que los valores vayan de menor a mayor.

#Creaci?n de If Statement
#Se indica que cada valor del Vector se reemplazar? dependiendo de en que rango se encuentre.
for (i in sort(Vector)) {                
  
  #Se determina el valor que tomar? cada valor del Vector acorde al rango indicado el la tarea.
  #Y una vez obtenido el resultado, se imprimir? el resultado que cada valor obtuvo despue?s de pasar por el If Statement.
  #Rango de 0 a 100
  if(i >= 0 & i < 100) 
    #Se eleva a la 0.5
    print(i ^ 0.5 )
  #Rango de 10 a 300
  else if(i > 100 & i <= 300)
    #Se resta 5   
    print(i - 5 ) 
  #Rango de 300 a m?s
  else if(i > 300  )
    #Se reemplaza con 50  
    print(50) 
}

##########################################  Pregunta 2 ##########################################

escalonar <- function(x) {
  # La primera condición es para establecer que, en caso no ser una matriz, no continuará el proceso 
  # y mostrará un mensaje de error.
  if (! is.matrix(x)) stop("No es un vector o matriz") 
  
  # Ahora, pongo la segunda condición, en la que indicaré los criterios para que pase la matriz, 
  # Me voy a valer del número de filas como condición: número de filas = 100
  else if (nrow(x)==100) {
    # Extraigo el mínimo y máximo valor de cada columna. Esto me genera un vector con el máximo y otro con el mínimo 
    # valor de cada columna; max y min son esos vectores respectivamente.
    min <- apply(x, 2, min) #Margin = 2 significa que tomará las columnas como criterio.
    max <- apply(x, 2, max)
    
    # Hago una iteración con el número de filas de la matriz sin la necesidad de crear una lista previamente.
    for (i in 1:4) {
      # Extraeré cada fila de la matriz de acuerdo al valor que tome i en cada iteración 
      # y hago el proceso de escalonamiento. El proceso lo "reescribo" sobre la misma matriz.
      x[i,]<- (x[i,]- min)/(max-min)
    }
  }
  # En caso no pasar por las otras dos condiciones, ingresa aquí el vector. 
  else {
    # Como estoy trabajando sobre un vector, extraigo el mínimo y máximo valor de cada fila.
    min <- apply(x, 1, min) #Margin = 1 significa que tomará la fila como criterio.
    max <- apply(x, 1, max)
    # Hago el proceso de escalonamiento y lo "reescribo" sobre la misma matriz.
    x <- (x- min)/(max-min)
  }
  return(x)}

# Hacemos las pruebas tanto para una matriz como para un vector:
x <- matrix(rnorm(500), 100, 50) 
escalonar (x)


z <- matrix(rnorm(100), 1, 100)
escalonar (z)


##########################################  Pregunta 3 ##########################################

# Generamos los valores aleatorios con una poblacion de 10000
x1 <- runif(10000, 0, 1)
x2 <- runif(10000, 0, 1)
x3 <- runif(10000, 0, 1)
x4 <- runif(10000, 0, 1)
x5 <- runif(10000, 0, 1)
e <- rnorm(10000,0,1)

#Se crea una lista con los diferentes tamanios de muestra 
numMuestras <- list(10, 50, 80, 120, 200, 500, 800, 100, 5000)


#Creamos un bucle, para que itere el codigo con los diferentes tamanos de muestra 

DF <- list ()
#Se pone un for para que itere cada vez que pase con una cantidad diferente de muestra
for (i in 1:length(numMuestras)){
  
  k=numMuestras[[i]]
  
  #Especificamos un k=i que contenga el n�mero de tama�os de cada muestra     
  x1_m = sample(x1, k=i)    
  x2_m = sample(x2, k=i)    
  x3_m = sample(x3, k=i)    
  x4_m = sample(x4, k=i)  
  
  #Se plantea un data frame para cada valor de la muestra
  df<-data.frame(dplyr::sample_n(
    data.frame(
      bind_cols(x1,x2,x3,x4))%>%
      setNames(c("x1","x2","x3","x4")),
    size=k))
  DF[[i]] <- df%>%
    mutate(muesta=k)
  
  Y <- 1 + 0.8*x1_m + 1.2*x2_m + 0.5*x3_m + 1.5*x4_m + e
  
  #Plantemos el modelo OLS (MCO)
  ols <- function(M, Y, instrumento = NULL, index = NULL){
    
    if (standar & is.null(instrumento) & is.null(index)){
      beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
      y_est <- M %*% beta  ## Y estimado 
      n <- dim(M)[1]  # filas
      k <- dim(M)[2] - 1  # variables sin contar el intercepto
    }
    
    if ( !is.null(instrumento) & !is.null(index) ){
      beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
      index <- index + 1
    }
  }
}

DF_all<-map_df(DF, bind_rows)
rm(df, DF, k, i)
  

##########################################  Pregunta 4 ##########################################

# Creamos un proceso generador de datos con 8 variables y 800 observaciones.
set.seed(757) #Semilla

x1 <- runif(800)
x2 <- runif(800) 
x3 <- runif(800) 
x4 <- runif(800) 
x5 <- runif(800)
x6 <- runif(800)
x7 <- runif(800)
e <- rnorm(800,0,1)

#Iteraci?n de generaci?n de proceso

Y <- 1 + 0.7*x1 + 1.1*x2 + 0.9*x3 + 1.5*x4 + 0.6*x5 + 0.3*x6 + 0.1*x7 + e

X <- cbind(matrix(1,800), x1,x2,x3,x4,x5,x6,x7)
head(X)


MCO <- function(Y, X,Iis.null,His.null) {
  # Calculcar beta y las dimensiones de n y k
  # dependiendo de si tiene o no intercepto
  if (Iis.null) {
    beta <- solve(t(X) %*% X) %*% (t(X) %*% Y)
    beta
    n <- X.shape[0]
    k <- X.shape[1] - 1
  } else if (! Iis.null) {
    beta <- solve(t(X) %*% X) %*% (t(X) %*% Y)
    beta
    n <- X.shape[0]
    k <- X.shape[1]
  }
  return(beta)
  
  # Calculo de Y estimado, SCR, SCT, Sigma(s2)
  Yhat = X %*% beta
  Yerror = Y-Yhat
  Yerror2 = '^'(Yerror, 2)
  
  SCR =(t(Yerror) %*% Yerror)
  Ydesv = Y - (matrix(1,n)*mean(Y))
  SCT =(t(Ydesv) %*% Ydesv)
  nk=n-k
  s2= SCR/nk
  
}
# Calculo de Matriz de Varianzas y Covarianzas dependiendo
# si considero ajuste de White o no
if (His.null) {
  MatVarCov <- (solve(t(X) %*% X))*s2
} else if(! His.null) {
  V <- np.diag(Yerror2)
  MatVarCov <- (solve(t(X) %*% X) %*% (t(X) %*% V %*% X) %*% solve(t(X) %*% X))
}



##error est?ndar
sd <- sapply(diag(MatVarCov) , sqrt)

#Limite superior
limsup <- beta + 1.96*(sd)

#L?mite inferior
liminf  <- beta - 1.96*(sd)

#p-value
t_est <- abs(beta/sd)
pvalue <- 2 * pt(t.est, df = nk, lower.tail = FALSE)

#R-cuadrado
R2 <- 1-(SCR/SCT)
Root_MSE <- math.sqrt((t(Yerror) %*% Yerror)/800)
dataf <- data.frame( "Betas"= beta, "standar_error" = sd, "Pvalue" = pvalue)

return (dataf)

print(MCO(Y, X))


