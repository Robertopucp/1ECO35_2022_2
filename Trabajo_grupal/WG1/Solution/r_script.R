
#######################################

" Homework 1 - solution  "
" @author: Roberto Mendoza "
" @date: 12/09/2020 "

#######################################

"1. IF statement and Loop"

vector <- sample( seq(500) , 20) # seq(500) valores entre 0 y 500, 20 observaciones

length(vector)

for (i in seq(20)){
  
  x <- vector[i]
  
  if (x<=100) { y = x^(0.5) 
  } else if (x>100 & x <=300) { y = x - 5 
  } else if (x>300) { y = 50 }
  
  vector[i] <- y
  
}


"2. IF statement and Loop, escalar function"


## Escalar a vector 

vector2 <- sample( seq(500) , 100) # seq(500) valores entre 0 y 500, 100 observaciones

length(vector2)

for (i in seq(100)){
  
  x <- vector2[i]
  max <- max(vector2)
  min <- min(vector2)
  
  y  <- (x - min)/(max-min)
  
  vector2[i] <- y
  
}

vector2

## Escalar Matrix

set.seed(756)

total <- 100*50 # total elements
  
elements <- sample(total) # random number

M <- matrix(elements , nrow = 100, ncol = 50) # reshape matrix

dim(M)

for (i in seq(dim(M)[2] )){
  
  max <- max(M[,i])
  min <- min(M[,i])
  
  
  for (j in seq(dim(M)[1] )){
  
    x <- M[j,i]

    y  <- (x - min)/(max-min)
  
    M[j,i] <- y
  }
}

print(M)

"3. OLS and Loop"



set.seed(756)

x1 <- runif(10000)
x2 <- runif(10000)
x3 <- runif(10000)
x4 <- runif(10000)
x4 <- runif(10000)
x5 <- rnorm(10000)
e <- rnorm(1000)

# Poblacional regression (Data Generating Process GDP)

Y <- 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 0.5*x5 + e


#M1 <- matrix(0,8,2)

X <- cbind(matrix(1,10000), x1,x2,x3,x5) # omitiendo la cuarta variable


size <- c(10,50,80,120,200,500,800,1000,5000)

beta <- matrix(0,length(size),5)
sd <- matrix(0,length(size),5)

Reg <- function(X,Y){
  
  beta <- solve(t(X) %*% X) %*% (t(X) %*% Y)
  y_est <- X %*% beta  ## Y estimado 
  n <- dim(X)[1]  # filas
  k <- dim(X)[2] - 1  # varaibles sin contar el intercepto}
  df <- n- k ## grados de libertad
  sigma <- sum(sapply(Y - y_est , function(x) x ^ 2))/ df 
  
  Var <- sigma*solve(t(X) %*% X)
  sd <- sapply(diag(Var) , sqrt) #
  
  
  return(list(beta,sd))
  
} 

j <- 0

for (i in size) {
  j <- j + 1
  filter <- sample( seq(10000) , i)
  X1 <- X[filter,] # filter filas de todas las columnas
  Y1 <- Y[filter]  # filter oservaciones del vector Y
  
  beta[j,] <- matrix ( unlist( Reg(X1,Y1)[1]), 1, 5)
  sd[j,] <- matrix ( unlist( Reg(X1,Y1)[2] ), 1, 5)
}

table <- data.frame(sample_size= size,  
                    beta_inter = beta[,1], sd_inter = sd[,1], 
                    beta_x1 = beta[,2], sd_x1= sd[,2], 
                    beta_x2 = beta[,3], sd_x2 = sd[,3], 
                    beta_x3 = beta[,4], sd_x3 = sd[,4], 
                    beta_x5= beta[,5], sd_x5 = sd[,5]
                    )

table



"4. Fucntion OLS"

x1 <- rnorm(800)
x2 <- rnorm(800)
x3 <- rnorm(800)
x4 <- rnorm(800)
x5 <- rnorm(800)
x6 <- rnorm(800)
x7 <- rnorm(800)

e <- rnorm(800)


Y <- 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 0.2*x5+0.5*x6+2*x7+e
X <- cbind(matrix(1,800), x1,x2,x3,x4,x5,x6,x7)


