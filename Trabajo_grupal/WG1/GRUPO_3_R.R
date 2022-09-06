# EJERCICIO 1

myfunction <- function(x) {
  if (0 <= x & x <= 100) return(x^(1/2))
  else if (100 < x & x <= 300) return(x-5)
  else if (x > 300) return(50)
}

myfunction(400)

x <- sample(0:500,20,replace=F)
for (i in 1:20){
  x[i] = myfunction(x[i])
}
x


# EJERCICIO 2

set.seed(45)
xvector <- c(sample(100,replace=F))
xmatrix = matrix(as.integer(sample(10000,replace=F)),nrow = 100,ncol = 50)

escalar <- function(x,y) {
  if (is.vector(x)) return((x-min(x))/(max(x)-min(x)))
  else if (is.matrix(x)) return((x-min(x[,y]))/(max(x[,y])-min(x[,y])))
  else return("Base de datos incorrecta")
}

escalar(xvector)
escalar(xmatrix,50)



# EJERCICIO 3
# V=5, POBLACION= 10 000

#install.packages("dplyr")
library(dplyr)

#  Total de la población
pop <- 100000

# Generar 5 Variables: runif(tamaño, min,max)
a = 1; b = 99 # Se toma a y b como los  mínimos y máximos
V1 <- as.data.frame(runif(pop, a, b)) 
V2 <- as.data.frame(runif(pop, a, b))
V3 <- as.data.frame(runif(pop, a, b)) 
V4 <- as.data.frame(runif(pop, a, b)) 
V5 <- as.data.frame(runif(pop, a, b)) 

# Tamaños de  muestra: 
muestras <- list(10, 50, 80, 120, 200, 500, 800, 100, 5000)

# Organizamos listas para cada coeficiente de la muestra:
Big = list() 
for (variable in 1:length(muestras)) {
  tam=muestras[[variable]] # Tamaño de la muestra
  data=sample(data.frame(cbind(V1,V2,V3,V4,V5)),
              size=tam, replace = TRUE)%>%
    `colnames<-`(c("V1","V2","V3","V4","V5"))
  data$y=data$V1+data$V2+data$V3+data$V4+data$V5
  
  # Corremos la regresión planteada
  model <- lm(y ~ V1+V2+V3+V4+V5, data)
  betas<-summary(model)$coefficient[,1]
  df<-as.data.frame(cbind(t(betas),tam))
  Big[[variable]]=df
}

# Apilamos los resultados
BIG_D = do.call(bind_rows, Big)

BIG_D = BIG_D[ , order(names(BIG_D))] # Ordenamos por nombres
rm(Big, data) # Borramos el objeto
