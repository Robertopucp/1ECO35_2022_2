" Ejercicio 1"
# -------------------------------------------------------

#Creamos un vector cuyos datos estén entre 0 y 500 y contenga 20 datos.

x <- runif(20,0,500) # runif( n: cantidad de elementos, inicio , final)
print(x)

# Elaboramos una estructura If statement para la siguiente función
# y aplicamos condición a cada uno de los elemento

calculator <- function(x){
  x <- x 
  
  if ( x>0 & x<=100) {
    return( cat( "F(x)=" ,x ^ (1/2) ) )
  } else if ( x>100 & x<=300 ) {
    
    return( cat( "F(X)=", x - 5 ) )
    
  } else if (x>300) {
    
    return(print("F(X)=50"))
    
  }
  
}

calculator( 64 )

" Ejercicio 2"
# -------------------------------------------------------

# creamos un vector "v" de 100 observaciones
v <- array(1:100)
print(v)

min(v) #para ir observando el mínimo de dicho vector
max(v)

#creamos una matriz "M"
M <- matrix( c(1,2,3,4,5,6,7,8,9,10), nrow = 100, ncol=50) #indicamos que sea una matriz de 100x50.En este caso, tendrá valores del 1 al 10
print(M)

dim(M) #comprobamos que M sea una matriz de 100x50
typeof(v)
typeof(M) #observamos el tipo

#para reescalar los datos de las columnas de la matriz, queremos ver sus mínimos y máximos por columna
X <- min(M, axis=0) #axis=0 pq queremos observar por columnas
Y <- max(M, axis=0)
print(X)
print(Y)

#reescalamos vector y matriz
# No corre el código si detecta un error 
tryCatch((v-min(v)) / max(v)-min(v),
         
         error = function(e)  {
           
           cat("El argumento  deberia ser un vector")
           
         }
)

tryCatch( (M-X) / Y-X, 
          
          error = function(e)  {
            
            cat("El argumento  deberia ser una matriz")
            
          }
)

#Pregunta 3

#sample(seq(),10000)
set.seed(10000)  # permite que los numeros aleatorios no cambien al correr los códigos

x10 <- runif(10)
x210 <- runif(10)
x310 <- runif(10)
x410 <- runif(10)
e <- rnorm(10)

#Isntrumento 

z <- rnorm(10)

# Poblacional regression (Data Generating Process GDP)

Y <- 1 + 0.8*x10 + 1.2*x210 + 0.5*x310 + 1.5*x410 + e
X <- cbind(matrix(1,10), x1,x2,x3,x4)

ols <- function(M, Y , standar = T, Pvalue = T , instrumento = NULL, index = NULL){
  
  
  if (standar & Pvalue & is.null(instrumento) & is.null(index)){
    
    beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
    
    y_est <- M %*% beta  ## Y estimado 
    n <- dim(M)[1]  # filas
    k <- dim(M)[2] - 1  # varaibles sin contar el intercepto}
    df <- n- k ## grados de libertad
    sigma <- sum(sapply(Y - y_est , function(x) x ^ 2))/ df 
    
    Var <- sigma*solve(t(M) %*% M)
    sd <- sapply(diag(Var) , sqrt) ## raíz cuadrado a los datos de la diagonal principal de Var
    
    t.est <- abs(beta/sd)
    pvalue <-2*pt(t.est, df = df, lower.tail = FALSE) ## pt : t - student densidad
    
    table <- data.frame(OLS = beta,  
                        standar.error = sd, P.value = pvalue)
    
    
  }
  
  
  if ( !is.null(instrumento) & !is.null(index) ){
    
    beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
    
    index <- index + 1
    
    Z <- X
    Z[,index] <- z  ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
    
    beta_x <- solve(t(Z) %*% Z) %*% (t(Z) %*% X[,index])
    
    x_est <- Z %*% beta_x 
    X[,index] <- x_est ## se reemplaza la variable x endógena por su estimado 
    
    beta_iv <- solve(t(X) %*% X) %*% (t(X) %*% Y)
    
    table <- data.frame(OLS= beta,  
                        OLS.IV = beta_iv)
    
  }
  
  return(table)
}


ols(X,Y)

ols(X,Y,instrumento = z, index = 1)

Uno<-rbind(ols(X,Y))

x150 <- runif(50)
x250 <- runif(50)
x350 <- runif(50)
x450 <- runif(50)
e <- rnorm(50)

#Isntrumento 

z <- rnorm(50)

# Poblacional regression (Data Generating Process GDP)

