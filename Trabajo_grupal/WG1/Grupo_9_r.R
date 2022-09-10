#Grupo _ 9

#20180783	Romina Garibay
#20183566	Marissa Vergara
#20163164	Lisbeth Morales


############Ej.1############


v <- sample(0:500, size = 20)    #vector cuyos datos estén entre 0 y 500, el vector tiene 20 datos
v

for (i in v){                    #aplicando la condicion
  if(i >= 0  & i <= 100){
    print(i^0.5)
  }
  else if(i > 100  & i <= 300){
    print(i-5)
  }
  else if (i > 300){
    print(50)      
  }
}                                #se imprime los resultados de dependiendo del tipo de valor que hay en el vector


############Ej.2############

fescalar <- function(x){
  if(! is.array(x)) stop("Error: el tipo de variable no es un vector o matriz.")     #se verifica que es vector o matriz
  
  M1 <- matrix(0,dim(x)[1],dim(x)[2])                     #si es vector o matriz, se aplica la condicion de rescalar
  
  for (i in seq(dim(x)[2])){
    m <- x[,i]
    M1[,i] <- round((x[,i] - min(m))/(max(m)-min(m)),2)
  }
  return(M1)
}

#generar vector (debe contar con 100 observaciones)
v <- matrix(sample.int(100,size=100,replace=TRUE),nrow=100,ncol=1)
fescalar(v)

#generar matrix (100 x 50)
M<-matrix(sample.int(100,size=500,replace=TRUE),nrow=100,ncol=50)
fescalar(M)




############Ej.3############

#Proceso generador de datos con 5 variables (1 + x1 + x2 + x3 + x4 ) 
set.seed(756)
x1 <- runif(10000)
x2 <- runif(10000)
x3 <- runif(10000)
x4 <- runif(10000)
e <- rnorm(10000)

Y  <- 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4  + e  #10 000 observaciones

mat <- cbind(Y,matrix(1,length(Y), 1),x1,x2,x3)   # se deja de lado x4 (por indicacion de tarea) 
#"==>estime los coeficientes de un modelo de regresión lineal omitiendo una variable explicativa" 
#"del proceso generador de datos."
head(mat)


#se piden muestras de 10 a 5000

muestra <- c(10,50,80,120,200,500,800,1000,5000)

#para cada muestra evaluar los betas y errores estandar:

for (m in muestra) {
  
  elegidos=sample(seq(10000) , m,replace=F)      #1. eleccion de observaciones al azar para el tamaño de muestra m
  observ=mat[elegidos,]                         #2. construir matriz con observaciones elegidas
  
  #2.a. matriz de X elegidas
  X=observ[, -c(1)]                              
  #2.b. matriz de Y elegidas
  Y=observ[, 1]
  
  
  #3.obtener betas
  beta <- solve(t(X) %*% X) %*% (t(X) %*% Y)
  beta
  
  #4. obtener sd
  y_est <-  X %*% beta  
  n  <- dim(X)[1]
  k  <- dim(X)[2] - 1
  df <- n -k 
  sigma <- sum(sapply(Y - y_est, function(x)x^2))/ df
  var <- sigma*solve(t(X) %*% X)
  
  sd <- sapply(diag(var), sqrt)
  
  #5. crear array para colocar el valor de la muestra en el dataframe
  tamano=matrix(m,length(beta), 1)
  
  
  #6. crear dataframe
  table <- data.frame(tamano,beta,sd)
  
  #7. Resultado
  print(table)
}



############Ej.4############
#Proceso generador de datos con 8 variables (1 + x1 + x2 + x3 + x4 + x5 + x6 + x7) 
set.seed(756)
x1 <- runif(800)
x2 <- runif(800)
x3 <- runif(800)
x4 <- runif(800)
x5 <- runif(800)
x6 <- runif(800)
x7 <- runif(800)
e <- rnorm(800)

Y <- 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + 2*x5 + 3*x6 + 1.5*x7 + e   #800 observaciones

X <- cbind(matrix(1,800),x1,x2,x3,x4,x5,x6,x7)  #x con 1 intercepto y 7 variables x
head(X)


#definir funcion: 
#Incluye,
#argumento de que incluye intercepto por default
#argumento de heterocedasticidad (es homocedastico por default)


ols <- function(M, Y, standar =T, Pvalue = T, intercepto = T, homocedastico =T) {
  #1. obtener beta
  beta <- solve(t(M) %*% M) %*% (t(M) %*% Y)   #los betas no se alteran por ser homo o heterocedastico
  
  y_est <-  M %*% beta   
  y_mean <- mean(Y)
  n  <- dim(M)[1]
  k  <- dim(M)[2] - 1
  df <- n -k 
  
  ee=sapply(Y - y_est, function(x) x^2)
  
  SCR=sum(ee)
  SCT=sum(sapply(Y - y_mean, function(x) x^2))
  
  
  #2. Root Mse
  root_mse=(SCR/n)^(1/2)
  
  #3. R cuadrado
  R_cuadrado=1-SCR/SCT
  
  #Primera respuesta en vector:
  vector <- c("rootmse",root_mse,"Rcuadrado",R_cuadrado)   
  print(vector)
  
  #En el caso de ser homocedastico evaluar:
  if (standar & Pvalue & intercepto & homocedastico) {
    
    sigma2 <- SCR/ df
    
    Var <- sigma2*solve(t(M) %*% M)
    sd <- sapply(diag(Var), sqrt)
    
    t.est <- abs(beta/sd)
    pvalue <- 2*pt(t.est,df=df, lower.tail = FALSE)
    
    L.inf <-  beta - 1.96 * sd 
    L.sup <-  beta + 1.96 * sd
    
    table <- data.frame(OLS = beta, standar.error =sd, value =pvalue, Lim.inferior= L.inf, Lim.superior =L.sup)
    
    return(table)
  }
  
  #En el caso de no ser homocedastico evaluar
  else if (homocedastico==F) {
    
    white=diag(n)*ee
    
    VarCorg=solve(t(M) %*% M)%*%t(M)%*%white%*%M%*%solve(t(M) %*% M)
    
    sd= sapply(diag(VarCorg), sqrt)
    
    t.est <- abs(beta/sd)
    
    pvalue <- 2*pt(t.est,df=df, lower.tail = FALSE)
    
    L.inf <-  beta - 1.96 * sd 
    L.sup <-  beta + 1.96 * sd
    
    table <- data.frame(OLS = beta, standar.error =sd, value =pvalue, Lim.inferior= L.inf, Lim.superior =L.sup)
    return(table)
  }
}

#Caso homocedastico    
ols(X,Y)


#Caso heterocedastico
ols(X,Y,homocedastico = F)  
#Cuando hay heterocedasticidad, la varianza modificada afecta el error estandar, pvalue, limites.
#No cambia los R2 y Rootmse pues solo explican como los betas estimados ajustan la linea de regresion, 
#y con la matriz de white los betas no han cambiado. 

