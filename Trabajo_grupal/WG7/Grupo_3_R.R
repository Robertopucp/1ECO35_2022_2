#---- TAREA 7 ----

# Cargamos librerías

install.packages("tidyverse")

library(readxl)
library(stringr)
library(tidyverse)


# Colocamos el directorio a trabajar

user <- Sys.getenv("fdcc0")

setwd(paste0("C:/Users/fdcc0/Desktop/PUCP/2022-2/R-PYTHON"))


data <- read_excel("C:/Users/fdcc0/Desktop/PUCP/2022-2/R-PYTHON/TAREA 7/data_administrativa.xlsx")


#---- 1. Convertir el nombre de las variables a minúscula -----

colnames(data) <- tolower(colnames(data))

# Se cambiaron exitosamente el nombre de las variables a minúsculas

#---- 2. Identificar nombre ----


data$nombre <- apply(data['nombre'],
                    1 ,
                    function(x) gsub("[0-9]+", '', x))

data$nombre <- apply(data['nombre'],
                     1 ,
                     function(x) gsub("[-/!.]", '', x))

#--- 3.Limpiar la fecha de nacimiento ----



data$born_date <- apply(data['born_date'],
                        1 ,  
                        function(x) str_extract(x,"[0-9]{2}/[0-9]{2}/[0-9]{4}"))

data$born_date <-  as.Date(data$born_date,format='%d/%m/%Y')


#----- 4. Limpiar la columna de edad,  ----

data$age <- apply(data['age'],
                        1 ,  
                        function(x) str_extract(x,"[0-9]+"))


#----- 5. Crear dummies según el rango del sentenciado --------

#dum2: toma el valor de 1 si el sentenciado fue cabecilla local
#dum3: toma el valor de 1 si el sentenciado fue cabecilla regional
#dum4: toma el valor de 1 si el sentenciado fue sicario
#dum5: toma el valor de 1 si el sentenciado realizó extorsión
#dum6: toma el valor de 1 si el sentenciado fue miembro regular
#dum7: toma el valor de 1 si el sentenciado fue novato o principiante

# primero limpiamos la variable rank

data$rank <- gsub('novto', 'novato', data$rank)
data$rank <- gsub('noato', 'novato', data$rank)
data$rank <- gsub('principiante', 'novato', data$rank)
data$rank <- gsub('extorsionador', 'extorsion', data$rank)

#creación de las dummies

data$dum1 <- ifelse(data$rank == "lider de la banda criminal", 1, 0)  
data$dum2 <- ifelse(data$rank == "cabecilla local", 1, 0)
data$dum3 <- ifelse(data$rank == "cabecilla regional", 1, 0)
data$dum4 <- ifelse(data$rank == "sicario", 1, 0)
data$dum5 <- ifelse(data$rank == "extorsion", 1, 0)
data$dum6 <- ifelse(data$rank == "miembro", 1, 0)
data$dum7 <- ifelse(data$rank == "novato", 1, 0)


#------- 6. Extraer el usuario del correo electrónico. -----

data$usuarios <- apply(data['correo_abogado'],
                       1,
                       function(x) str_extract(x,"^\\w+"))


#----- 7. Crear  columna con número de dni ----

data$num_dni <- apply(data['dni'],
                      1 ,  
                      function(x) str_extract(x,"[0-9]+[-]+[0-9]+"))



#---- 8. crear las siguiente variables ----

# crimen: debe contener información del delito cometido (ERROR 1 OBS)

data$crimen <- apply(data['observaciones'],
                      1 ,  
                       function(x) str_match(x,"\\.*[P/p]or\\s([\\w*]*)")[2])

# n_hijos: cantidad de hijos del criminal (OK)

data$n_hijos <- apply(data['observaciones'],
                     1 ,  
                     function(x) str_match(x,"\\.*[T/t]iene\\s([\\w*]*)")[2])

# edad_inicio : edad de inicio en actividades criminales

data$edad_inicio <- apply(data['observaciones'],
                     1 ,  
                     function(x) str_match(x,"\\.*[L/l]os\\s\\s([\\w*]*)")[2])
