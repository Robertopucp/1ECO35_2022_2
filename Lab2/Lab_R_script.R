################  laboratorio 2 ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Roberto Mendoza 


# -------------------------------------------------------
" If statement"


y <- runif(10,-10,10) # runif( n: cantidad de elementos, inicio , final)

if (mean(y) > 0){
  dummy <- 1
} else {
  dummy <- 0
}
  
print(dummy)  

"Nested If statement" 

# v <- 2
# v <- NA
# v <- "String"
v <- TRUE


if  ( is.numeric(v) ){
  cat(v, " es un numero entero (no missing)")
} else if ( is.na(v) ) {
  
  cat(v, " es un missing")
  
} else if ( is.character(v) ){
  
  cat(v, " es un string") 
  
} else if ( isTRUE(v) ){
  
  cat(v, " es un Boolean") 
  
} else {
  
  print("Sin resultado")
  
}

# -------------------------------------------------------
" While Loop"

#  sasve
S <- 1000

# Periods
n <- 10

# interes rate
i <- 0.025


year = 1
while (year < n){
  S <-  S*(1+i)
  year <-  year + 1
  cat( "periodo ", year, ": ", S,"\n")
}










