## Ejercicio 1

y <- runif(20,0,500)

for (i in y) {
if (i <0 & i <= 100) {
  next
    i <-  i^(1/2)
    
} else if (i > 100 & i <= 300) {
    i <- i - 5
  
} else {
      i <- 50
}
  y = i
}

print (y)




## Ejercicio 2

## Para la matriz



sample <- runif(5000,0,500)

M <- matrix(sample, 100, 50) 

if(! is.matrix(M)) stop("M must be a matrix")

calculator <- function (M,h,z) {
  h <- apply(M, 2, min)
  z <- apply(M, 2, max)
  
  result = (M - h) / (z - h)
  return(result)
}

calculator(M, h, z) [1]


# Para el vector

y <- runif(100,0,500)

if(! is.vector(y)) stop("y must be a vector")

calculator1 <- function (y,k,l) {
  k <- apply(y, 1, min)
  l <- apply(y, 1, max)
  
  result = (y - k) / (l - k)
  return(result)
}

calculator1(y, k, l) [1]




## Ejercicio 4


x1 <- runif(800)
x2 <- runif(800)
x3 <- runif(800)
x4 <- runif(800)
x5 <- runif(800)
x6 <- runif(800)
x7 <- runif(800)
e <- rnorm(800)

z <- rnorm(800)

c=1
Y <- c + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 1.2*x5 + 0.5*x6 + 1.5*x7 + e
X <- cbind(matrix(1,800), x1,x2,x3,x4,x5,x6,x7)

ols <- function(M, Y , standar = T, Pvalue = T , instrumento = NULL, index = NULL){
  
  
  if (standar & Pvalue & is.null(instrumento) & is.null(index)){
    
    beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
    
    y_est <- M %*% beta
    n <- dim(M)[1]  
    k <- dim(M)[2] - 1  
    df <- n- k
    sigma <- sum(sapply(Y - y_est , function(x) x ^ 2))/ df 
    
    Var <- sigma*solve(t(M) %*% M)
    sd <- sapply(diag(Var) , sqrt)
    
    t.est <- abs(beta/sd)
    pvalue <-2*pt(t.est, df = df, lower.tail = FALSE) ## pt : t - student densidad
    
    table <- data.frame(OLS= beta,  
                        standar.error = sd, P.value = pvalue)
    
    
  }
  
  
  if ( !is.null(instrumento) & !is.null(index) ){
    
    beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
    
    index <- index + 1
    
    Z <- X
    Z[,index] <- z
    
    beta_x <- solve(t(Z) %*% Z) %*% (t(Z) %*% X[,index])
    
    x_est <- Z %*% beta_x
    X[,index] <- x_est
    
    beta_iv <- solve(t(X) %*% X) %*% (t(X) %*% Y)
    
    table <- data.frame(OLS= beta,  
                        OLS.IV = beta_iv)
    
    
    
    return(table)
