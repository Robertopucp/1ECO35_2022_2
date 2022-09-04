#ejercicio 1

sample(0:500,20,replace=F)

x<- sample(0:500,20,replace=F)

funcion_1 <- function(x, z1, z2, z3){  
  z1 <= x ^ 1/2
  
ifelse(x<=100 | x ^ 1/2)

  z2 <= x - 5
  
ifelse(x<=300 | x - 5)
  
 z3<= 50

ifelse(x>=300 | print(50))         }


#Ejercicio 2


set.seed(123)

#Creo mi vector con 100 observaciones aleatorias
v1 <- c(runif(100, min=0, max=20))

#Creo mi matriz 100x50, igual que el vector anterior con numeros aleatorios
M1 <- matrix(runif(5000,min=0, max=10), nrow= 100, ncol= 50)
dim(M1) #con ello se comprueba que la matriz tiene 100 filas y 50 columnas
#Creo mi función

calculator_scalar <- function( v, M, n){
  if(! is.double(v)) stop("v must be a double")
  if(! is.double(M)) stop("M must be a double")
#Defino los componentes de mi función:   
  y <- v[n] 
  z <- M[,n]
  m3 <- min(z)
  m4 <- max(z)

  result= y-m3/ m4-m3
  
  return(result)
}  

#Pruebo mi función, con el índice 3, esto es el tercer componente de mi vector y la tercera columna de mi matriz    
calculator_scalar(v1,M1,3)


#ejercicio 3

set.seed(15)


x1 <- runif(1000)
x2 <- runif(1000)
x3 <- runif(1000)
x4 <- runif(1000)
x5 <- runif(1000)
e <- rnorm(1000)


# Poblacional regression (Data Generating Process GDP)

Y <- 1 + 0.6*x1 + 1.1*x2 + 0.5*x3 + 1.2*x4 + e
head(Y)

X <- cbind(matrix(1,1000),x1,x2,x3,x4)
head(X)

beta <- solve(t(X) %*% X) %*% (t(X) %*% Y)
beta


x11 <- sample(seq(x1),100)

x11





c  <- c(10, 50, 80, 120, 200, 500, 1000, 5000)
c[2]

x11 <- sample(seq(x1),c[1])
x22 <- sample(seq(x2),c[1])
x33 <- sample(seq(x3),c[1])
x44 <- sample(seq(x4),c[1])
x55 <- sample(seq(x5),c[1])
e <- rnorm(c[1])



Y <- 1 + 0.6*x11 + 1.1*x22 + 0.5*x33 + 1.2*x44 + e
head(Y)

X <- cbind(matrix(1,c[1]),x11,x22,x33,x44)
head(X)

beta10 <- solve(t(X) %*% X) %*% (t(X) %*% Y)
beta10



c  <- c(10, 50, 80, 120, 200, 500, 1000, 5000)
c[2]

x11 <- sample(seq(x1),c[2])
x22 <- sample(seq(x2),c[2])
x33 <- sample(seq(x3),c[2])
x44 <- sample(seq(x4),c[2])
x55 <- sample(seq(x5),c[2])
e <- rnorm(c[2])



Y <- 1 + 0.6*x11 + 1.1*x22 + 0.5*x33 + 1.2*x44 + e
head(Y)

X <- cbind(matrix(1,c[2]),x11,x22,x33,x44)
head(X)

beta50 <- solve(t(X) %*% X) %*% (t(X) %*% Y)
beta50

c  <- c(10, 50, 80, 120, 200, 500, 1000, 5000)
c[2]

for (i in 1:7)
{
  x11 <- sample(seq(x1),c[i])
  x22 <- sample(seq(x2),c[i])
  x33 <- sample(seq(x3),c[i])
  x44 <- sample(seq(x4),c[i])
  x55 <- sample(seq(x5),c[i])
  e <- rnorm(c[i])
  Y <- 1 + 0.6*x11 + 1.1*x22 + 0.5*x33 + 1.2*x44 + e
  head(Y)
  
  X <- cbind(matrix(1,c[i]),x11,x22,x33,x44)
  head(X)
  
  beta_all <- solve(t(X) %*% X) %*% (t(X) %*% Y)
  beta_all
}
