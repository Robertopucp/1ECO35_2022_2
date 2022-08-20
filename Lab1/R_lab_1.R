a <- 3

a <- b <- 4

a

a <- b = 4

a <- b <-5
a

a1 <- 52
print(a1)
typeof(a1)  
class(a1)

# "typeof" how the object is stored and "class" is the type of object 

# double use more memory than float 

# integer, single precision and double precision

a2 <- 3.1614
print(a2)
typeof(a2)

a2 <- as.integer(a2)
typeof(a2)
class(a2)

b1 <- 10000
typeof(b1)

b2 <- 8
typeof(b2)

c1 <- "My first python code"
print(c1)
typeof(c1)
class(c1)

c1 <- "First python code"
cat(c1, '\n','\n')

c2 <- 'Lab1 Pucp'
cat(c1," : ",c2)

#install.packages("devtools")

library(glue)
a <- glue('{c1} : semester 2022-1')
a

typeof(a)
class(a)

d <- 2022
glue('{c1} : semester {d}-1')

sprintf(" %s. : %s.-1", c1, d)


#first character
cat('Fisrt letter is :', substr(c1, 1,1)  )

#first word
cat('Fisrt word is :', substr(c1, 1,5)  )

## 2.0 Logical variables

It’s used to represent the truth value of an expression.

a == a

1 == 1

z1 <- (1==1)
typeof(z1)
class(z1)

z1 <- as.integer(z1)
print(z1)
class(z1)

z2 <- (10 > 20)
as.integer(z2)

z3 <- (100 != 100)
z3 <- as.integer(z3)
typeof(z3)

## 3.0 List


L1 <- list()

dis1 <- list('ATE', 'BARRANCO','BREÑA', 'CALLAO', 'CARABAYLLO')
dis1

typeof(dis1)
class(dis1)

dis2 <- list('ATE', 'BARRANCO','BREÑA', 'CALLAO', 'CARABAYLLO','CHACLACAYO','CHORRILLOS','CIENEGUILLA'
             ,'COMAS','EL_AGUSTINO','INDEPENDENCIA')
dis2

dis1[1]

typeof(dis1[1])
class(dis1[1])

#double [] to get a singular object 

typeof(dis1[[1]])

#dis1 <- list('ATE', 'BARRANCO','BREÑA', 'CALLAO', 'CARABAYLLO')

dis1[2:5]

dis1[-1] # drop first element

dis1[-5]

num <- list(13,5,5,8,9,10,5,8,13,1,20)
#print(num)

length(num) # number of elements 

typeof(num[[11]])
print(num[[11]])

num[[11]]

# unlist to order, then covert list again 

a <- sort(unlist(num))
print(list(a))
a[11]

max(unlist(num))

#dis2 <- list('ATE', 'BARRANCO','BREÑA', 'CALLAO', 'CARABAYLLO','CHACLACAYO','CHORRILLOS','CIENEGUILLA'
#            ,'COMAS','EL_AGUSTINO','INDEPENDENCIA')

length(dis2)

#add a single element

num <- append(num, 102)

num

# add a list 

num2 <- list(10,20,30)
append(num, num2)


cat("Suma:", sum(unlist(num)),'\n', "Minimo:", min(unlist(num)), '\n', "Maximo:", max(unlist(num)))

# add type of objects

new_list <- list(c(1,2,3),         
                 "R ", 
                 120)
print(new_list)

## List part 2 - dictionary

# using list as dictionary in python 

Postal_code <- list(Majes = 40520, Mollendo = 40701, Islay = 40704, Cotahuasi = 40801, Alca = 40802 )
print(Postal_code)

Postal_code$Alca

# add package to make operations 

install.packages("rlist")
library(rlist)


# empty list 

a <- list()

#make empty
Postal_code <- list.remove(Postal_code)
Postal_code

Postal_code <- list(Majes = 40520, Mollendo = 40701, 
                    Islay = 40704, Cotahuasi = 40801, Alca = 40802 )
print(Postal_code)

Postal_code$Islay

a <- list.remove(Postal_code,"Islay")
a

# add new key

Postal_code <- append(Postal_code, list(CHARCANA =  40803 ))
Postal_code

Postal_code <- append(Postal_code, list(LOMAS =  list(UBIGEO = 40311, Poverty_Rate = "18.2%", Population = "20 mil")))

Postal_code$LOMAS$Population

Postal_code$LOMAS$Poverty_Rate

### 3.0 Array and Matrices

# 1D numeric array

a <- c(1,2,3,4,5)


print(a)
typeof(a)
class(a)

print(mean(a))
print(sd(a))

Standar deviation in R

\begin{equation}
sd(x) = \sqrt{\frac{\sum(x_i-\bar{x})^2}{N-1}}
\end{equation}

# take care standar deviation formula

n <- length(a)

print(sd(a)*sqrt((n-1)/n))

# 2D array numeric

M <- matrix(c(1,2,3,4,5,6), nrow = 2, byrow =TRUE)

print(M)
typeof(M)

#colMeans(M)
#rowMeans(M)
#cat(colMeans(M, dim = 1), "\n", colMeans(M, dim = 2))

M <- matrix(c(1,2,3,4,5,6), nrow = 2, byrow =FALSE)
print(M)

cat("rows: ", dim(M)[1], '\n', "Columns: ", dim(M)[2])

dim(M)[1]

# Create a 1D NumPy array with values from 0 to 20 (exclusively) incremented by 2.5:

y <- matrix(seq(0,19,2))
class(y)
print(y)
typeof(y)

y[2]

y <- matrix(seq( 1, 10))
print(y)

for (i in y) {
  print(i+1)    
}

A <- matrix(c(seq(0, 9), seq( 10, 19), seq( 30, 39), seq( -20, -11), seq( 2, 20,2)), nrow = 5, byrow =TRUE)
A

A[2:4,] # rows selecrtion

A[,1:6]  # columns selecrtion

A[,-c(2,3)]

# Join matrix and special Matrix

M1 <- matrix(0,8,2)

print(M1)

M2 <- matrix(1,8, 4) 
print(M2)

M3 <- cbind(M1,M2)
M3

M4 = matrix(c(2,2,3,4,5,1,1,5,5,9,8,2), nrow =2, byrow = TRUE)
print(M4)

M5 <- rbind(M3,M4)

M5

## trasnpose

t(M5)


I <- diag(8)
print(I)

I3 <- matrix(I, nrow = 32, ncol = 2)
print(I3)
typeof(I3)

set.seed(756)

#x1 = runif(500, min = 0, max = 1)
x1 <- runif(500)
x2 <- runif(500)
x3 <- runif(500)
x4 <- runif(500)
#random.seed(123)
e <- rnorm(500)

# Poblacional regression (Data Generating Process GDP)

Y <- 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e


#M1 <- matrix(0,8,2)

X <- cbind(matrix(1,500), x1,x2,x3,x4)
head(X)

#inv(X) or solve (X)

beta <- solve(t(X) %*% X) %*% (t(X) %*% Y)
beta