Y <- 1 + 0.8*x150 + 1.2*x250 + 0.5*x350 + 1.5*x450 + e
X <- cbind(matrix(1,50), x1,x2,x3,x4)

ols <- function(M, Y , standar = T, Pvalue = T , instrumento = NULL, index = NULL){
  
  
  if (standar & Pvalue & is.null(instrumento) & is.null(index)){
    
    beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
    
    y_est <- M %*% beta  ## Y estimado 
    n <- dim(M)[1]  # filas
    k <- dim(M)[2] - 1  # varaibles sin contar el intercepto}
    df <- n- k ## grados de libertad
    sigma <- sum(sapply(Y - y_est , function(x) x ^ 2))/ df 
    
    Var <- sigma*solve(t(M) %*% M)
    sd <- sapply(diag(Var) , sqrt) ## raíz cuadrado a los datos de la diagonal principal de Var
    
    t.est <- abs(beta/sd)
    pvalue <-2*pt(t.est, df = df, lower.tail = FALSE) ## pt : t - student densidad
    
    table <- data.frame(OLS = beta,  
                        standar.error = sd, P.value = pvalue)
    
    
  }
  
  
  if ( !is.null(instrumento) & !is.null(index) ){
    
    beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
    
    index <- index + 1
    
    Z <- X
    Z[,index] <- z  ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
    
    beta_x <- solve(t(Z) %*% Z) %*% (t(Z) %*% X[,index])
    
    x_est <- Z %*% beta_x 
    X[,index] <- x_est ## se reemplaza la variable x endógena por su estimado 
    
    beta_iv <- solve(t(X) %*% X) %*% (t(X) %*% Y)
    
    table <- data.frame(OLS= beta,  
                        OLS.IV = beta_iv)
    
  }
  
  return(table)
}


ols(X,Y)

ols(X,Y,instrumento = z, index = 1)
Dos <-rbind(ols(X,Y))

x100 <- runif(100)
x2100 <- runif(100)
x3100 <- runif(100)
x4100 <- runif(100)
e <- rnorm(100)

#Isntrumento 

z <- rnorm(100)

# Poblacional regression (Data Generating Process GDP)

Y <- 1 + 0.8*x100 + 1.2*x2100 + 0.5*x3100 + 1.5*x4100 + e
X <- cbind(matrix(1,100), x1,x2,x3,x4)

ols <- function(M, Y , standar = T, Pvalue = T , instrumento = NULL, index = NULL){
  
  
  if (standar & Pvalue & is.null(instrumento) & is.null(index)){
    
    beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
    
    y_est <- M %*% beta  ## Y estimado 
    n <- dim(M)[1]  # filas
    k <- dim(M)[2] - 1  # varaibles sin contar el intercepto}
    df <- n- k ## grados de libertad
    sigma <- sum(sapply(Y - y_est , function(x) x ^ 2))/ df 
    
    Var <- sigma*solve(t(M) %*% M)
    sd <- sapply(diag(Var) , sqrt) ## raíz cuadrado a los datos de la diagonal principal de Var
    
    t.est <- abs(beta/sd)
    pvalue <-2*pt(t.est, df = df, lower.tail = FALSE) ## pt : t - student densidad
    
    table <- data.frame(OLS = beta,  
                        standar.error = sd, P.value = pvalue)
    
    
  }
  
  
  if ( !is.null(instrumento) & !is.null(index) ){
    
    beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
    
    index <- index + 1
    
    Z <- X
    Z[,index] <- z  ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
    
    beta_x <- solve(t(Z) %*% Z) %*% (t(Z) %*% X[,index])
    
    x_est <- Z %*% beta_x 
    X[,index] <- x_est ## se reemplaza la variable x endógena por su estimado 
    
    beta_iv <- solve(t(X) %*% X) %*% (t(X) %*% Y)
    
    table <- data.frame(OLS= beta,  
                        OLS.IV = beta_iv)
    
  }
  
  return(table)
}


ols(X,Y)

ols(X,Y,instrumento = z, index = 1)
Tres <-rbind(ols(X,Y))

x1500 <- runif(500)
x2500 <- runif(500)
x3500 <- runif(500)
x4500 <- runif(500)
e <- rnorm(500)

#Isntrumento 

z <- rnorm(500)

# Poblacional regression (Data Generating Process GDP)

Y <- 1 + 0.8*x1500 + 1.2*x2500 + 0.5*x3500 + 1.5*x4500 + e
X <- cbind(matrix(1,500), x1,x2,x3,x4)

