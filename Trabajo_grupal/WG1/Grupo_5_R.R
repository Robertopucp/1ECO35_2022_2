library(dplyr) 
library(tidyr)
library(readxl)


set.seed(188) #Luego, definimos la random seed 188 
v1 =sample(500)#Posteriormente, creamos x que será un vector 1x20 con valores entre 0 y 500
x= sample(500,20)
print(x) #Comprobamos la matriz x

y=list()#Ahora, para el punto 1.1, definimos el vector y que tendrá como componentes a los valores de x
i <- length(x)
if (i > 0 and i <= 100) #Si i entre 0 y 100, el componente 1xi adoptará el valor de i^0.5
{y.append(i**0.5)}
{else: y.append(i**0)} #Caso contrario, se computará el valor de 1

print(y) #Comprobamos la matriz y 

z=list() #Ahora, para el punto 1.2, definimos el vector z que tendrá como componentes a los valores de x
i <- length(x):
  if  i > 100 and i <= 300: #Si i entre 100 y 300, el componente 1xi adoptará el valor de i-5
  z.append(i-5)
else: z.append(i**0) #Caso contrario, se computará el valor de 1

print(z) #Comprobamos la matriz z

k=() #Ahora, para el punto 1.3, definimos el vector k que tendrá como componentes a los valores de x
i <- length(x):
  if  i > 300 and i <= 500: #Si i entre 300 y 500, el componente 1xi adoptará el valor de 50
  k.append(50)
else: k.append(i**0) #Caso contrario, se computará el valor de 1

print(k) #Comprobamos la matriz z