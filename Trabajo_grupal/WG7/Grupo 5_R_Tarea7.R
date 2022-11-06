# Grupo 5 Tarea 7

library(haven)
library(readr)
library(readxl)
library(stringr) 
library(dplyr)
library(lubridate) 
library(tidyverse) 
library(fastDummies)
rm(list=ls(all=TRUE))

user <- Sys.getenv("USERNAME")  # username

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/Trabajo_grupal") ) # set directorio

data_criminales <- read_excel("../data/crime_data/data_administrativa.xlsx")

#Pregunta 1 Nombre de las variables en minúscula

colnames(data_criminales) <- tolower(colnames(data_criminales)) # capital letters to lower letters

#Pregunta 2 Retirar los puntos, números, etc

data_criminales$nombre2 <- apply(data_criminales['nombre'],
                      1 ,
                      function(x) str_replace(x,"[^a-zA-Z\\s]+",''))

#Lo expresamos en otra variable para notar el cambio

#Pregunta 3 Fecha de nacimiento

data_criminales$born_date <- apply(data_criminales['born_date'],
                        1 ,
                        function(x) str_replace(x,"(00:00)|(#%)|(!)", ''))

#Ahora, convertir a formaro fecha en otra variable

data_criminales$fecha_nacimiento <-  as.Date(data_criminales$born_date,format='%d/%m/%Y')

#Pregunta 4 Limpiar las edades 

data_criminales$edad2 <- apply(data_criminales['age'],
                    1 ,
                    function(x) str_extract(x,"[0-9]{1,}"))

#Creamos otra variable de edad para comparar los cambios filtrados
  
  #Pregunta 5 Dummies
  
  data_criminales <- dummy_cols(data_criminales, select_columns = 'rank') #Hay problemas de identificación de datos

unique(data_criminales$rank)

# "cabecilla local"            "cabecilla regional"         "miembro"                    "novato"                     "sicario"                   
# "lider de la banda criminal" "novto"                      "principiante"               "extorsionador"              "extorsion"                 
# "noato"  

#Debemos convertir "novto" "principiante" "novato" "noato" en categoría unica

data_criminales$novato <- ifelse(data_criminales$rank_novto == 1 | data_criminales$rank_principiante == 1 | data_criminales$rank_novato == 1 | data_criminales$rank_noato == 1, 1, 0)

#Debemos convertir "extorsionador" "extorsion" en categoría unica

data_criminales$extorsionador <- ifelse(data_criminales$rank_extorsionador == 1 | data_criminales$rank_extorsion == 1, 1, 0)

#Ahora, borramos las columnas que no nos sirven 

data_criminales$rank_novto <- NULL
data_criminales$rank_principiante <- NULL
data_criminales$rank_novato <- NULL
data_criminales$rank_noato <- NULL
data_criminales$rank_extorsionador <- NULL
data_criminales$rank_extorsion <- NULL

#Nos quedamos con las 7 dummies de ranking criminal 

#Pregunta 7 Extraer usuario de correo

str_match(data_criminales$correo_abogado, "(\\w+)\\@.*") #Aplicamos el código de extracción hasta antes del @ y obtendremos el usuario para la columna de correo 
#No lo hacemos variable porque no se indicó 

#Pregunta 8 Columna con número de DNI

data_criminales$número_dni <- apply(data_criminales['dni'],
                                    1 ,
                                    function(x) str_match(x,"\\.*(\\d+\\-\\d+)$")[2])

#Obtenemos la columna de dni filtrando por valores numéricos y - a las observaciones de dni

#Pregunta 9 Crear observaciones de delito, nhijos y edad de incio de actividades criminales

data_criminales$crimen <- apply(data_criminales['observaciones'],
                                1 ,
                                function(x) str_match(x,"\\.*+[r/p][\\w+^a-zA-Z\\s]+")) 

#Filtramos para tener las observaciones luego de p y r. Así, obtenemos los crímenes que cometieron de los que son acusados

data_criminales$n_hijos <- apply(data_criminales['observaciones'],
                                 1 ,
                                 function(x) str_match(x, "\\d+(?= hij[p/o]s)"))

#Filtramos para tener las observaciones numéricas antes de hij[p/o]s porque hay errores de escritura

data_criminales$edad_inicio <- apply(data_criminales['observaciones'],
                                     1 ,
                                     function(x) str_match(x, "\\d+(?= años)"))

#Filtramos para tener las observaciones numéricas antes de años 
