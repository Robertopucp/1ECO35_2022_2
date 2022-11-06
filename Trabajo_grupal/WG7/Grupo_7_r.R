# install.packages("lubridate")
library(lubridate) # dmy() funcion para trabajar fechas

# Load libraries
library(readxl)
library(stringr)   # libreria para trabajar expresiones regulares 
library(tidyverse) # dplyr, ggplot2, tdyr


# "1.0 Set Directorio y leyendo datos"
user <- Sys.getenv("USERNAME")  # username
setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Lab6") ) # set directorio

data <- data.frame(read_excel("../data/crime_data/data_administrativa.xlsx"))


# 1. 
# Convertir el nombre de las variables a minúscula
colnames(data) <- tolower(colnames(data))   

# 2.
# Fíjese que el nombre de la persona tiene puntuaciones y número, retirar todo aquello 
# que no permita identificar el nombre correcto.
data$solo_nombre <- apply( data['nombre'],
                     1 ,  
                     function(x) gsub("[0-9]|\\/|\\-|\\.|\\!", '', x))  # eliminando números y signos en específico

# 3.
# Limpiar la fecha de nacimiento de aquellos elementos que la ensucien. 
data$fecha <- apply( data['born_date'],
                     1 ,  
                     function(x) str_extract(x,"[0-9]+/[0-9]+/[0-9]+"))

# Luego crear otra variable con el formato de fecha.
# convirtiendo string a formato fecha
data$fecha_formato <-  as.Date(data$fecha, format='%d/%m/%Y')


# 4.
# Limpiar la columna de edad, el cual tiene puntuaciones que no permiten identificar la edad correcta.
data$edad <- apply( data['age'],
                     1 ,  
                     function(x) str_extract(x,"[0-9]+"))


# 5.
# Crear dummies según el rango del sentenciado en la organización criminal
data<- data %>% mutate(dummy1 = ifelse( str_detect( rank,"lider de la banda criminal"), 1, 0 ),
                       dummy2 = ifelse( str_detect( rank,"cabecilla local"), 1, 0 ), 
                       dummy3 = ifelse( str_detect( rank,"cabecilla regional"), 1, 0 ),
                       dummy4 = ifelse( str_detect( rank,"sicario"), 1, 0 ),
                       dummy5 = ifelse( str_detect( rank,"extorsion|extorsionador"), 1, 0 ),
                       dummy6 = ifelse( str_detect( rank,"miembro"), 1, 0 ),
                       dummy7 = ifelse( str_detect( rank,"novato|novto|noato|principiante"), 1, 0 ))

# 7.
# Extraer el usuario del correo electrónico.
data$usuario_correo <- apply(data['correo_abogado'],
                              1 ,  
                              function(x) str_match(x,"\\w+"))

# 8. 
# Crear una columna que contenga solo la información del número de dni (por ejemplo: 01-75222677)
data$DNI <- apply( data['dni'],
                    1 ,  
                    function(x) str_extract(x,"[0-9]+-[0-9]+"))


# 9.
# A partir de la columna observaciones, crear las siguientes variables:
# - crimen: debe contener información del delito cometido
data$crimen <- sapply(data$observaciones,
                      function(x) str_extract(x,"(?<=sentenciado por )[[a-z]+\\s]*"))

# - n_hijos: cantidad de hijos del criminal
data$n_hijos <- sapply(data$observaciones,
                       function(x) str_extract(x,"(?<=tiene )[0-9]*"))

# - edad_inicio : edad de inicio en actividades criminales
data$edad_inicio <- sapply(data$observaciones,
                           function(x) str_extract(x,"[0-9]+(?= años)"))