ols <- function(M, Y , intercepto = TRUE, Robust.sd = FALSE){
  
  
  if (intercepto){
    
    beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
    
    y_est <- M %*% beta  ## Y estimado 
    n <- dim(M)[1]  # filas
    k <- dim(M)[2] - 1  # varaibles sin contar el intercepto}
    df <- n- k ## grados de libertad
    
    if (Robust.sd==F){
    
        sigma <- sum(sapply(Y - y_est , function(x) x ^ 2))/ df 
        Var <- sigma*solve(t(M) %*% M)
        sd <- sapply(diag(Var) , sqrt) ## raíz cuadrado a los datos de la diagonal principal de Var
        
        t.est <- abs(beta/sd)
        pvalue <-2*pt(t.est, df = df, lower.tail = FALSE) ## pt : t - student densidad
        
        lower_bound <- beta-1.96*sd
        upper_bound <- beta+1.96*sd
        
        SCR <- sum(sapply(Y - y_est , function(x) x ^ 2))
        SCT <- sum(sapply(Y - mean(y_est) , function(x) x ^ 2))
        
        R2 <- 1-SCR/SCT
        
        rmse <- sqrt(SCR/n)
        
        table <- data.frame(OLS = beta,  
                            standar.error = sd, P.value = pvalue, Lower.bound=lower_bound ,
                            Upper.bound = upper_bound)
        
        fit_var <- c(R2,rmse)
    }else{
      
      
      Matrix_robust <- diag(sapply(Y - y_est , function(x) x ^ 2),n)
      
      
      
      
      Var <- solve(t(M) %*% M) %*% t(M) %*% Matrix_robust %*% t(M) %*% solve(t(M) %*% M)
      sd <- sapply(diag(Var) , sqrt) ## raíz cuadrado a los datos de la diagonal principal de Var
      
      t.est <- abs(beta/sd)
      pvalue <-2*pt(t.est, df = df, lower.tail = FALSE) ## pt : t - student densidad
      
      lower_bound <- beta-1.96*sd
      upper_bound <- beta+1.96*sd
      
      SCR <- sum(sapply(Y - y_est , function(x) x ^ 2))
      SCT <- sum(sapply(Y - mean(y_est) , function(x) x ^ 2))
      
      R2 <- 1-SCR/SCT
      
      rmse <- sqrt(SCR/n)
      
      table <- data.frame(OLS = beta,  
                          standar.error = sd, P.value = pvalue, Lower.bound=lower_bound ,
                          Upper.bound = upper_bound)
      
      fit_var <- c(R2,rmse)
      
    }
  
    
  }else {
    
    M <- M[,2:ncol(M)]
    
    beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)
    
    y_est <- M %*% beta  ## Y estimado 
    n <- dim(M)[1]  # filas
    k <- dim(M)[2] - 1  # varaibles sin contar el intercepto}
    df <- n- k ## grados de libertad
    
    if (Robust.sd==F){
      
      sigma <- sum(sapply(Y - y_est , function(x) x ^ 2))/ df 
      Var <- sigma*solve(t(M) %*% M)
      sd <- sapply(diag(Var) , sqrt) ## raíz cuadrado a los datos de la diagonal principal de Var
      
      t.est <- abs(beta/sd)
      pvalue <-2*pt(t.est, df = df, lower.tail = FALSE) ## pt : t - student densidad
      
      lower_bound <- beta-1.96*sd
      upper_bound <- beta+1.96*sd
      
      SCR <- sum(sapply(Y - y_est , function(x) x ^ 2))
      SCT <- sum(sapply(Y - mean(y_est) , function(x) x ^ 2))
      
      R2 <- 1-SCR/SCT
      
      rmse <- sqrt(SCR/n)
      
      table <- data.frame(OLS = beta,  
                          standar.error = sd, P.value = pvalue, Lower.bound=lower_bound ,
                          Upper.bound = upper_bound)
      
      fit_var <- c(R2,rmse)
    }else{
      
      
      Matrix_robust <- diag(sapply(Y - y_est , function(x) x ^ 2),n)
      
      
      Var <- solve(t(M) %*% M) %*% t(M) %*% Matrix_robust %*% M %*% solve(t(M) %*% M)
      sd <- sapply(diag(Var) , sqrt) ## raíz cuadrado a los datos de la diagonal principal de Var
      
      t.est <- abs(beta/sd)
      pvalue <-2*pt(t.est, df = df, lower.tail = FALSE) ## pt : t - student densidad
      
      lower_bound <- beta-1.96*sd
      upper_bound <- beta+1.96*sd
      
      SCR <- sum(sapply(Y - y_est , function(x) x ^ 2))
      SCT <- sum(sapply(Y - mean(y_est) , function(x) x ^ 2))
      
      R2 <- 1-SCR/SCT
      
      rmse <- sqrt(SCR/n)
      
      table <- data.frame(OLS = beta,  
                          standar.error = sd, P.value = pvalue, Lower.bound=lower_bound ,
                          Upper.bound = upper_bound)
      
      fit_var <- c(R2,rmse)
      
    }
    
  }
  
  return(list(table,fit_var))
  
  }
  
ols(X,Y)

ols(X,Y, intercepto = F, Robust.sd = T)














