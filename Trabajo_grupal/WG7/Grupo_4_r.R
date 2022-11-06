%>% ############################################################################
#                                                                              #
#                              TAREA 7 - GRUPO 4                               #
#                                                                              #
################################################################################

# Flavia Oré - 20191215
# Seidy Ascencios - 20191622
# Luana Morales - 20191240
# Marcela Quintero - 20191445


#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 1                                    # 
#                                                                              #
#------------------------------------------------------------------------------#

#Recursos necesarios para la pregunta
pacman::p_load(haven,dplyr, stringr, fastDummies,srvyr )

library(readxl)
library(stringr) 
library(haven)
library(dplyr)
library(tidyverse)
library (reshape)

#Seteamos el directorio

user <- Sys.getenv("USERNAME") 

setwd( paste0("C:/Users/",user,"/Documents/GitHub/1ECO35_2022_2/data/crime_data") ) 

data_administrativa <- read_excel("data_administrativa.xlsx")

sapply(data_administrativa, typeof)

apply(data_administrativa , 2, function(x) sum(is.na(x)))

#Covertimos el nombre de las variables en minusculas

colnames(data_administrativa) <- tolower(colnames(data_administrativa))


#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 2                                    # 
#                                                                              #
#------------------------------------------------------------------------------#

#Limpiamos la columna nombre

data_administrativa$nombre<- apply(data_administrativa['nombre'],
                                   1 ,  
                                   function(x) str_replace(x,"[^a-zA-Z\\s]+",''))

#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 3                                    # 
#                                                                              #
#------------------------------------------------------------------------------#

#Limpiamos la fecha de nacimiento de aquellos elementos que la ensucien

data_administrativa$born_date<- apply(data_administrativa['born_date'],
                                      1 ,  
                                      function(x) str_replace(x,"(00:00)|(!)|(#)|(%)",''))

#Creamos la nueva variable en formato fecha                                                            

data_administrativa$fecha_nacimiento <-as.Date(data_administrativa$born_date,format='%d/%m/%Y')

#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 4                                    # 
#                                                                              #
#------------------------------------------------------------------------------#

# Limpiamos la columna age                           
data_administrativa$age <- apply(data_administrativa['age'],
                                 1 ,  
                                 function(x) gsub("[^0-9]", '', x))

#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 5                                    # 
#                                                                              #
#------------------------------------------------------------------------------#

#Creamos dummies según el rango del sentenciado en la organización criminal

#dum1: toma el valor de 1 si el sentenciado fue líder de la banda criminal
#dum2: toma el valor de 1 si el sentenciado fue cabecilla local
#dum3: toma el valor de 1 si el sentenciado fue cabecilla regional
#dum4: toma el valor de 1 si el sentenciado fue sicario
#dum5: toma el valor de 1 si el sentenciado realizó extorsión
#dum6: toma el valor de 1 si el sentenciado fue miembro regular
#dum7: toma el valor de 1 si el sentenciado fue novato o principiante

#Limpiamos la variable novate y extorsion

data_administrativa$rank<- apply(data_administrativa['rank'],
                                 1 ,  
                                 function(x) str_replace(x,"(novto)|(noato)|(principiante)",'novato'))

data_administrativa$rank<- apply(data_administrativa['rank'],
                                 1 ,  
                                 function(x) str_replace(x,"(extorcionador)",'extorsion'))
#Creamos las variables dummies

data_administrativa$dum1 <- ifelse(data_administrativa$rank == 'lider de la banda criminal', 1, 0)
data_administrativa$dum2 <- ifelse(data_administrativa$rank == 'cabecilla local', 1, 0)
data_administrativa$dum3 <- ifelse(data_administrativa$rank == 'cabecilla regional', 1, 0)
data_administrativa$dum4 <- ifelse(data_administrativa$rank == 'sicario', 1, 0)
data_administrativa$dum5 <- ifelse(data_administrativa$rank == 'extorsion', 1, 0)
data_administrativa$dum6 <- ifelse(data_administrativa$rank == 'miembro', 1, 0)
data_administrativa$dum7 <- ifelse(data_administrativa$rank == 'novato', 1, 0)

#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 7                                    # 
#                                                                              #
#------------------------------------------------------------------------------#

#Extraemos el usuario del número de correos

data_admi$correo_abogado <- apply(data_administrativa['correo_abogado'],
                                  1 ,  
                                  function(x) str_extract(x,"[\\w+)\\@\\.*]"))
#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 8                                    # 
#                                                                              #
#------------------------------------------------------------------------------#

#Creamos una columna con información del dni
data_administrativa$dni <- apply(data_administrativa['dni'],
                                 1 ,  
                                 function(x) str_replace(x,"(dni es)", ''))
#------------------------------------------------------------------------------#
#                                                                              #
#                                PREGUNTA 9                                    # 
#                                                                              #
#------------------------------------------------------------------------------#

# Creamos las siguientes variables

#crimen: debe contener información del delito cometido
#n_hijos: cantidad de hijos del criminal
#edad_inicio : edad de inicio en actividades criminales

#Creamos la variable crimen

data_administrativa$crimen <- data_administrativa$observaciones |> str_extract("(?<= por )[^\\d\\:]+")

data_administrativa$crimen <- apply(data_administrativa['crimen'],
                                    1 ,  
                                    function(x) str_replace(x,"(tiene)|(dice tener)|(inio de actividades ilegales) |(,)", ''))

#Creamos la variable número de hijos del criminal

data_administrativa$n_hijos <- data_administrativa$observaciones |> str_extract("(?<=tiene )[\\d+\\:]+")

#Creamos la variable inicio en actividades criminales

data_administrativa$edad_inicio <- data_administrativa$observaciones |> str_extract("[\\d+\\:]+(?= años)")
