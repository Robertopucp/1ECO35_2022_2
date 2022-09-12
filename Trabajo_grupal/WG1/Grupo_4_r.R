###############################################################################
#                                                                             #
#                              TAREA 1 - GRUPO 4                              #
#                                                                             #
###############################################################################




#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 1                                    # 
#                                                                              #
#------------------------------------------------------------------------------#



#Creamos un vector de 20 elementos, cuyos datos vayan del 0 al 500

x <- seq(from = 0, to = 500, by = 20)


#Construimos el primer if statement (w), que sacará la raíz cuadrada a cada uno de los elementos que cumplan con la condición de estar entre 0 y 100.

w <- sqrt(x)

if (w > 1 & w < 100) {
  print("verdadero")
} else {
  print( "falso")
  
}


#Construimos el segundo if statement (p), que le restará 5 a cada uno de los elementos que cumplan con la condición de estar entre 100 y 300.

p <- x-5

if (p > 100 & p <= 300){
  print("verdadero")
} else {
  print( "falso")
  
}

#Construimos el último if statement (q), que igualará a 50 a cada uno de los elementos que cumplan con la condición de ser mayores a 300.

q <- 50

if (q > 300){
  print("verdadero")
} else {
  print( "falso")
  
}




#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 2                                    # 
#                                                                              #
#------------------------------------------------------------------------------#


# Creamos el vector (v) con 100 observaciones

v <- array(sample(1:100, 50, replace=T), c(100,1))



#Creamos la matriz (m) de dimensiones 100 x 50

m <- array(sample(1:100, 50, replace=T), c(100,50))




# Creamos la función escalar que nos dará un mensaje de error si el objeto introducido no es una matriz o vector
# Si el objeto introducido en la función es vector o matriz, la función calculará el escalar usando los valores mínimos y máximos de cada columna y reescalará la matriz o vector de acuerdo a dichos valores.

escalar <- function(M) {
  
  if(! is.array(M)) stop("x debe ser una matriz o vector")
  
  a <- apply(M,2, min)
  b <- apply(M,2, max)
  e <- (M-b)/(a-b)
  
  result= M*e
  
  
  return(result)
  
}
  

#Aplicamos la función a nuestro vector para que nos devuelva el vector reajustado por el escalar.

print(escalar(v))


#Aplicamos la función a nuestra matriz para que nos devuelva la matriz reajustada por el escalar.

print(escalar(m))




#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 3                                    # 
#                                                                              #
#------------------------------------------------------------------------------#

set.seed(756)


x1 <- runif(10000)
x2 <- runif(10000)
x3 <- runif(10000)
x4 <- runif(10000)
x5 <- runif(10000)
e <- rnorm(10000)

# Poblacional regression 

Y <- 1 + 0.7*x1 + 1.6*x2 + 0.3*x3 + 1.8*x4 + e

X <- cbind(matrix(1,1000), x1,x2,x3,x4)
head(X)

#inv(X) or solve (X)

beta <- solve(t(X) %*% X) %*% (t(X) %*% Y)
beta

m <- c(10,50,80,120,200,500,800)





#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 4                                    # 
#                                                                              #
#------------------------------------------------------------------------------#


set.seed(756)  # Porque permite que los numeros aleatorios no cambien al correr los códigos
x1 <- runif(800)
x2 <- runif(800)
x3 <- runif(800)
x4 <- runif(800)
x5 <- runif(800)
x6 <- runif(800)
x7 <- runif(800)
e <- rnorm(800)

#### El t?rmino de perturbación o error se diferencia porque tiene distribución normal, con media 0 y desviación estándar 1.

#Instrumento 

z <- rnorm(800)

# Poblacional regression (Data Generating Process GDP)

Y <- 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 2.5*x5 + 0.8*x6 + 1.7*x7 + e
X <- cbind(matrix(1,800), x1,x2,x3,x4,x5,x6,x7)

ols <- function(M, Y , standar = T, Pvalue = T , instrumento = NULL, index = NULL){
  
  
  if (standar & Pvalue & is.null(instrumento) & is.null(index)){
    
    beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
    
    y_est <- M %*% beta  ## Y estimado 
    n <- dim(M)[1]  # filas
    k <- dim(M)[2] - 1  # variables sin contar el intercepto}
    df <- n- k ## grados de libertad
    sigma <- sum(sapply(Y - y_est , function(x) x ^ 2))/ df 
    
    Var <- sigma*solve(t(M) %*% M)
    sd <- sapply(diag(Var) , sqrt) ## raíz cuadrado a los datos de la diagonal principal de Var
    
    t.est <- abs(beta/sd)
    pvalue <-2*pt(t.est, df = df, lower.tail = FALSE) ## pt : t - student densidad
    lim_inf = beta - 1.96 * sd ## Dato para hallar los l?mites superiores e inferiores del intervalo del confianza
    lim_sup = beta + 1.96 * sd  
    table <- data.frame(OLS = beta,  
                        standar.error = sd, P.value = pvalue, L?mite_inferior : lim_inf, L?mite_superior : lim_sup)
    
    
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





