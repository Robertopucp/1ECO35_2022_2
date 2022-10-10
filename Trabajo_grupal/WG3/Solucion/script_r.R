################  WG3 R script ############################
## Curso: Laboratorio de R y Python ###########################
## @author: Roberto Mendoza 


# Loop replacement a un vector 

vector = sample(1:500, size = 100)


escalar <- function (x, min_x, max_x){ (x - min_x)/(max_x - min_x) }


lapply(vector, escalar, min_x = min(vector), max_x = max(vector))


sapply(vector, escalar, min_x = min(vector), max_x = max(vector) )



# Loop replacement a una matrix

elements <- sample(5000) # random number

M <- matrix(elements , nrow = 100, ncol = 50) # reshape matrix


escalar <- function(x){ (x-min(x))/(max(x) - min(x)) }


apply(M, 2, escalar)  # 2 para que aplicase la función por columnas