ols <- function(M, Y , standar = T, Pvalue = T , instrumento = NULL, index = NULL){
  
  
  if (standar & Pvalue & is.null(instrumento) & is.null(index)){
    
    beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
    
    y_est <- M %*% beta  ## Y estimado 
    n <- dim(M)[1]  # filas
    k <- dim(M)[2] - 1  # varaibles sin contar el intercepto}
    df <- n- k ## grados de libertad
    sigma <- sum(sapply(Y - y_est , function(x) x ^ 2))/ df 
    
    Var <- sigma*solve(t(M) %*% M)
    sd <- sapply(diag(Var) , sqrt) ## raíz cuadrado a los datos de la diagonal principal de Var
    
    t.est <- abs(beta/sd)
    pvalue <-2*pt(t.est, df = df, lower.tail = FALSE) ## pt : t - student densidad
    
    table <- data.frame(OLS = beta,  
                        standar.error = sd, P.value = pvalue)
    
    
  }
  
  
  if ( !is.null(instrumento) & !is.null(index) ){
    
    beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
    
    index <- index + 1
    
    Z <- X
    Z[,index] <- z  ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
    
    beta_x <- solve(t(Z) %*% Z) %*% (t(Z) %*% X[,index])
    
    x_est <- Z %*% beta_x 
    X[,index] <- x_est ## se reemplaza la variable x endógena por su estimado 
    
    beta_iv <- solve(t(X) %*% X) %*% (t(X) %*% Y)
    
    table <- data.frame(OLS= beta,  
                        OLS.IV = beta_iv)
    
  }
  
  return(table)
}


ols(X,Y)

ols(X,Y,instrumento = z, index = 1)

Cuatro <-rbind(ols(X,Y))

#Cuadro de resultados:
Cinco<-rbind(Uno,Dos,Tres,Cuatro)
Cinco

#Se pueden observar los diferentes valores para cada diferente cantidad de muestra, con los coeficientes y errores estándar.

# PREGUNTA 4

set.seed(800)  # Fijamos una semilla para no cambiar los números aleatorios
# Declaramos las variables aleatorias
x1 <- runif(800)
x2 <- runif(800)
x3 <- runif(800)
x4 <- runif(800)
x5 <- runif(800)
x6 <- runif(800)
x7 <- runif(800)
e <- rnorm(800)

# Definimos el instrumento 
z <- rnorm(800)
Y <- 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 +1.5*x5 +1.5*x6 +1.5*x7+ e
X <- cbind(matrix(1,800), x1,x2,x3,x4,x5,x6,x7)

ols <- function(M, Y , standar = T, Pvalue = T , instrumento = NULL, index = NULL){
  
  
  if (standar & Pvalue & is.null(instrumento) & is.null(index)){
    
    beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
    
    y_est <- M %*% beta  # Y estimado 
    n <- dim(M)[1]  # Filas
    k <- dim(M)[2] - 1  # Variables sin contar el intercepto
    df <- n- k # grados de libertad
    sigma <- sum(sapply(Y - y_est , function(x) x ^ 2))/ df 
    
    Var <- sigma*solve(t(M) %*% M)
    sd <- sapply(diag(Var) , sqrt) # Raiz cuadrada a los datos de la diagonal principal de Var
    root <- sapply(Y - y_est , function(x) x ^ 2)
    liminf <- beta -1.96*sd # Limite inferior
    limsup <- beta +1.96*sd # Limite superior
    t.est <- abs(beta/sd)
    pvalue <-2*pt(t.est, df = df, lower.tail = FALSE) # pt : t - student densidad
    
    # Formamos la tabla con los resultados requeridos
    table <- data.frame(OLS = beta,  
                        standar.error = sd, P.value = pvalue, Lim.Inf=liminf, Limf.Sup= limsup)
    
  }
  
  
  if ( !is.null(instrumento) & !is.null(index) ){
    
    beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
    
    index <- index + 1
    
    Z <- X
    Z[,index] <- z  ## reemplazamos la variable endógena por el instrumento en la matrix de covariables
    
    beta_x <- solve(t(Z) %*% Z) %*% (t(Z) %*% X[,index])
    
    x_est <- Z %*% beta_x 
    X[,index] <- x_est ## se reemplaza la variable x endógena por su estimado 
    
    beta_iv <- solve(t(X) %*% X) %*% (t(X) %*% Y)
    
    table <- data.frame(OLS= beta,  
                        OLS.IV = beta_iv)
    
  }
  
  return(table)
}

# Corremos la funcion
ols(X,Y)

