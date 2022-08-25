################  laboratorio 1 ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Roberto Mendoza 

" Laboratorio 1 Python"

# "typeof" how the object is stored and "class" is the type of object 

# double use more memory than float 

# integer, single precision and double precision

## ---------------------------------------------------------------------

"Types of variables"

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
z3 <- as.integer(z3)
typeof(z3)

## ---------------------------------------------------------------------

### 3.0 Array and Matrices

# 1D numeric array

a <- c(1,2,3,4,"Perú")
print(a)

a <- c(1,2,3,4)
a <- append(a, 5)
b <-  rep(2,3) # repeat 2 3 times 
append(a,b)

print(mean(a))
print(sd(a))

# take care standar deviation formula

n <- length(a)

print(sd(a)*sqrt((n-1)/n))

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

y <- seq(0,19,2)
print(y)
typeof(y)

y[1]

# second example 

y <- seq( 1, 10)
print(y)

# Matrix

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

