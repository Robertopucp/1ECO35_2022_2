<<<<<<< HEAD
################  laboratorio 1 ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Roberto Mendoza 

" Laboratorio 1 Python"

## ---------------------------------------------------------------------

"Types of variables"

" Correr la lineas de codugo Ctrl + enter"
"Codigo a texto Ctrl + Shift + c"

a2 <- 3.1614
print(a2)
typeof(a2)
class(a2)


a2 <- as.integer(a2)
typeof(a2)
class(a2)

b1 <- 10000
typeof(b1)

" ######## string  #############"

c1 <- "My first python code"
print(c1)
typeof(c1)
class(c1)

c1 <- "First python code"
c2 <- 'at R y python Class'
cat(c1," : ",c2)


a <- paste0(c1,' : semester 2022-1')


print(a)

d <- 2022
paste0(c1,' : semester ',d, '-1')


#first character

cat('Fisrt letter is :', substr(c1, 1,1)  )

#first word
cat('Fisrt word is :', substr(c1, 1,5)  )


"cat just contatenate characters to print"

## ---------------------------------------------------------------------

"2.0 Logical variables"

a == a

1 == 1

z1 <- (1==1)
typeof(z1)

z1 <- as.integer(z1)
print(z1)
class(z1)

z2 <- (10 > 20)
as.integer(z2)

z3 <- (100 != 100)
z3 <- as.numeric(z3)
typeof(z3)


"TRUE <> T , FALSE <> F"


## ---------------------------------------------------------------------

### 3.0 Array and Matrices

# 1D numeric array

" 3.1 c() Atomic vector: simple vector data"

a <- c(1,2,3,4,"Perú")
print(a)
class(a)
typeof(a[1])

c2 <- c("Red", "Green", "Purple")
print(c2)


a <- c(1,2,3,4)
a <- append(a, 5)

" 3.2 rep( number, times) "

b <-  rep(2,3) # repeat 2, 3 times 


append(a,b)

print(mean(a))
print(sd(a))

rep("blue", 3)

length( rep(sample(1:100, size = 10), 3) )


" 3.3 seq(from , to ,by ) "

y <- seq(from = 0, to = 19, by = 2)

y <- seq(0, 19, 2)

print(y)
typeof(y)

y[1]

# second example 

y <- seq( 1, 10)
print(y)

# Consecutives numbers

seq(100)
1:100
seq_len(100)

# split sequence in 50 parts

seq(100,1000, length.out = 50)


"3.4 Split vector"

indices <- split(seq(100), sort( seq(100) %% 3 ) )
indices


names(indices) <- c('training', 'est', 'test') ## add labels 
print(indices)

indices$est
indices$test

attributes(indices) # atributos 

"attribute : información de cualquier objeto en R"

" 3.5 Array: genera vectores multidimensionales R^n "

ar <- array(c(11:14, 21:24, 31:34), dim = c(2, 2, 3))
print(ar)
typeof(ar)  # tipo de elementos
class(ar)   # tipo de estrucutura del objeto


# array 1-dim vector 

a <- array(1:20)
n <- length(a)

print(sd(a)*sqrt((n-1)/n))  # take care standar deviation formula

# 2D array numeric

M <- matrix(c(1,2,3,4,5,6), nrow = 2, byrow =TRUE)

print(M)
typeof(M)
dim(M)

# Matrix by colum

M <- matrix(c(1,2,3,4,5,6), nrow = 2, byrow =FALSE)
print(M)

cat("rows: ", dim(M)[1], '\n', "Columns: ", dim(M)[2])

dim(M)[1]

# Create a 1D NumPy array with values from 0 to 20 (exclusively) incremented by 2.5:


" 3.6 Matrix "

A <- matrix(c(seq(0, 9), seq( 10, 19), seq( 30, 39), seq( -20, -11), seq( 2, 20,2)), nrow = 5, byrow =TRUE)
A

A[2:4,] # rows selecrtion

A[,1:6]  # columns selecrtion

A[,-c(2,3)] # drop columns 

# Join matrix and special Matrix

M1 <- matrix(0,8,2)

print(M1)

M2 <- matrix(1,8, 4) 
print(M2)

# horizontal stack 

M3 <- cbind(M1,M2)
M3

M4 = matrix(c(2,2,3,4,5,1,1,5,5,9,8,2), nrow =2, byrow = TRUE)
print(M4)

# vertical stack 

M5 <- rbind(M3,M4)

M5

## trasnpose

t(M5)

# Matrix Identity

I <- diag(8)
print(I)

# Reshape
I3 <- matrix(I, nrow = 32, ncol = 2)
print(I3)
typeof(I3)

"3.7 Factor"

university <- factor( c( rep("Licenciada",10), rep("No licenciada",100) ) )
attributes(university)


" 3. 8 List"

dis2 <- list('ATE', 'BARRANCO','BREÑA', 'CALLAO', 'CARABAYLLO','CHACLACAYO','CHORRILLOS','CIENEGUILLA'
             ,'COMAS','EL_AGUSTINO','INDEPENDENCIA')
dis2[[1]] # get element


dis1[2:5]

dis1[-1] # drop first element

# add new element
num <- list(13,5,5,8,9,10,5,8,13,1,20)
append(num, 102)
# add a list 
num2 <- list(10,20,30)
append(num, num2)


cat("Suma:", sum(unlist(num)),'\n', "Minimo:", min(unlist(num)), '\n', "Maximo:", max(unlist(num)))

list1 <- list(100:130, "R", list(TRUE, FALSE))

## ---------------------------------------------------------------------

### 3.0 OLS

set.seed(756)

x1 <- runif(500)
x2 <- runif(500)
x3 <- runif(500)
x4 <- runif(500)
e <- rnorm(500)

# Poblacional regression (Data Generating Process GDP)

Y <- 1 + 0.8*x1 + 1.2*x2 + 0.5*x3 + 1.5*x4 + e


#M1 <- matrix(0,8,2)

X <- cbind(matrix(1,500), x1,x2,x3,x4)
head(X)

#inv(X) or solve (X)

beta <- solve(t(X) %*% X) %*% (t(X) %*% Y)
beta












=======
a
>>>>>>> 2760e3776b0e3b5cb6826b012ab0692713fecab0
